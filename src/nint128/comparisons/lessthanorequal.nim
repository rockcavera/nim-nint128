import ../nint128_types, ../nint128_cint128

func nimLessThanOrEqual(x, y: SomeInt128): bool {.inline.} =
  (x.hi < y.hi) or ((x.hi == y.hi) and (x.lo <= y.lo))

func cLessThanOrEqual(x, y: UInt128): bool {.inline, used.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)
  
  {.emit: """`result` = (NIM_BOOL)(`x` <= `y`);""".}

func cLessThanOrEqual(x, y: Int128): bool {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)
  
  {.emit: """`result` = (NIM_BOOL)(`x` <= `y`);""".}

func `<=`*(x, y: UInt128): bool {.inline.} =
  when nimvm:
    nimLessThanOrEqual(x, y)
  else:
    when shouldUseCInt128("culessthanorequal"):
      cLessThanOrEqual(x, y)
    else:
      nimLessThanOrEqual(x, y)

func `<=`*(x, y: Int128): bool {.inline.} =
  when nimvm:
    nimLessThanOrEqual(x, y)
  else:
    when shouldUseCInt128("clessthanorequal"):
      cLessThanOrEqual(x, y)
    else:
      nimLessThanOrEqual(x, y)
