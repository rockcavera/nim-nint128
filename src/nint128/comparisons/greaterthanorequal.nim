import ../nint128_types, ../nint128_cint128

func nimGreaterThanOrEqual(x, y: SomeInt128): bool {.inline.} =
  # There is no substantial difference between using a unique proc or Nim's
  # template. Tested: amd64
  (x.hi > y.hi) or ((x.hi == y.hi) and (x.lo >= y.lo))

func cGreaterThanOrEqual(x, y: UInt128): bool {.inline, used.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)

  {.emit: """`result` = (NIM_BOOL)(`x` >= `y`);""".}

func cGreaterThanOrEqual(x, y: Int128): bool {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  {.emit: """`result` = (NIM_BOOL)(`x` >= `y`);""".}

func gte*(x, y: UInt128): bool {.inline.} =
  # Cannot use `>=`. see this https://github.com/nim-lang/Nim/issues/19737
  when nimvm:
    nimGreaterThanOrEqual(x, y)
  else:
    when shouldUseCInt128("cugreaterthanorequal"):
      cGreaterThanOrEqual(x, y)
    else:
      nimGreaterThanOrEqual(x, y)

func gte*(x, y: Int128): bool {.inline.} =
  # Cannot use `>=`. see this https://github.com/nim-lang/Nim/issues/19737
  when nimvm:
    nimGreaterThanOrEqual(x, y)
  else:
    when shouldUseCInt128("cgreaterthanorequal"):
      cGreaterThanOrEqual(x, y)
    else:
      nimGreaterThanOrEqual(x, y)

template GreaterThanOrEqual*(x, y: SomeInt128): bool =
  gte(x, y)
