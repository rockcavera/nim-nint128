import std/bitops

import ../nint128_bitwise, ../nint128_cast, ../nint128_comparisons, ../nint128_types, ../nint128_cint128

import ./minus, ./multiplication, ./subtraction

include ../vendor/stint/div2n1n

template deltaShiftLimit(x: int): int =
  # 128div64
  when x == 0:
    when defined(amd64): 13
    elif defined(i386): 7
    else: 8
  
  # 128div128
  elif x == 1:
    when defined(amd64): 16
    elif defined(i386): 13
    else: 8

func nimDivModImpl(x, y: UInt128, remainder: var UInt128): UInt128 {.inline.} =
  # Known cases that the performance is significantly worse than the GCC and
  # CLANG divmod implementation for 128-bit integers:
  var
    dividend = x
    divisor = y
    shift: int

  block divShift:
    if divisor.hi == 0:
      if (divisor.lo and (divisor.lo - 1)) == 0:
        if divisor.lo == 0:
          divisor.lo = uint64(1 div int(divisor.lo)) # intentional division by
                                                     # zero (SIGILL or SIGFPE?)
        result = dividend shr countTrailingZeroBits(divisor.lo)
        remainder.lo = dividend.lo and (divisor.lo - 1)
        return

      if dividend.hi == 0:
        result.lo = dividend.lo div divisor.lo
        remainder.lo = dividend.lo mod divisor.lo
        return

      if dividend.hi == divisor.lo:
        result.lo = dividend.lo div divisor.lo
        remainder.lo = dividend.lo mod divisor.lo
        result.hi = 1'u64
        return

      let divisor_clz = countLeadingZeroBits(divisor.lo)
      
      if dividend.hi < divisor.lo:
        shift = 64 + divisor_clz - countLeadingZeroBits(dividend.hi)

        if shift < deltaShiftLimit(0): break divShift

        dividend = dividend shl divisor_clz
        divisor.lo = divisor.lo shl divisor_clz

        div2n1n(result.lo, remainder.lo, dividend.hi, dividend.lo, divisor.lo)

        remainder.lo = remainder.lo shr divisor_clz
      else:
        result.hi = dividend.hi div divisor.lo
        dividend.hi = dividend.hi mod divisor.lo
        dividend = dividend shl divisor_clz
        divisor.lo = divisor.lo shl divisor_clz

        div2n1n(result.lo, remainder.lo, dividend.hi, dividend.lo, divisor.lo)

        remainder.lo = remainder.lo shr divisor_clz

      return

    if divisor.hi == dividend.hi:
      if divisor.lo == dividend.lo:
        result.lo = 1'u64
      elif divisor.lo < dividend.lo:
        remainder.lo = dividend.lo - divisor.lo
        result.lo = 1'u64
      else:
        remainder = dividend
      return

    if divisor.hi > dividend.hi:
      remainder = dividend
      return

    let divisor_clz = countLeadingZeroBits(divisor.hi)

    if (divisor and (divisor - one(UInt128))) == zero(UInt128):
      let divisor_ctz = 127 - divisor_clz

      result = dividend shr divisor_ctz
      remainder = dividend and (divisor - one(UInt128))
      return

    shift = divisor_clz - countLeadingZeroBits(dividend.hi)

    if shift < deltaShiftLimit(1): break divShift

    var m: UInt128

    let n2 = dividend.hi shr (64 - divisor_clz)

    dividend = dividend shl divisor_clz
    divisor = divisor shl divisor_clz

    div2n1n(result.lo, dividend.hi, n2, dividend.hi, divisor.hi)

    m = mul64by64To128(result.lo, divisor.lo)

    if m.hi > dividend.hi or (m.hi == dividend.hi and m.lo > dividend.lo):
      dec(result.lo)
      m = m - divisor

    remainder = dividend - m
    remainder = remainder shr divisor_clz
    return

  divisor = divisor shl shift

  while shift >= 0:
    result.lo = result.lo shl 1

    if dividend >= divisor:
      dividend = dividend - divisor
      result.lo = result.lo or 1'u64

    divisor = divisor shr 1

    dec(shift)

  remainder = dividend

func cDivMod(x, y: UInt128, remainder: var UInt128): UInt128 {.inline, used.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)

  var q {.noInit.}: CUInt128
  var r {.noInit.}: CUInt128

  {.emit: """`q` = `x` / `y`; `r` = `x` % `y`;""".}

  remainder = cast[UInt128](r)

  result = cast[UInt128](q)

