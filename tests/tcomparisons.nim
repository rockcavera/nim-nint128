import nint128

# UInt128

block uint128_equal:
  doAssert (high(UInt128) == high(UInt128)) == true
  doAssert (high(UInt128) == zero(UInt128)) == false
  doAssert (high(UInt128) == one(UInt128)) == false

  doAssert (zero(UInt128) == zero(UInt128)) == true
  doAssert (zero(UInt128) == one(UInt128)) == false

  doAssert (one(UInt128) == one(UInt128)) == true

block uint128_notequal:
  doAssert (high(UInt128) != high(UInt128)) == false
  doAssert (high(UInt128) != zero(UInt128)) == true
  doAssert (high(UInt128) != one(UInt128)) == true

  doAssert (zero(UInt128) != zero(UInt128)) == false
  doAssert (zero(UInt128) != one(UInt128)) == true

  doAssert (one(UInt128) != one(UInt128)) == false

  # using `ne()`
  doAssert ne(high(UInt128), high(UInt128)) == false
  doAssert ne(high(UInt128), zero(UInt128)) == true
  doAssert ne(high(UInt128), one(UInt128)) == true

  doAssert ne(zero(UInt128), zero(UInt128)) == false
  doAssert ne(zero(UInt128), one(UInt128)) == true

  doAssert ne(one(UInt128), one(UInt128)) == false

block uint128_lt:
  doAssert (zero(UInt128) < zero(UInt128)) == false
  doAssert (zero(UInt128) < one(UInt128)) == true
  doAssert (zero(UInt128) < high(UInt128)) == true

  doAssert (one(UInt128) < zero(UInt128)) == false
  doAssert (one(UInt128) < one(UInt128)) == false
  doAssert (one(UInt128) < high(UInt128)) == true

  doAssert (high(UInt128) < zero(UInt128)) == false
  doAssert (high(UInt128) < one(UInt128)) == false
  doAssert (high(UInt128) < high(UInt128)) == false

block uint128_le:
  doAssert (zero(UInt128) <= zero(UInt128)) == true
  doAssert (zero(UInt128) <= one(UInt128)) == true
  doAssert (zero(UInt128) <= high(UInt128)) == true

  doAssert (one(UInt128) <= zero(UInt128)) == false
  doAssert (one(UInt128) <= one(UInt128)) == true
  doAssert (one(UInt128) <= high(UInt128)) == true

  doAssert (high(UInt128) <= zero(UInt128)) == false
  doAssert (high(UInt128) <= one(UInt128)) == false
  doAssert (high(UInt128) <= high(UInt128)) == true

block uint128_gt:
  doAssert (zero(UInt128) > zero(UInt128)) == false
  doAssert (zero(UInt128) > one(UInt128)) == false
  doAssert (zero(UInt128) > high(UInt128)) == false

  doAssert (one(UInt128) > zero(UInt128)) == true
  doAssert (one(UInt128) > one(UInt128)) == false
  doAssert (one(UInt128) > high(UInt128)) == false

  doAssert (high(UInt128) > zero(UInt128)) == true
  doAssert (high(UInt128) > one(UInt128)) == true
  doAssert (high(UInt128) > high(UInt128)) == false

  # using `gt()`
  doAssert gt(zero(UInt128), zero(UInt128)) == false
  doAssert gt(zero(UInt128), one(UInt128)) == false
  doAssert gt(zero(UInt128), high(UInt128)) == false

  doAssert gt(one(UInt128), zero(UInt128)) == true
  doAssert gt(one(UInt128), one(UInt128)) == false
  doAssert gt(one(UInt128), high(UInt128)) == false

  doAssert gt(high(UInt128), zero(UInt128)) == true
  doAssert gt(high(UInt128), one(UInt128)) == true
  doAssert gt(high(UInt128), high(UInt128)) == false

