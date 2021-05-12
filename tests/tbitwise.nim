import nint128

# UInt128

const
  u_2 = UInt128(hi: 0'u64, lo: 2'u64)
  u_127 = UInt128(hi: 0'u64, lo: 127'u64)
  u_128 = UInt128(hi: 0'u64, lo: 128'u64)
  u_9223372036854775808 = UInt128(hi: 0'u64, lo: 0x8000000000000000'u64)
  u_18446744073709551616 = UInt128(hi: 1'u64, lo: 0'u64)
  u_36893488147419103232 = UInt128(hi: 2'u64, lo: 0'u64)
  u_85070591730234615865843651857942052864 = UInt128(hi: 0x4000000000000000'u64, lo: 0x0000000000000000'u64)
  u_170141183460469231731687303715884105727 = UInt128(hi: 0x7FFFFFFFFFFFFFFF'u64, lo: 0xFFFFFFFFFFFFFFFF'u64)
  u_170141183460469231731687303715884105728 = UInt128(hi: 0x8000000000000000'u64, lo: 0x0000000000000000'u64)
  u_340282366920938463463374607431768211455 = UInt128(hi: 0xFFFFFFFFFFFFFFFF'u64, lo: 0xFFFFFFFFFFFFFFFE'u64)

  i_127 = Int128(hi: 0'i64, lo: 127'u64)
  i_128 = Int128(hi: 0'i64, lo: 128'u64)

block uint128_or:
  doAssert (high(UInt128) or high(UInt128)) == high(UInt128)
  doAssert (high(UInt128) or zero(UInt128)) == high(UInt128)
  doAssert (high(UInt128) or one(UInt128)) == high(UInt128)
  doAssert (zero(UInt128) or zero(UInt128)) == zero(UInt128)
  doAssert (zero(UInt128) or one(UInt128)) == one(UInt128)
  doAssert (one(UInt128) or one(UInt128)) == one(UInt128)

block uint128_and:
  doAssert (high(UInt128) and high(UInt128)) == high(UInt128)
  doAssert (high(UInt128) and zero(UInt128)) == zero(UInt128)
  doAssert (high(UInt128) and one(UInt128)) == one(UInt128)
  doAssert (zero(UInt128) and zero(UInt128)) == zero(UInt128)
  doAssert (zero(UInt128) and one(UInt128)) == zero(UInt128)
  doAssert (one(UInt128) and one(UInt128)) == one(UInt128)

block uint128_xor:
  doAssert (high(UInt128) xor high(UInt128)) == zero(UInt128)
  doAssert (high(UInt128) xor zero(UInt128)) == high(UInt128)
  doAssert (high(UInt128) xor one(UInt128)) == u_340282366920938463463374607431768211455
  doAssert (zero(UInt128) xor zero(UInt128)) == zero(UInt128)
  doAssert (zero(UInt128) xor one(UInt128)) == one(UInt128)
  doAssert (one(UInt128) xor one(UInt128)) == zero(UInt128)

block uint128_not:
  doAssert not(high(UInt128)) == low(UInt128)
  doAssert not(zero(UInt128)) == high(UInt128)
  doAssert not(one(UInt128)) == u_340282366920938463463374607431768211455

block uint128_shl:
  doAssert (zero(UInt128) shl 0) == zero(UInt128)
  doAssert (zero(UInt128) shl 1) == zero(UInt128)
  doAssert (zero(UInt128) shl 127) == zero(UInt128)
  doAssert (zero(UInt128) shl 128) == zero(UInt128) # equal shl 0

  doAssert (one(UInt128) shl 0) == one(UInt128)
  doAssert (one(UInt128) shl 1) == u_2
  doAssert (one(UInt128) shl 127) == u_170141183460469231731687303715884105728
  doAssert (one(UInt128) shl 128) == one(UInt128) # equal shl 0

  doAssert (high(UInt128) shl 0) == high(UInt128)
  doAssert (high(UInt128) shl 1) == u_340282366920938463463374607431768211455
  doAssert (high(UInt128) shl 127) == u_170141183460469231731687303715884105728
  doAssert (high(UInt128) shl 128) == high(UInt128) # equal shl 0

  doAssert (u_18446744073709551616 shl 0) == u_18446744073709551616
  doAssert (u_18446744073709551616 shl 1) == u_36893488147419103232
  doAssert (u_18446744073709551616 shl 127) == zero(UInt128)
  doAssert (u_18446744073709551616 shl 128) == u_18446744073709551616 # equal shl 0

  doAssert (u_170141183460469231731687303715884105728 shl 0) == u_170141183460469231731687303715884105728
  doAssert (u_170141183460469231731687303715884105728 shl 1) == zero(UInt128)
  doAssert (u_170141183460469231731687303715884105728 shl 127) == zero(UInt128)
  doAssert (u_170141183460469231731687303715884105728 shl 128) == u_170141183460469231731687303715884105728 # equal shl 0

  # Template shl
  doAssert (one(UInt128) shl zero(UInt128)) == one(UInt128)
  doAssert (one(UInt128) shl one(UInt128)) == u_2
  doAssert (one(UInt128) shl u_127) == u_170141183460469231731687303715884105728
  doAssert (one(UInt128) shl u_128) == one(UInt128) # equal shl 0
  doAssert (one(UInt128) shl high(UInt128)) == u_170141183460469231731687303715884105728

  doAssert (one(UInt128) shl zero(Int128)) == one(UInt128)
  doAssert (one(UInt128) shl one(Int128)) == u_2
  doAssert (one(UInt128) shl i_127) == u_170141183460469231731687303715884105728
  doAssert (one(UInt128) shl i_128) == one(UInt128) # equal shl 0
  doAssert (one(UInt128) shl high(Int128)) == u_170141183460469231731687303715884105728

