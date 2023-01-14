import ../nint128_types, ../nint128_cint128

when defined(amd64) and defined(vcc):
  func subborrowu64(c_in: uint8, a, b: uint64, o: var uint64): uint8 {.importc: "_subborrow_u64", header: "<intrin.h>".}

func nim128Minus128(x, y: UInt128): UInt128 {.inline.} =
  result.lo = x.lo - y.lo
  result.hi = x.hi - y.hi - uint64(x.lo < y.lo)

func c128Minus128(x, y: UInt128): UInt128 {.inline, used.} =
  when defined(gcc) or defined(clang):
    let
      x = cast[CUInt128](x)
      y = cast[CUInt128](y)

    var r {.noInit.}: CUInt128

    {.emit: """`r` = `x` - `y`;""".}

    result = cast[UInt128](r)
  elif defined(vcc):
    let carry = subborrowu64(0'u8, x.lo, y.lo, result.lo)
    discard subborrowu64(carry, x.hi, y.hi, result.hi)

func nim128Minus128(x, y: Int128): Int128 {.inline.} =
  result.lo = x.lo - y.lo
  result.hi = x.hi - y.hi - int64(x.lo < y.lo)

func c128Minus128(x, y: Int128): Int128 {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  var r {.noInit.}: CInt128

  {.emit: """`r` = `x` - `y`;""".}

  result = cast[Int128](r)

func `-`*(x, y: UInt128): UInt128 {.inline.} =
  when nimvm:
    nim128Minus128(x, y)
  else:
    when shouldUseCInt128("cuminus"):
      c128Minus128(x, y)
    else:
      nim128Minus128(x, y)

func `-`*(x, y: Int128): Int128 {.inline.} =
  when nimvm:
    nim128Minus128(x, y)
  else:
    when shouldUseCInt128("cminus"):
      c128Minus128(x, y)
    else:
      nim128Minus128(x, y)

func `-=`*[T: SomeInt128](x: var T, y: T) {.inline.} =
  x = x - y

#
# Possible addition to the package
#

func `-`*(x: UInt128, y: uint64): UInt128 {.inline.} =
  result.lo = x.lo - y
  result.hi = x.hi - uint64(x.lo < y)

func `-`*(x: Int128, y: uint64): Int128 {.inline.} =
  result.lo = x.lo - y
  result.hi = x.hi - int64(x.lo < y)

func `-=`*[T: SomeInt128](x: var T, y: uint64) {.inline.} =
  x = x - y

template `-`*[T: SomeInt128](x: uint64, y: T): T =
  y - x