block uint128_gte:
  doAssert (zero(UInt128) >= zero(UInt128)) == true
  doAssert (zero(UInt128) >= one(UInt128)) == false
  doAssert (zero(UInt128) >= high(UInt128)) == false

  doAssert (one(UInt128) >= zero(UInt128)) == true
  doAssert (one(UInt128) >= one(UInt128)) == true
  doAssert (one(UInt128) >= high(UInt128)) == false

  doAssert (high(UInt128) >= zero(UInt128)) == true
  doAssert (high(UInt128) >= one(UInt128)) == true
  doAssert (high(UInt128) >= high(UInt128)) == true

  # using `gte()`
  doAssert gte(zero(UInt128), zero(UInt128)) == true
  doAssert gte(zero(UInt128), one(UInt128)) == false
  doAssert gte(zero(UInt128), high(UInt128)) == false

  doAssert gte(one(UInt128), zero(UInt128)) == true
  doAssert gte(one(UInt128), one(UInt128)) == true
  doAssert gte(one(UInt128), high(UInt128)) == false

  doAssert gte(high(UInt128), zero(UInt128)) == true
  doAssert gte(high(UInt128), one(UInt128)) == true
  doAssert gte(high(UInt128), high(UInt128)) == true

block uint128_cmp:
  doAssert cmp(zero(UInt128), zero(UInt128)) == 0
  doAssert cmp(zero(UInt128), one(UInt128)) == -1
  doAssert cmp(zero(UInt128), high(UInt128)) == -1

  doAssert cmp(one(UInt128), zero(UInt128)) == 1
  doAssert cmp(one(UInt128), one(UInt128)) == 0
  doAssert cmp(one(UInt128), high(UInt128)) == -1

  doAssert cmp(high(UInt128), zero(UInt128)) == 1
  doAssert cmp(high(UInt128), one(UInt128)) == 1
  doAssert cmp(high(UInt128), high(UInt128)) == 0

#[ Were removed. Use the system generic proc
block uint128_min:
  doAssert min(zero(UInt128), zero(UInt128)) == zero(UInt128)
  doAssert min(zero(UInt128), one(UInt128)) == zero(UInt128)
  doAssert min(zero(UInt128), high(UInt128)) == zero(UInt128)

  doAssert min(one(UInt128), one(UInt128)) == one(UInt128)
  doAssert min(one(UInt128), high(UInt128)) == one(UInt128)

  doAssert min(high(UInt128), high(UInt128)) == high(UInt128)

block uint128_max:
  doAssert max(zero(UInt128), zero(UInt128)) == zero(UInt128)
  doAssert max(zero(UInt128), one(UInt128)) == one(UInt128)
  doAssert max(zero(UInt128), high(UInt128)) == high(UInt128)

  doAssert max(one(UInt128), one(UInt128)) == one(UInt128)
  doAssert max(one(UInt128), high(UInt128)) == high(UInt128)

  doAssert max(high(UInt128), high(UInt128)) == high(UInt128)
]#

# Int128

const minus_1 = Int128(hi: -1'i64, lo: 0xFFFFFFFFFFFFFFFF'u64)

block int128_equal:
  doAssert (low(Int128) == low(Int128)) == true
  doAssert (low(Int128) == high(Int128)) == false
  doAssert (low(Int128) == zero(Int128)) == false
  doAssert (low(Int128) == one(Int128)) == false

  doAssert (high(Int128) == high(Int128)) == true
  doAssert (high(Int128) == zero(Int128)) == false
  doAssert (high(Int128) == one(Int128)) == false

  doAssert (zero(Int128) == zero(Int128)) == true
  doAssert (zero(Int128) == one(Int128)) == false

  doAssert (one(Int128) == one(Int128)) == true

block int128_notequal:
  doAssert (low(Int128) != low(Int128)) == false
  doAssert (low(Int128) != high(Int128)) == true
  doAssert (low(Int128) != zero(Int128)) == true
  doAssert (low(Int128) != one(Int128)) == true

  doAssert (high(Int128) != high(Int128)) == false
  doAssert (high(Int128) != zero(Int128)) == true
  doAssert (high(Int128) != one(Int128)) == true

  doAssert (zero(Int128) != zero(Int128)) == false
  doAssert (zero(Int128) != one(Int128)) == true

  doAssert (one(Int128) != one(Int128)) == false

  # using `ne()`
  doAssert ne(low(Int128), low(Int128)) == false
  doAssert ne(low(Int128), high(Int128)) == true
  doAssert ne(low(Int128), zero(Int128)) == true
  doAssert ne(low(Int128), one(Int128)) == true

  doAssert ne(high(Int128), high(Int128)) == false
  doAssert ne(high(Int128), zero(Int128)) == true
  doAssert ne(high(Int128), one(Int128)) == true

  doAssert ne(zero(Int128), zero(Int128)) == false
  doAssert ne(zero(Int128), one(Int128)) == true

  doAssert ne(one(Int128), one(Int128)) == false