block uint128_shr:
  doAssert (zero(UInt128) shr 0) == zero(UInt128)
  doAssert (zero(UInt128) shr 1) == zero(UInt128)
  doAssert (zero(UInt128) shr 127) == zero(UInt128)
  doAssert (zero(UInt128) shr 128) == zero(UInt128) # equal shr 0

  doAssert (one(UInt128) shr 0) == one(UInt128)
  doAssert (one(UInt128) shr 1) == zero(UInt128)
  doAssert (one(UInt128) shr 127) == zero(UInt128)
  doAssert (one(UInt128) shr 128) == one(UInt128) # equal shr 0

  doAssert (high(UInt128) shr 0) == high(UInt128)
  doAssert (high(UInt128) shr 1) == u_170141183460469231731687303715884105727
  doAssert (high(UInt128) shr 127) == one(UInt128)
  doAssert (high(UInt128) shr 128) == high(UInt128) # equal shr 0

  doAssert (u_18446744073709551616 shr 0) == u_18446744073709551616
  doAssert (u_18446744073709551616 shr 1) == u_9223372036854775808
  doAssert (u_18446744073709551616 shr 127) == zero(UInt128)
  doAssert (u_18446744073709551616 shr 128) == u_18446744073709551616 # equal shr 0

  doAssert (u_170141183460469231731687303715884105728 shr 0) == u_170141183460469231731687303715884105728
  doAssert (u_170141183460469231731687303715884105728 shr 1) == u_85070591730234615865843651857942052864
  doAssert (u_170141183460469231731687303715884105728 shr 127) == one(UInt128)
  doAssert (u_170141183460469231731687303715884105728 shr 128) == u_170141183460469231731687303715884105728 # equal shr 0

  # Template shr
  doAssert (high(UInt128) shr zero(UInt128)) == high(UInt128)
  doAssert (high(UInt128) shr one(UInt128)) == u_170141183460469231731687303715884105727
  doAssert (high(UInt128) shr u_127) == one(UInt128)
  doAssert (high(UInt128) shr u_128) == high(UInt128) # equal shr 0
  doAssert (high(UInt128) shr high(UInt128)) == one(UInt128)

  doAssert (high(UInt128) shr zero(Int128)) == high(UInt128)
  doAssert (high(UInt128) shr one(Int128)) == u_170141183460469231731687303715884105727
  doAssert (high(UInt128) shr i_127) == one(UInt128)
  doAssert (high(UInt128) shr i_128) == high(UInt128) # equal shr 0
  doAssert (high(UInt128) shr high(Int128)) == one(UInt128)


# Int128

const
  i_2 = Int128(hi: 0'i64, lo: 2'u64)
  i_85070591730234615861231965839514664960 = Int128(hi: 0x3FFFFFFFFFFFFFFF'i64, lo: 0xC000000000000000'u64)
  i_85070591730234615865843651857942052863 = Int128(hi: 0x3FFFFFFFFFFFFFFF'i64, lo: 0xFFFFFFFFFFFFFFFF'u64)
  i_170141183460469231722463931679029329920 = Int128(hi: 0x7FFFFFFFFFFFFFFF'i64, lo: 0x8000000000000000'u64)
  i_170141183460469231731687303715884105726 = Int128(hi: 0x7FFFFFFFFFFFFFFF'i64, lo: 0xFFFFFFFFFFFFFFFE'u64)

  minus_1 = Int128(hi: -1'i64, lo: 0xFFFFFFFFFFFFFFFF'u64)
  minus_2 = Int128(hi: -1'i64, lo: 0xFFFFFFFFFFFFFFFE'u64)
  minus_9223372036854775808 = Int128(hi: -1'i64, lo: 0x8000000000000000'u64)
  minus_18446744073709551616 = Int128(hi: -1'i64, lo: 0'u64)
  minus_85070591730234615865843651857942052864 = Int128(hi: -0x4000000000000000'i64, lo: 0'u64)
  minus_170141183460469231731687303715884105727 = Int128(hi: 0x8000000000000000'i64, lo: 1'u64)

