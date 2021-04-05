# The MIT License (MIT)
#
# Copyright (c) 2018 Status Research & Development GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#
#
# This code was taken from the stint package (https://github.com/status-im/nim-stint), file stint/private/uint_div.nim, and adapted for 128-bit integers with some changes.

func div2n1n(q, r: var uint64, n_hi, n_lo, d: uint64) {.inline.} =
  const
    size = 64
    halfSize = size div 2
    halfMask = (1'u64 shl halfSize) - 1'u64

  template halfQR(n_hi, n_lo, d, d_hi, d_lo: uint64): tuple[q, r: uint64] =

    var (q, r) = (n_hi div d_hi, n_hi mod d_hi)
    let m = q * d_lo
    r = (r shl halfSize) or n_lo

    # Fix the reminder, we're at most 2 iterations off
    if r < m:
      dec q
      r += d
      if r >= d and r < m:
        dec q
        r += d
    r -= m
    (q, r)

  let
    d_hi = d shr halfSize
    d_lo = d and halfMask
    n_lohi = nlo shr halfSize
    n_lolo = nlo and halfMask

  # First half of the quotient
  let (q1, r1) = halfQR(n_hi, n_lohi, d, d_hi, d_lo)

  # Second half
  let (q2, r2) = halfQR(r1, n_lolo, d, d_hi, d_lo)

  q = (q1 shl halfSize) or q2
  r = r2

func div3n2n(q: var uint64, r: var UInt128, a2, a1, a0: uint64, b: UInt128) {.inline.} =
  var
    c: uint64
    d: UInt128
    carry: bool

  if a2 < b.hi:
    div2n1n(q, c, a2, a1, b.hi)

  else:
    q = 0'u64 - 1'u64 # We want 0xFFFFF ....
    c = a1 + b.hi
    if c < a1:
      carry = true

  d.lo = mul64by64To128(q, b.lo, d.hi)
  let ca0 = UInt128(hi: c, lo: a0)
  r = ca0 - d

  if (not carry) and d > ca0:
    dec(q)
    r += b

    # if there was no carry
    if r > b:
      dec(q)
      r += b

func div2n1n(q, r: var UInt128, ah, al, b: UInt128) {.inline.} =
  var s: UInt128
  
  div3n2n(q.hi, s, ah.hi, ah.lo, al.hi, b)
  div3n2n(q.lo, r, s.hi, s.lo, al.lo, b)

func divmodImpl(x, y: UInt128, remainder: var UInt128): UInt128 {.inline.} =
  let
    x_clz = countLeadingZeroBits(x)
    y_clz = countLeadingZeroBits(y)
  
  #if (y.hi or y.lo) == 0:
  #  raise newException(DivByZeroError, "You attempted to divide by zero")
  if y_clz == 127:
    result = x
  elif (x.hi or y.hi) == 0:
    result.lo = x.lo div y.lo
    remainder.lo = x.lo mod y.lo
  elif (y and (y - one(UInt128))) == zero(UInt128):
    let y_ctz = 128 - y_clz - 1

    result = x shr y_ctz
    remainder = x and (y - one(UInt128))
  elif x == y:
    result.lo = 1'u64
  elif x < y:
    remainder = x
  elif (y_clz - x_clz) < 8:
    var
      shift = y_clz - x_clz
      denominator = y shl shift
    
    remainder = x

    while shift >= 0:
      result += result

      if remainder >= denominator:
        remainder -= denominator
        result.lo = result.lo or 1'u64
      
      denominator = denominator shr 1

      dec(shift)
  else:
    if y.hi == 0:
      if x.hi < y.lo:
        let
          clz = countLeadingZeroBits(y.lo)
          xx = x shl clz
          yy = y.lo shl clz
        
        div2n1n(result.lo, remainder.lo, xx.hi, xx.lo, yy)
        
        remainder.lo = remainder.lo shr clz
        return
    
    var
      xxhi: UInt128
      xxlo = x

    shl256(xxhi, xxlo, y_clz)

    let yy = y shl y_clz
    
    div2n1n(result, remainder, xxhi, xxlo, yy)

    remainder = remainder shr y_clz
