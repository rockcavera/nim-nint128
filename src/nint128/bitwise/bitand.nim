import ../nint128_types, ../nint128_cint128

func nimBitAnd[T: SomeInt128](x, y: T): T {.inline.} =
  result.hi = x.hi and y.hi
  result.lo = x.lo and y.lo

func cBitAnd(x, y: UInt128): UInt128 {.inline, used.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)

  var r {.noInit.}: CUInt128

  {.emit: """`r` = `x` & `y`;""".}

  result = cast[UInt128](r)

func cBitAnd(x, y: Int128): Int128 {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  var r {.noInit.}: CInt128

  {.emit: """`r` = `x` & `y`;""".}

  result = cast[Int128](r)

func `and`*(x, y: UInt128): UInt128 {.inline.} =
  when nimvm:
    nimBitAnd(x, y)
  else:
    when shouldUseCInt128("cubitand"):
      cBitAnd(x, y)
    else:
      nimBitAnd(x, y)

func `and`*(x, y: Int128): Int128 {.inline.} =
  when nimvm:
    nimBitAnd(x, y)
  else:
    when shouldUseCInt128("cbitand"):
      cBitAnd(x, y)
    else:
      nimBitAnd(x, y)
