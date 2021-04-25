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
    n_lohi = n_lo shr halfSize
    n_lolo = n_lo and halfMask

  # First half of the quotient
  let (q1, r1) = halfQR(n_hi, n_lohi, d, d_hi, d_lo)

  # Second half
  let (q2, r2) = halfQR(r1, n_lolo, d, d_hi, d_lo)

  q = (q1 shl halfSize) or q2
  r = r2
