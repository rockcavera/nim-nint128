import ../nint128_types, ../nint128_cint128

func nimGreaterThan(x, y: SomeInt128): bool {.inline.} =
  # There is no substantial difference between using a unique proc or Nim's
  # template. Tested: amd64
  (x.hi > y.hi) or ((x.hi == y.hi) and (x.lo > y.lo))

func cGreaterThan(x, y: UInt128): bool {.inline, used.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)

  {.emit: """`result` = (NIM_BOOL)(`x` > `y`);""".}

func cGreaterThan(x, y: Int128): bool {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  {.emit: """`result` = (NIM_BOOL)(`x` > `y`);""".}

func gt*(x, y: UInt128): bool {.inline.} =
  # Cannot use `>`. see this https://github.com/nim-lang/Nim/issues/19737
  when nimvm:
    nimGreaterThan(x, y)
  else:
    when shouldUseCInt128("cugreaterthan"):
      cGreaterThan(x, y)
    else:
      nimGreaterThan(x, y)

func gt*(x, y: Int128): bool {.inline.} =
  # Cannot use `>`. see this https://github.com/nim-lang/Nim/issues/19737
  when nimvm:
    nimGreaterThan(x, y)
  else:
    when shouldUseCInt128("cgreaterthan"):
      cGreaterThan(x, y)
    else:
      nimGreaterThan(x, y)

template GreaterThan*(x, y: SomeInt128): bool =
  gt(x, y)
