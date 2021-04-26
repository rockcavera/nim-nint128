import std/bitops

import ./nint128_bitwise, ./nint128_cast, ./nint128_comparisons, ./nint128_types

func `+`*(x, y: UInt128): UInt128 {.inline.} =
  result.lo = x.lo + y.lo
  result.hi = x.hi + y.hi + uint64(result.lo < y.lo)

func `+`*(x, y: Int128): Int128 {.inline.} =
  result.lo = x.lo + y.lo
  result.hi = x.hi + y.hi + int64(result.lo < y.lo)

func `-`*[T: SomeInt128](x: T): T {.inline.} =
  ## Unary operator minus
  not(x) + one(T)

func `-`*(x, y: UInt128): UInt128 {.inline.} =
  result.lo = x.lo - y.lo
  result.hi = x.hi - y.hi - uint64(x.lo < y.lo)

func `-`*(x, y: Int128): Int128 {.inline.} =
  result.lo = x.lo - y.lo
  result.hi = x.hi - y.hi - int64(x.lo < y.lo)

func `+=`*[T: SomeInt128](x: var T, y: T) {.inline.} =
  x = x + y

func `-=`*[T: SomeInt128](x: var T, y: T) {.inline.} =
  x = x - y

func inc*[T: SomeInt128](x: var T, y: T = one(T)) {.inline.} =
  x = x + y

func dec*[T: SomeInt128](x: var T, y: T = one(T)) {.inline.} =
  x = x - y

when sizeof(int) == 8:
  when defined(gcc) or defined(clang):
    const definedUmul128 = true

    func umul128(a, b: uint64, hi: var uint64): uint64 {.inline.} =
      {.emit: """
        unsigned __int128 tu = (unsigned __int128)(`a`);
        tu *= `b`;
        `*hi` = tu >> 64;
        return (unsigned long long int)(tu);
      """.}
  elif defined(amd64) and defined(vcc):
    const definedUmul128 = true

    func umul128(a, b: uint64, hi: var uint64): uint64 {.importc: "_umul128",
                                                        header: "<intrin.h>".}
  else:
    const definedUmul128 = false
else:
  const definedUmul128 = false

