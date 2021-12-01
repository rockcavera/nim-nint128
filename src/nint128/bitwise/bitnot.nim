import ../nint128_types, ../nint128_cint128

func nimBitNot[T: SomeInt128](x: T): T {.inline.} =
  result.hi = not(x.hi)
  result.lo = not(x.lo)

func cBitNot(x: UInt128): UInt128 {.inline.} =
  let x = cast[CUInt128](x)

  var r {.noInit.}: CUInt128

  {.emit: """`r` = ~`x`;""".}

  return cast[UInt128](r)

func cBitNot(x: Int128): Int128 {.inline.} =
  let x = cast[CInt128](x)

  var r {.noInit.}: CInt128

  {.emit: """`r` = ~`x`;""".}

  return cast[Int128](r)

func `not`*(x: UInt128): UInt128 {.inline.} =
  when nimvm:
    nimBitNot(x)
  else:
    when shouldUseCInt128("cubitnot"):
      cBitNot(x)
    else:
      nimBitNot(x)

func `not`*(x: Int128): Int128 {.inline.} =
  when nimvm:
    nimBitNot(x)
  else:
    when shouldUseCInt128("cbitnot"):
      cBitNot(x)
    else:
      nimBitNot(x)