block int128_lt:
  doAssert (low(Int128) < low(Int128)) == false
  doAssert (low(Int128) < minus_1) == true
  doAssert (low(Int128) < zero(Int128)) == true
  doAssert (low(Int128) < one(Int128)) == true
  doAssert (low(Int128) < high(Int128)) == true

  doAssert (minus_1 < low(Int128)) == false
  doAssert (minus_1 < minus_1) == false
  doAssert (minus_1 < zero(Int128)) == true
  doAssert (minus_1 < one(Int128)) == true
  doAssert (minus_1 < high(Int128)) == true

  doAssert (zero(Int128) < low(Int128)) == false
  doAssert (zero(Int128) < minus_1) == false
  doAssert (zero(Int128) < zero(Int128)) == false
  doAssert (zero(Int128) < one(Int128)) == true
  doAssert (zero(Int128) < high(Int128)) == true

  doAssert (one(Int128) < low(Int128)) == false
  doAssert (one(Int128) < minus_1) == false
  doAssert (one(Int128) < zero(Int128)) == false
  doAssert (one(Int128) < one(Int128)) == false
  doAssert (one(Int128) < high(Int128)) == true

  doAssert (high(Int128) < low(Int128)) == false
  doAssert (high(Int128) < minus_1) == false
  doAssert (high(Int128) < zero(Int128)) == false
  doAssert (high(Int128) < one(Int128)) == false
  doAssert (high(Int128) < high(Int128)) == false

block int128_le:
  doAssert (low(Int128) <= low(Int128)) == true
  doAssert (low(Int128) <= minus_1) == true
  doAssert (low(Int128) <= zero(Int128)) == true
  doAssert (low(Int128) <= one(Int128)) == true
  doAssert (low(Int128) <= high(Int128)) == true

  doAssert (minus_1 <= low(Int128)) == false
  doAssert (minus_1 <= minus_1) == true
  doAssert (minus_1 <= zero(Int128)) == true
  doAssert (minus_1 <= one(Int128)) == true
  doAssert (minus_1 <= high(Int128)) == true

  doAssert (zero(Int128) <= low(Int128)) == false
  doAssert (zero(Int128) <= minus_1) == false
  doAssert (zero(Int128) <= zero(Int128)) == true
  doAssert (zero(Int128) <= one(Int128)) == true
  doAssert (zero(Int128) <= high(Int128)) == true

  doAssert (one(Int128) <= low(Int128)) == false
  doAssert (one(Int128) <= minus_1) == false
  doAssert (one(Int128) <= zero(Int128)) == false
  doAssert (one(Int128) <= one(Int128)) == true
  doAssert (one(Int128) <= high(Int128)) == true

  doAssert (high(Int128) <= low(Int128)) == false
  doAssert (high(Int128) <= minus_1) == false
  doAssert (high(Int128) <= zero(Int128)) == false
  doAssert (high(Int128) <= one(Int128)) == false
  doAssert (high(Int128) <= high(Int128)) == true

