import ../nint128_types, ../nint128_cint128

func nimLessThan(x, y: SomeInt128): bool {.inline.} =
  (x.hi < y.hi) or ((x.hi == y.hi) and (x.lo < y.lo))

func cLessThan(x, y: UInt128): bool {.inline, used.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)

  {.emit: """`result` = (NIM_BOOL)(`x` < `y`);""".}

func cLessThan(x, y: Int128): bool {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  {.emit: """`result` = (NIM_BOOL)(`x` < `y`);""".}

func `<`*(x, y: UInt128): bool {.inline.} =
  when nimvm:
    nimLessThan(x, y)
  else:
    when shouldUseCInt128("culessthan"):
      cLessThan(x, y)
    else:
      nimLessThan(x, y)

func `<`*(x, y: Int128): bool {.inline.} =
  when nimvm:
    nimLessThan(x, y)
  else:
    when shouldUseCInt128("clessthan"):
      cLessThan(x, y)
    else:
      nimLessThan(x, y)
