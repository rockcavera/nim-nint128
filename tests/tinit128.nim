import nint128

# UInt128

doAssert low(UInt128) == zero(UInt128)

doAssert u128(1) == one(UInt128)
doAssert u128(1'i8) == one(UInt128)
doAssert u128(1'i16) == one(UInt128)
doAssert u128(1'i32) == one(UInt128)
doAssert u128(1'i64) == one(UInt128)

doAssert u128(uint(1)) == one(UInt128)
doAssert u128(1'u8) == one(UInt128)
doAssert u128(1'u16) == one(UInt128)
doAssert u128(1'u32) == one(UInt128)
doAssert u128(1'u64) == one(UInt128)

doAssert u128("1") == one(UInt128)


# Int128

const minus_one = Int128(hi: -1'i64, lo: 0xFFFFFFFFFFFFFFFF'u64)

doAssert i128(1) == one(Int128)
doAssert i128(1'i8) == one(Int128)
doAssert i128(1'i16) == one(Int128)
doAssert i128(1'i32) == one(Int128)
doAssert i128(1'i64) == one(Int128)

doAssert i128(uint(1)) == one(Int128)
doAssert i128(1'u8) == one(Int128)
doAssert i128(1'u16) == one(Int128)
doAssert i128(1'u32) == one(Int128)
doAssert i128(1'u64) == one(Int128)

doAssert i128("1") == one(Int128)

doAssert i128(-1) == minus_one
doAssert i128(-1'i8) == minus_one
doAssert i128(-1'i16) == minus_one
doAssert i128(-1'i32) == minus_one
doAssert i128(-1'i64) == minus_one

doAssert i128("-1") == minus_one