block int128_gt:
  doAssert (low(Int128) > low(Int128)) == false
  doAssert (low(Int128) > minus_1) == false
  doAssert (low(Int128) > zero(Int128)) == false
  doAssert (low(Int128) > one(Int128)) == false
  doAssert (low(Int128) > high(Int128)) == false

  doAssert (minus_1 > low(Int128)) == true
  doAssert (minus_1 > minus_1) == false
  doAssert (minus_1 > zero(Int128)) == false
  doAssert (minus_1 > one(Int128)) == false
  doAssert (minus_1 > high(Int128)) == false

  doAssert (zero(Int128) > low(Int128)) == true
  doAssert (zero(Int128) > minus_1) == true
  doAssert (zero(Int128) > zero(Int128)) == false
  doAssert (zero(Int128) > one(Int128)) == false
  doAssert (zero(Int128) > high(Int128)) == false

  doAssert (one(Int128) > low(Int128)) == true
  doAssert (one(Int128) > minus_1) == true
  doAssert (one(Int128) > zero(Int128)) == true
  doAssert (one(Int128) > one(Int128)) == false
  doAssert (one(Int128) > high(Int128)) == false

  doAssert (high(Int128) > low(Int128)) == true
  doAssert (high(Int128) > minus_1) == true
  doAssert (high(Int128) > zero(Int128)) == true
  doAssert (high(Int128) > one(Int128)) == true
  doAssert (high(Int128) > high(Int128)) == false

  # using `gt()`
  doAssert gt(low(Int128), low(Int128)) == false
  doAssert gt(low(Int128), minus_1) == false
  doAssert gt(low(Int128), zero(Int128)) == false
  doAssert gt(low(Int128), one(Int128)) == false
  doAssert gt(low(Int128), high(Int128)) == false

  doAssert gt(minus_1, low(Int128)) == true
  doAssert gt(minus_1, minus_1) == false
  doAssert gt(minus_1, zero(Int128)) == false
  doAssert gt(minus_1, one(Int128)) == false
  doAssert gt(minus_1, high(Int128)) == false

  doAssert gt(zero(Int128), low(Int128)) == true
  doAssert gt(zero(Int128), minus_1) == true
  doAssert gt(zero(Int128), zero(Int128)) == false
  doAssert gt(zero(Int128), one(Int128)) == false
  doAssert gt(zero(Int128), high(Int128)) == false

  doAssert gt(one(Int128), low(Int128)) == true
  doAssert gt(one(Int128), minus_1) == true
  doAssert gt(one(Int128), zero(Int128)) == true
  doAssert gt(one(Int128), one(Int128)) == false
  doAssert gt(one(Int128), high(Int128)) == false

  doAssert gt(high(Int128), low(Int128)) == true
  doAssert gt(high(Int128), minus_1) == true
  doAssert gt(high(Int128), zero(Int128)) == true
  doAssert gt(high(Int128), one(Int128)) == true
  doAssert gt(high(Int128), high(Int128)) == false

block int128_gte:
  doAssert (low(Int128) >= low(Int128)) == true
  doAssert (low(Int128) >= minus_1) == false
  doAssert (low(Int128) >= zero(Int128)) == false
  doAssert (low(Int128) >= one(Int128)) == false
  doAssert (low(Int128) >= high(Int128)) == false

  doAssert (minus_1 >= low(Int128)) == true
  doAssert (minus_1 >= minus_1) == true
  doAssert (minus_1 >= zero(Int128)) == false
  doAssert (minus_1 >= one(Int128)) == false
  doAssert (minus_1 >= high(Int128)) == false

  doAssert (zero(Int128) >= low(Int128)) == true
  doAssert (zero(Int128) >= minus_1) == true
  doAssert (zero(Int128) >= zero(Int128)) == true
  doAssert (zero(Int128) >= one(Int128)) == false
  doAssert (zero(Int128) >= high(Int128)) == false

  doAssert (one(Int128) >= low(Int128)) == true
  doAssert (one(Int128) >= minus_1) == true
  doAssert (one(Int128) >= zero(Int128)) == true
  doAssert (one(Int128) >= one(Int128)) == true
  doAssert (one(Int128) >= high(Int128)) == false

  doAssert (high(Int128) >= low(Int128)) == true
  doAssert (high(Int128) >= minus_1) == true
  doAssert (high(Int128) >= zero(Int128)) == true
  doAssert (high(Int128) >= one(Int128)) == true
  doAssert (high(Int128) >= high(Int128)) == true

  # using `gte()`
  doAssert gte(low(Int128), low(Int128)) == true
  doAssert gte(low(Int128), minus_1) == false
  doAssert gte(low(Int128), zero(Int128)) == false
  doAssert gte(low(Int128), one(Int128)) == false
  doAssert gte(low(Int128), high(Int128)) == false

  doAssert gte(minus_1, low(Int128)) == true
  doAssert gte(minus_1, minus_1) == true
  doAssert gte(minus_1, zero(Int128)) == false
  doAssert gte(minus_1, one(Int128)) == false
  doAssert gte(minus_1, high(Int128)) == false

  doAssert gte(zero(Int128), low(Int128)) == true
  doAssert gte(zero(Int128), minus_1) == true
  doAssert gte(zero(Int128), zero(Int128)) == true
  doAssert gte(zero(Int128), one(Int128)) == false
  doAssert gte(zero(Int128), high(Int128)) == false

  doAssert gte(one(Int128), low(Int128)) == true
  doAssert gte(one(Int128), minus_1) == true
  doAssert gte(one(Int128), zero(Int128)) == true
  doAssert gte(one(Int128), one(Int128)) == true
  doAssert gte(one(Int128), high(Int128)) == false

  doAssert gte(high(Int128), low(Int128)) == true
  doAssert gte(high(Int128), minus_1) == true
  doAssert gte(high(Int128), zero(Int128)) == true
  doAssert gte(high(Int128), one(Int128)) == true
  doAssert gte(high(Int128), high(Int128)) == true