func nimUmul128(a, b: uint64, hi: var uint64): uint64 {.inline.} =
  let
    aLo = a and 0xFFFFFFFF'u64
    bLo = b and 0xFFFFFFFF'u64
    aHi = a shr 32
    bHi = b shr 32

  result = aLo * bLo

  var tmp = result shr 32

  result = result and 0xFFFFFFFF'u64
  tmp += aHi * bLo
  result += (tmp and 0xFFFFFFFF'u64) shl 32
  hi = tmp shr 32
  tmp = result shr 32
  result = result and 0xFFFFFFFF'u64
  tmp += bHi * aLo
  result += (tmp and 0xFFFFFFFF'u64) shl 32
  hi += tmp shr 32
  hi += aHi * bHi

func mul64by64To128*(a, b: uint64, hi: var uint64): uint64 {.inline.} =
  when nimvm:
    nimUmul128(a, b, hi)
  else:
    when definedUmul128:
      umul128(a, b, hi)
    else:
      nimUmul128(a, b, hi)

func `*`*(a, b: UInt128): UInt128 {.inline.} =
  result.lo = mul64by64To128(a.lo, b.lo, result.hi)

  result.hi += (a.lo * b.hi) + (a.hi * b.lo)

func `*`*(a, b: Int128): Int128 {.inline.} =
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

  result = nint128Cast[Int128](x * y)

  result.hi = result.hi and 0x7FFFFFFFFFFFFFFF'i64 # clearBit(result.hi, 63)

  if neg:
    result = -result

func `*=`*[T: SomeInt128](x: var T, y: T) {.inline.} =
  x = x * y

include nint128_udiv

func udiv128by64to64*(x: UInt128, y: uint64, remainder: var uint64): uint64
                     {.inline.} =
  # Divides 128 by 64, if the high part of the dividend is less than the divisor
  # asm divq is more slow
  var
    dividend = x
    divisor = y

  let clz = countLeadingZeroBits(divisor)

  dividend = dividend shl clz
  divisor = divisor shl clz

  div2n1n(result, remainder, dividend.hi, dividend.lo, divisor)

  remainder = remainder shr clz

func divmodImpl(x, y: UInt128, remainder: var UInt128): UInt128 {.inline.} =
  # Known cases that the performance is significantly worse than the GCC and
  # CLANG divmod implementation for 128-bit integers:
  var
    dividend = x
    divisor = y

  if divisor.hi == 0:
    if dividend.hi == 0:
      result.lo = dividend.lo div divisor.lo
      remainder.lo = dividend.lo mod divisor.lo
      return

    let divisor_clz = countLeadingZeroBits(divisor.lo)

    if (divisor.lo and (divisor.lo - 1)) == 0:
      let y_ctz = 128 - (divisor_clz + 64) - 1

      result = dividend shr y_ctz
      remainder = dividend and (divisor - one(UInt128))
      return

    if dividend.hi < divisor.lo:
      var shift = (divisor_clz + 64) - countLeadingZeroBits(dividend.hi)

      if shift < 13: # or 8?
        divisor = divisor shl shift

        while shift >= 0:
          result.lo = result.lo shl 1

          if dividend >= divisor:
            dividend -= divisor
            result.lo = result.lo or 1'u64

          divisor = divisor shr 1

          dec(shift)

        remainder = dividend
      else:
        dividend = dividend shl divisor_clz
        divisor.lo = divisor.lo shl divisor_clz

        div2n1n(result.lo, remainder.lo, dividend.hi, dividend.lo, divisor.lo)

        remainder.lo = remainder.lo shr divisor_clz
    elif dividend.hi == divisor.lo:
      result.hi = 1'u64
      result.lo = dividend.lo div divisor.lo
      remainder.lo = dividend.lo mod divisor.lo
    else:
      result.hi = dividend.hi div divisor.lo
      dividend.hi = dividend.hi mod divisor.lo
      dividend = dividend shl divisor_clz
      divisor.lo = divisor.lo shl divisor_clz

      div2n1n(result.lo, remainder.lo, dividend.hi, dividend.lo, divisor.lo)

      remainder.lo = remainder.lo shr divisor_clz

    return

  if (divisor and (divisor - one(UInt128))) == zero(UInt128):
    let y_ctz = 128 - countLeadingZeroBits(divisor.hi) - 1

    result = dividend shr y_ctz
    remainder = dividend and (divisor - one(UInt128))
    return

  if divisor == dividend:
    result.lo = 1'u64
    return

  if divisor > dividend:
    remainder = dividend
    return

  let divisor_clz = countLeadingZeroBits(divisor.hi)

  var shift = divisor_clz - countLeadingZeroBits(dividend.hi)

  if shift < 14:
    divisor = divisor shl shift

    while shift >= 0:
      result.lo = result.lo shl 1

      if dividend >= divisor:
        dividend -= divisor
        result.lo = result.lo or 1'u64

      divisor = divisor shr 1

      dec(shift)

    remainder = dividend
  else:
    var m: UInt128

    let n2 = dividend.hi shr (64 - divisor_clz)

    dividend = dividend shl divisor_clz
    divisor = divisor shl divisor_clz

    div2n1n(result.lo, dividend.hi, n2, dividend.hi, divisor.hi)

    m.lo = mul64by64To128(result.lo, divisor.lo, m.hi)

    if m.hi > dividend.hi or (m.hi == dividend.hi and m.lo > dividend.lo):
      dec(result.lo)
      m = m - divisor

    remainder = dividend - m
    remainder = remainder shr divisor_clz

func divmod*(x, y: UInt128): tuple[q, r: UInt128] =
  result.q = divmodImpl(x, y, result.r)

func divmod*(a, b: Int128): tuple[q, r: Int128] =
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

  q = divmodImpl(x, y, r)

  q.hi = q.hi and 0x7FFFFFFFFFFFFFFF'u64 # clearBit(q.hi, 63)
  r.hi = r.hi and 0x7FFFFFFFFFFFFFFF'u64 # clearBit(r.hi, 63)

  result.q = nint128Cast[Int128](q)
  result.r = nint128Cast[Int128](r)

  if neg:
    result.q = -result.q
    result.r = -result.r

func `div`*[T: SomeInt128](x, y: T): T {.inline.} =
  divmod(x, y).q

func `mod`*[T: SomeInt128](x, y: T): T {.inline.} =
  divmod(x, y).r

################################################################################
# Possible addition to the package
################################################################################

func add64Plus64ToU128*(x, y: uint64): UInt128 {.inline.} =
  result.lo = x + y
  result.hi = uint64(result.lo < y)

func add64Plus64ToI128*(x, y: uint64): Int128 {.inline.} =
  result.lo = x + y
  result.hi = int64(result.lo < y)

func `+`*(x: UInt128, y: uint64): UInt128 {.inline.} =
  result.lo = x.lo + y
  result.hi = x.hi + uint64(result.lo < y)

func `+`*(x: Int128, y: uint64): Int128 {.inline.} =
  result.lo = x.lo + y
  result.hi = x.hi + int64(result.lo < y)

func `+=`*[T: SomeInt128](x: var T, y: uint64) {.inline.} =
  x = x + y

template `+`*[T: SomeInt128](x: uint64, y: T): T =
  y + x

func `*`*(a: UInt128, b: uint64): UInt128 {.inline.} =
  result.lo = mul64by64To128(a.lo, b, result.hi)

  result.hi += a.hi * b

template `*`*(a: uint64, b: UInt128): UInt128 =
  b * a
