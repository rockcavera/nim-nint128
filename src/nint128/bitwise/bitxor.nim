import ../nint128_types, ../nint128_cint128

func nimBitXor[T: SomeInt128](x, y: T): T {.inline.} =
  result.hi = x.hi xor y.hi
  result.lo = x.lo xor y.lo

func cBitXor(x, y: UInt128): UInt128 {.inline.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)

  var r {.noInit.}: CUInt128

  {.emit: """`r` = `x` ^ `y`;""".}

  return cast[UInt128](r)

func cBitXor(x, y: Int128): Int128 {.inline.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  var r {.noInit.}: CInt128

  {.emit: """`r` = `x` ^ `y`;""".}

  return cast[Int128](r)

func `xor`*(x, y: UInt128): UInt128 {.inline.} =
  when nimvm:
    nimBitXor(x, y)
  else:
    when shouldUseCInt128("cubitxor"):
      cBitXor(x, y)
    else:
      nimBitXor(x, y)

func `xor`*(x, y: Int128): Int128 {.inline.} =
  when nimvm:
    nimBitXor(x, y)
  else:
    when shouldUseCInt128("cbitxor"):
      cBitXor(x, y)
    else:
      nimBitXor(x, y)