block int128_or:
  doAssert (low(Int128) or low(Int128)) == low(Int128)
  doAssert (low(Int128) or high(Int128)) == minus_1
  doAssert (low(Int128) or zero(Int128)) == low(Int128)
  doAssert (low(Int128) or one(Int128)) == minus_170141183460469231731687303715884105727
  doAssert (high(Int128) or high(Int128)) == high(Int128)
  doAssert (high(Int128) or zero(Int128)) == high(Int128)
  doAssert (high(Int128) or one(Int128)) == high(Int128)
  doAssert (zero(Int128) or zero(Int128)) == zero(Int128)
  doAssert (zero(Int128) or one(Int128)) == one(Int128)
  doAssert (one(Int128) or one(Int128)) == one(Int128)

block int128_and:
  doAssert (low(Int128) and low(Int128)) == low(Int128)
  doAssert (low(Int128) and high(Int128)) == zero(Int128)
  doAssert (low(Int128) and zero(Int128)) == zero(Int128)
  doAssert (low(Int128) and one(Int128)) == zero(Int128)
  doAssert (high(Int128) and high(Int128)) == high(Int128)
  doAssert (high(Int128) and zero(Int128)) == zero(Int128)
  doAssert (high(Int128) and one(Int128)) == one(Int128)
  doAssert (zero(Int128) and zero(Int128)) == zero(Int128)
  doAssert (zero(Int128) and one(Int128)) == zero(Int128)
  doAssert (one(Int128) and one(Int128)) == one(Int128)

block int128_xor:
  doAssert (low(Int128) xor low(Int128)) == zero(Int128)
  doAssert (low(Int128) xor high(Int128)) == minus_1
  doAssert (low(Int128) xor zero(Int128)) == low(Int128)
  doAssert (low(Int128) xor one(Int128)) == minus_170141183460469231731687303715884105727
  doAssert (high(Int128) xor high(Int128)) == zero(Int128)
  doAssert (high(Int128) xor zero(Int128)) == high(Int128)
  doAssert (high(Int128) xor one(Int128)) == i_170141183460469231731687303715884105726
  doAssert (zero(Int128) xor zero(Int128)) == zero(Int128)
  doAssert (zero(Int128) xor one(Int128)) == one(Int128)
  doAssert (one(Int128) xor one(Int128)) == zero(Int128)

block int128_not:
  doAssert not(low(Int128)) == high(Int128)
  doAssert not(high(Int128)) == low(Int128)
  doAssert not(zero(Int128)) == minus_1
  doAssert not(one(Int128)) == minus_2

