import std/bitops

import ./nint128_bitops, ./nint128_bitwise, ./nint128_comparisons, ./nint128_types

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

func mul64by64To128*(a, b: uint64, hi: var uint64): uint64 {.inline.} =
  let
    aLo = a and 0xFFFFFFFF'u64
    bLo = b and 0xFFFFFFFF'u64
    aHi = a shr 32
    bHi = b shr 32

  hi = aHi * bHi
  result = aHi * bLo
  
  let
    aLo_bHi = aLo * bHi
    aLo_bLo = aLo * bLo

  result += (aLo_bLo shr 32) + (aLo_bHi and 0xFFFFFFFF'u64)
  
  hi += (result shr 32) + (aLo_bHi shr 32)

  result = (result shl 32) or (aLo_bLo and 0xFFFFFFFF'u64)

func `*`*(a, b: UInt128): UInt128 {.inline.} =
  result.lo = mul64by64To128(a.lo, b.lo, result.hi)

  result.hi += (a.lo * b.hi) + (a.hi * b.lo)

func `*`*(a, b: Int128): Int128 {.inline.} =
  var
    x = cast[UInt128](a)
    y = cast[UInt128](b)
    neg = false
  
  if isNegative(a):
    x = -x
    neg = true
  
  if isNegative(b):
    y = -y
    neg = true xor neg

  result = cast[Int128](x * y)

  result.hi = result.hi and 0x7FFFFFFFFFFFFFFF'i64 # clearBit(result.hi, 63)

  if neg:
    result = -result

func `*=`*[T: SomeInt128](x: var T, y: T) {.inline.} =
  x = x * y

func shl256(hi, lo: var UInt128, y: int) {.inline.} =
  # Emulates 256-bit left shift
  let y = y and 255

  if y == 0:
    return
  elif y < 128:
    hi = (hi shl y) or (lo shr (128 - y))
    lo = lo shl y
  else:
    hi = lo shl (y - 128)
    lo = zero(UInt128)

include nint128_udiv

func divmod*(x, y: UInt128): tuple[q, r: UInt128] =
  result.q = divmodImpl(x, y, result.r)

func divmod*(a, b: Int128): tuple[q, r: Int128] =
  var
    x = cast[UInt128](a)
    y = cast[UInt128](b)
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

  result.q = cast[Int128](q)
  result.r = cast[Int128](r)

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
