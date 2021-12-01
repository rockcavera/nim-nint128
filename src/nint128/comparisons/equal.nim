import ../nint128_types, ../nint128_cint128

func nimEqual(x, y: UInt128): bool {.inline.} =
  # (x.hi == y.hi) and (x.lo == y.lo)
  ((x.lo xor y.lo) or (x.hi xor y.hi)) == 0'u64 # Generates assembly code
                                                # practically the same as
                                                # Cint128. It has one less
                                                # instruction. Tested: amd64

func cEqual(x, y: UInt128): bool {.inline, used.} =
  let
    x = cast[CUInt128](x)
    y = cast[CUInt128](y)
  
  {.emit: """`result` = (NIM_BOOL)(`x` == `y`);""".}

func nimEqual(x, y: Int128): bool {.inline.} =
  # (x.hi == y.hi) and (x.lo == y.lo)
  ((x.lo xor y.lo) or cast[uint64](x.hi xor y.hi)) == 0'u64 # Generates assembly
                                                            # code practically
                                                            # the same as
                                                            # CInt128. It has
                                                            # one less
                                                            # instruction.
                                                            # Tested: amd64

func cEqual(x, y: Int128): bool {.inline, used.} =
  let
    x = cast[CInt128](x)
    y = cast[CInt128](y)
  
  {.emit: """`result` = (NIM_BOOL)(`x` == `y`);""".}

func `==`*(x, y: UInt128): bool {.inline.} =
  when nimvm:
    nimEqual(x, y)
  else:
    when shouldUseCInt128("cuequal"):
      cEqual(x, y)
    else:
      nimEqual(x, y)

func `==`*(x, y: Int128): bool {.inline.} =
  when nimvm:
    nimEqual(x, y)
  else:
    when shouldUseCInt128("cequal"):
      cEqual(x, y)
    else:
      nimEqual(x, y)