func divmod*(x, y: UInt128): tuple[q, r: UInt128] =
  when nimvm:
    result.q = nimDivModImpl(x, y, result.r)
  else:
    when shouldUseCInt128("cudivmod"):
      result.q = cDivMod(x, y, result.r)
    else:
      result.q = nimDivModImpl(x, y, result.r)

func nimDivMod(a, b: Int128): tuple[q, r: Int128] {.inline.} =
  var
    x = nint128Cast[UInt128](a)
    y = nint128Cast[UInt128](b)
    neg = false

  if isNegative(a):
    x = -x
    neg = true

  if isNegative(b):
    y = -y
    neg = true xor neg

  var q, r: UInt128

  q = nimDivModImpl(x, y, r)

  q.hi = q.hi and 0x7FFFFFFFFFFFFFFF'u64 # clearBit(q.hi, 63)
  r.hi = r.hi and 0x7FFFFFFFFFFFFFFF'u64 # clearBit(r.hi, 63)

  result.q = nint128Cast[Int128](q)
  result.r = nint128Cast[Int128](r)

  if neg:
    result.q = -result.q
    result.r = -result.r

func cDivMod(x, y: Int128, remainder: var Int128): Int128 {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  var q {.noInit.}: CInt128
  var r {.noInit.}: CInt128

  {.emit: """`q` = `x` / `y`; `r` = `x` % `y`;""".}

  remainder = cast[Int128](r)

  result = cast[Int128](q)

func divmod*(x, y: Int128): tuple[q, r: Int128] =
  when nimvm:
    nimDivMod(x, y)
  else:
    when shouldUseCInt128("cdivmod"):
      result.q = cDivMod(x, y, result.r)
    else:
      nimDivMod(x, y)

func div128by64to64*(x: UInt128, y: uint64, remainder: var uint64): uint64
                     {.inline.} =
  # Divides 128 by 64, if the high part of the dividend is less than the divisor
  # asm divq is more slow on my 4th generation i7
  var
    dividend = x
    divisor = y

  let clz = countLeadingZeroBits(divisor)

  dividend = dividend shl clz
  divisor = divisor shl clz

  div2n1n(result, remainder, dividend.hi, dividend.lo, divisor)

  remainder = remainder shr clz

func cDiv(x, y: UInt128): UInt128 {.inline, used.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)

  var r {.noInit.}: CUInt128

  {.emit: """`r` = `x` / `y`;""".}

  result = cast[UInt128](r)

func `div`*(x, y: UInt128): UInt128 {.inline.} =
  var remainder: UInt128 # Discarded
  
  when nimvm:
    result = nimDivModImpl(x, y, remainder)
  else:
    when shouldUseCInt128("cudiv"):
      cDiv(x, y)
    else:
      result = nimDivModImpl(x, y, remainder)

func cDiv(x, y: Int128): Int128 {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  var r {.noInit.}: CInt128

  {.emit: """`r` = `x` / `y`;""".}

  result = cast[Int128](r)

func `div`*(x, y: Int128): Int128 {.inline.} =
  when nimvm:
    nimDivMod(x, y).q
  else:
    when shouldUseCInt128("cdiv"):
      cDiv(x, y)
    else:
      nimDivMod(x, y).q

func cMod(x, y: UInt128): UInt128 {.inline, used.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)

  var r {.noInit.}: CUInt128

  {.emit: """`r` = `x` % `y`;""".}

  result = cast[UInt128](r)

func `mod`*(x, y: UInt128): UInt128 {.inline.} =
  when nimvm:
    discard nimDivModImpl(x, y, result)
  else:
    when shouldUseCInt128("cumod"):
      cMod(x, y)
    else:
      discard nimDivModImpl(x, y, result)

func cMod(x, y: Int128): Int128 {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  var r {.noInit.}: CInt128

  {.emit: """`r` = `x` % `y`;""".}

  result = cast[Int128](r)

func `mod`*(x, y: Int128): Int128 {.inline.} =
  when nimvm:
    nimDivMod(x, y).r
  else:
    when shouldUseCInt128("cmod"):
      cMod(x, y)
    else:
      nimDivMod(x, y).r
