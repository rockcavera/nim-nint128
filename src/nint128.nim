import ./nint128/[nint128_arithmetic, nint128_bitops, nint128_bitwise, nint128_comparisons,
                  nint128_endians, nint128_io, nint128_math, nint128_types]

export nint128_arithmetic, nint128_bitops, nint128_bitwise, nint128_comparisons, nint128_endians,
       nint128_io, nint128_math, nint128_types

func i128*(x: string): Int128 {.inline.} = parseInt128(x)

func i128*[T: SomeInteger](x: T): Int128 {.inline.} =
  when T is SomeUnsignedInt:
    Int128(hi: 0'i64, lo: uint64(x))
  else:
    if x < 0:
      Int128(hi: 0xFFFFFFFFFFFFFFFF'i64, lo: cast[uint64](x))
    else:
      Int128(hi: 0'i64, lo: uint64(x))

func u128*(x: string): UInt128 {.inline.} = parseUInt128(x)

func u128*(x: SomeInteger): UInt128 {.inline.} =
  UInt128(hi: 0'u64, lo: uint64(x))