block int128_isNegative:
  doAssert isNegative(low(Int128)) == true
  doAssert isNegative(minus_1) == true
  doAssert isNegative(zero(Int128)) == false
  doAssert isNegative(one(Int128)) == false
  doAssert isNegative(high(Int128)) == false

block int128_cmp:
  doAssert cmp(low(Int128), low(Int128)) == 0
  doAssert cmp(low(Int128), minus_1) == -1
  doAssert cmp(low(Int128), zero(Int128)) == -1
  doAssert cmp(low(Int128), one(Int128)) == -1
  doAssert cmp(low(Int128), high(Int128)) == -1

  doAssert cmp(minus_1, low(Int128)) == 1
  doAssert cmp(minus_1, minus_1) == 0
  doAssert cmp(minus_1, zero(Int128)) == -1
  doAssert cmp(minus_1, one(Int128)) == -1
  doAssert cmp(minus_1, high(Int128)) == -1

  doAssert cmp(zero(Int128), low(Int128)) == 1
  doAssert cmp(zero(Int128), minus_1) == 1
  doAssert cmp(zero(Int128), zero(Int128)) == 0
  doAssert cmp(zero(Int128), one(Int128)) == -1
  doAssert cmp(zero(Int128), high(Int128)) == -1

  doAssert cmp(one(Int128), low(Int128)) == 1
  doAssert cmp(one(Int128), minus_1) == 1
  doAssert cmp(one(Int128), zero(Int128)) == 1
  doAssert cmp(one(Int128), one(Int128)) == 0
  doAssert cmp(one(Int128), high(Int128)) == -1

  doAssert cmp(high(Int128), low(Int128)) == 1
  doAssert cmp(high(Int128), minus_1) == 1
  doAssert cmp(high(Int128), zero(Int128)) == 1
  doAssert cmp(high(Int128), one(Int128)) == 1
  doAssert cmp(high(Int128), high(Int128)) == 0

#[ Were removed. Use the system generic proc
block int128_min:
  doAssert min(low(Int128), low(Int128)) == low(Int128)
  doAssert min(low(Int128), minus_1) == low(Int128)
  doAssert min(low(Int128), zero(Int128)) == low(Int128)
  doAssert min(low(Int128), one(Int128)) == low(Int128)
  doAssert min(low(Int128), high(Int128)) == low(Int128)

  doAssert min(minus_1, minus_1) == minus_1
  doAssert min(minus_1, zero(Int128)) == minus_1
  doAssert min(minus_1, one(Int128)) == minus_1
  doAssert min(minus_1, high(Int128)) == minus_1

  doAssert min(zero(Int128), zero(Int128)) == zero(Int128)
  doAssert min(zero(Int128), one(Int128)) == zero(Int128)
  doAssert min(zero(Int128), high(Int128)) == zero(Int128)

  doAssert min(one(Int128), one(Int128)) == one(Int128)
  doAssert min(one(Int128), high(Int128)) == one(Int128)

  doAssert min(high(Int128), high(Int128)) == high(Int128)

block int128_max:
  doAssert max(low(Int128), low(Int128)) == low(Int128)
  doAssert max(low(Int128), minus_1) == minus_1
  doAssert max(low(Int128), zero(Int128)) == zero(Int128)
  doAssert max(low(Int128), one(Int128)) == one(Int128)
  doAssert max(low(Int128), high(Int128)) == high(Int128)

  doAssert max(minus_1, minus_1) == minus_1
  doAssert max(minus_1, zero(Int128)) == zero(Int128)
  doAssert max(minus_1, one(Int128)) == one(Int128)
  doAssert max(minus_1, high(Int128)) == high(Int128)

  doAssert max(zero(Int128), zero(Int128)) == zero(Int128)
  doAssert max(zero(Int128), one(Int128)) == one(Int128)
  doAssert max(zero(Int128), high(Int128)) == high(Int128)

  doAssert max(one(Int128), one(Int128)) == one(Int128)
  doAssert max(one(Int128), high(Int128)) == high(Int128)

  doAssert max(high(Int128), high(Int128)) == high(Int128)
]#
