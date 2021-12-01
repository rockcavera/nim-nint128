import ../nint128_cast, ../nint128_comparisons, ../nint128_types, ../nint128_cint128

import ./minus

when defined(amd64) and defined(vcc):
  func umul128(a, b: uint64, hi: var uint64): uint64 {.importc: "_umul128",
                                                       header: "<intrin.h>".}

func nimMul64by64To128(a, b: uint64): UInt128 {.inline.} =
  let
    aLo = a and 0xFFFFFFFF'u64
    bLo = b and 0xFFFFFFFF'u64
    aHi = a shr 32
    bHi = b shr 32

  var tmp = aLo * bLo

  result.lo = tmp and 0xFFFFFFFF'u64
  tmp = tmp shr 32
  tmp += aHi * bLo
  result.lo = ((tmp and 0xFFFFFFFF'u64) shl 32) or result.lo
  result.hi = tmp shr 32
  tmp = result.lo shr 32
  result.lo = result.lo and 0xFFFFFFFF'u64
  tmp += bHi * aLo
  result.lo = ((tmp and 0xFFFFFFFF'u64) shl 32) or result.lo
  result.hi += tmp shr 32
  result.hi += aHi * bHi

func cMul64by64To128(a, b: uint64): UInt128 {.inline, used.} =
  when defined(gcc) or defined(clang):
    let
      a = cast[CUInt128](a)
      b = cast[CUInt128](b)

    var r {.noInit.}: CUInt128

    {.emit: """`r` = `a` * `b`;""".}

    result = cast[UInt128](r)
  elif defined(vcc):
    result.lo = umul128(a, b, result.hi)

func mul64by64To128*(a, b: uint64): UInt128 {.inline.} =
  when nimvm:
    nimMul64by64To128(a, b)
  else:
    when shouldUseCInt128("cumul64by64To128"):
      cMul64by64To128(a, b)
    else:
      nimMul64by64To128(a, b)

func mul64by64To128*(a, b: uint64, hi: var uint64): uint64 {.inline, deprecated: "use `mul64by64To128(a, b: uint64): UInt128` instead".} =
  let tmp = mul64by64To128(a, b)
  result = tmp.lo
  hi = tmp.hi

func nimMul128by128(a, b: UInt128): UInt128 {.inline.} =
  result = nimMul64by64To128(a.lo, b.lo)
  result.hi += (a.hi * b.lo) + (a.lo * b.hi)

func cMul128by128(a, b: UInt128): UInt128 {.inline, used.} =
  when defined(gcc) or defined(clang):
    let
      a = cast[CUInt128](a)
      b = cast[CUInt128](b)

    var r {.noInit.}: CUInt128

    {.emit: """`r` = `a` * `b`;""".}

    result = cast[UInt128](r)
  elif defined(vcc):
    result.lo = umul128(a.lo, b.lo, result.hi)
    result.hi += (a.hi * b.lo) + (a.lo * b.hi)

func nimMul128by128(a, b: Int128): Int128 {.inline.} =
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

  result = nint128Cast[Int128](nimMul128by128(x, y))

  result.hi = result.hi and 0x7FFFFFFFFFFFFFFF'i64 # clearBit(result.hi, 63)

  if neg:
    result = -result

func cMul128by128(a, b: Int128): Int128 {.inline, used.} =
  let
    a = cast[CInt128](a)
    b = cast[CInt128](b)

  var r {.noInit.}: CInt128

  {.emit: """`r` = `a` * `b`;""".}

  result = cast[Int128](r)

func `*`*(a, b: UInt128): UInt128 {.inline.} =
  when nimvm:
    nimMul128by128(a, b)
  else:
    when shouldUseCInt128("cumul"):
      cMul128by128(a, b)
    else:
      nimMul128by128(a, b)

func `*`*(a, b: Int128): Int128 {.inline.} =
  when nimvm:
    nimMul128by128(a, b)    
  else:
    when shouldUseCInt128("cmul"):
      cMul128by128(a, b)
    else:
      nimMul128by128(a, b)

func `*=`*[T: SomeInt128](x: var T, y: T) {.inline.} =
  x = x * y

#
# Possible addition to the package
#

func `*`*(a: UInt128, b: uint64): UInt128 {.inline.} =
  result = mul64by64To128(a.lo, b)

  result.hi += a.hi * b

template `*`*(a: uint64, b: UInt128): UInt128 =
  b * a