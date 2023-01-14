import ../nint128_types, ../nint128_cint128

func nimNotEqual(x, y: UInt128): bool {.inline.} =
  # Using a unique proc for notequal, generates assembly code with one
  # instruction unless using Nim's template. Tested: amd64
  # (x.hi != y.hi) or (x.lo != y.lo)
  ((x.lo xor y.lo) or (x.hi xor y.hi)) > 0'u64 # Generates assembly code
                                               # practically the same as CUInt128.
                                               # It has one less instruction.
                                               # Tested: amd64

func cNotEqual(x, y: UInt128): bool {.inline, used.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)

  {.emit: """`result` = (NIM_BOOL)(`x` != `y`);""".}

func nimNotEqual(x, y: Int128): bool {.inline.} =
  # Using a unique proc for notequal, generates assembly code with one
  # instruction unless using Nim's template. Tested: amd64
  # (x.hi != y.hi) or (x.lo != y.lo)
  ((x.lo xor y.lo) or cast[uint64](x.hi xor y.hi)) > 0'u64 # Generates assembly
                                                           # code practically
                                                           # the same as
                                                           # CInt128. It has one
                                                           # less instruction.
                                                           # Tested: amd64

func cNotEqual(x, y: Int128): bool {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)

  {.emit: """`result` = (NIM_BOOL)(`x` != `y`);""".}

func ne*(x, y: UInt128): bool {.inline.} =
  # Cannot use `!=`. see this https://github.com/nim-lang/Nim/issues/19737
  when nimvm:
    nimNotEqual(x, y)
  else:
    when shouldUseCInt128("cunotequal"):
      cNotEqual(x, y)
    else:
      nimNotEqual(x, y)

func ne*(x, y: Int128): bool {.inline.} =
  # Cannot use `!=`. see this https://github.com/nim-lang/Nim/issues/19737
  when nimvm:
    nimNotEqual(x, y)
  else:
    when shouldUseCInt128("cnotequal"):
      cNotEqual(x, y)
    else:
      nimNotEqual(x, y)

template notEqual*(x, y: SomeInt128): bool =
  ne(x, y)