block int128_shl:
  doAssert (zero(Int128) shl 0) == zero(Int128)
  doAssert (zero(Int128) shl 1) == zero(Int128)
  doAssert (zero(Int128) shl 127) == zero(Int128)
  doAssert (zero(Int128) shl 128) == zero(Int128) # equal shl 0

  doAssert (minus_1 shl 0) == minus_1
  doAssert (minus_1 shl 1) == minus_2
  doAssert (minus_1 shl 127) == low(Int128)
  doAssert (minus_1 shl 128) == minus_1 # equal shl 0

  doAssert (low(Int128) shl 0) == low(Int128)
  doAssert (low(Int128) shl 1) == zero(Int128)
  doAssert (low(Int128) shl 127) == zero(Int128)
  doAssert (low(Int128) shl 128) == low(Int128) # equal shl 0

  doAssert (minus_9223372036854775808 shl 0) == minus_9223372036854775808
  doAssert (minus_9223372036854775808 shl 1) == minus_18446744073709551616
  doAssert (minus_9223372036854775808 shl 127) == zero(Int128)
  doAssert (minus_9223372036854775808 shl 128) == minus_9223372036854775808 # equal shl 0

  doAssert (one(Int128) shl 0) == one(Int128)
  doAssert (one(Int128) shl 1) == i_2
  doAssert (one(Int128) shl 127) == low(Int128)
  doAssert (one(Int128) shl 128) == one(Int128) # equal shl 0

  doAssert (high(Int128) shl 0) == high(Int128)
  doAssert (high(Int128) shl 1) == minus_2
  doAssert (high(Int128) shl 127) == low(Int128)
  doAssert (high(Int128) shl 128) == high(Int128) # equal shl 0

  doAssert (i_170141183460469231722463931679029329920 shl 0) == i_170141183460469231722463931679029329920
  doAssert (i_170141183460469231722463931679029329920 shl 1) == minus_18446744073709551616
  doAssert (i_170141183460469231722463931679029329920 shl 127) == zero(Int128)
  doAssert (i_170141183460469231722463931679029329920 shl 128) == i_170141183460469231722463931679029329920 # equal shl 0

  # Template shl
  doAssert (one(Int128) shl zero(Int128)) == one(Int128)
  doAssert (one(Int128) shl one(Int128)) == i_2
  doAssert (one(Int128) shl i_127) == low(Int128)
  doAssert (one(Int128) shl i_128) == one(Int128) # equal shl 0
  doAssert (one(Int128) shl high(Int128)) == low(Int128)

  doAssert (one(Int128) shl zero(UInt128)) == one(Int128)
  doAssert (one(Int128) shl one(UInt128)) == i_2
  doAssert (one(Int128) shl u_127) == low(Int128)
  doAssert (one(Int128) shl u_128) == one(Int128) # equal shl 0
  doAssert (one(Int128) shl high(UInt128)) == low(Int128)

block int128_shr:
  doAssert (zero(Int128) shr 0) == zero(Int128)
  doAssert (zero(Int128) shr 1) == zero(Int128)
  doAssert (zero(Int128) shr 127) == zero(Int128)
  doAssert (zero(Int128) shr 128) == zero(Int128) # equal shr 0

  doAssert (one(Int128) shr 0) == one(Int128)
  doAssert (one(Int128) shr 1) == zero(Int128)
  doAssert (one(Int128) shr 127) == zero(Int128)
  doAssert (one(Int128) shr 128) == one(Int128) # equal shr 0

  doAssert (low(Int128) shr 0) == low(Int128)
  doAssert (low(Int128) shr 1) == minus_85070591730234615865843651857942052864
  doAssert (low(Int128) shr 127) == minus_1
  doAssert (low(Int128) shr 128) == low(Int128) # equal shr 0

  doAssert (high(Int128) shr 0) == high(Int128)
  doAssert (high(Int128) shr 1) == i_85070591730234615865843651857942052863
  doAssert (high(Int128) shr 127) == zero(Int128)
  doAssert (high(Int128) shr 128) == high(Int128) # equal shr 0

  doAssert (minus_1 shr 0) == minus_1
  doAssert (minus_1 shr 1) == minus_1
  doAssert (minus_1 shr 127) == minus_1
  doAssert (minus_1 shr 128) == minus_1 # equal shr 0

  doAssert (minus_18446744073709551616 shr 0) == minus_18446744073709551616
  doAssert (minus_18446744073709551616 shr 1) == minus_9223372036854775808
  doAssert (minus_18446744073709551616 shr 127) == minus_1
  doAssert (minus_18446744073709551616 shr 128) == minus_18446744073709551616 # equal shr 0

  doAssert (i_170141183460469231722463931679029329920 shr 0) == i_170141183460469231722463931679029329920
  doAssert (i_170141183460469231722463931679029329920 shr 1) == i_85070591730234615861231965839514664960
  doAssert (i_170141183460469231722463931679029329920 shr 127) == zero(Int128)
  doAssert (i_170141183460469231722463931679029329920 shr 128) == i_170141183460469231722463931679029329920 # equal shr 0

  # Template shr
  doAssert (high(Int128) shr zero(Int128)) == high(Int128)
  doAssert (high(Int128) shr one(Int128)) == i_85070591730234615865843651857942052863
  doAssert (high(Int128) shr i_127) == zero(Int128)
  doAssert (high(Int128) shr i_128) == high(Int128) # equal shr 0
  doAssert (high(Int128) shr high(Int128)) == zero(Int128)

  doAssert (high(Int128) shr zero(UInt128)) == high(Int128)
  doAssert (high(Int128) shr one(UInt128)) == i_85070591730234615865843651857942052863
  doAssert (high(Int128) shr u_127) == zero(Int128)
  doAssert (high(Int128) shr u_128) == high(Int128) # equal shr 0
  doAssert (high(Int128) shr high(UInt128)) == zero(Int128)
