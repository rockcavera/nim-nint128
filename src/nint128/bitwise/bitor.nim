import ../nint128_types, ../nint128_cint128

func nimBitOr[T: SomeInt128](x, y: T): T {.inline.} =
  result.hi = x.hi or y.hi
  result.lo = x.lo or y.lo

func cBitOr(x, y: UInt128): UInt128 {.inline.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)

  var r {.noInit.}: CUInt128

  {.emit: """`r` = `x` | `y`;""".}

  return cast[UInt128](r)

func cBitOr(x, y: Int128): Int128 {.inline.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  var r {.noInit.}: CInt128

  {.emit: """`r` = `x` | `y`;""".}

  return cast[Int128](r)

func `or`*(x, y: UInt128): UInt128 {.inline.} =
  when nimvm:
    nimBitOr(x, y)
  else:
    when shouldUseCInt128("cubitor"):
      cBitOr(x, y)
    else:
      nimBitOr(x, y)

func `or`*(x, y: Int128): Int128 {.inline.} =
  when nimvm:
    nimBitOr(x, y)
  else:
    when shouldUseCInt128("cbitor"):
      cBitOr(x, y)
    else:
      nimBitOr(x, y)
