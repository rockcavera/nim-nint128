import std/bitops

import ./nint128_bitwise, ./nint128_types

func bitslice*(x: var Int128; slice: Slice[int]) {.inline.} =
  let ux = cast[UInt128](x)

  x = cast[Int128](ux shl (127 - slice.b) shr (127 - slice.b + slice.a))

func bitslice*(x: var UInt128; slice: Slice[int]) {.inline.} =
  x = x shl (127 - slice.b) shr (127 - slice.b + slice.a)

func setBit*[T: SomeInt128](x: var T, bit: range[0..127]) {.inline.} =
  x = x or (one(T) shl bit)

func clearBit*[T: SomeInt128](x: var T, bit: range[0..127]) {.inline.} =
  x = x and not(one(T) shl bit)

func flipBit*[T: SomeInt128](x: var T, bit: range[0..127]) {.inline.} =
  x = x xor (one(T) shl bit)

func testBit*[T: SomeInt128](x: var T, bit: range[0..127]): bool {.inline.} =
  let mask = one(T) shl bit

  (x and mask) == mask

func countSetBits*(x: SomeInt128): int {.inline.} =
  countSetBits(x.hi) + countSetBits(x.lo)

func countLeadingZeroBits*(x: SomeInt128): int {.inline.} =
  if x.hi == 0:
    return 64 + countLeadingZeroBits(x.lo)
  else:
    return countLeadingZeroBits(x.hi)

func countTrailingZeroBits*(x: SomeInt128): int {.inline.} =
  if x.lo == 0:
    return 64 + countTrailingZeroBits(x.hi)
  else:
    return countTrailingZeroBits(x.lo)

func fastLog2*(x: SomeInt128): int {.inline.} =
  if x.hi != 0:
    return 64 + fastLog2(x.hi)
  if x.lo != 0:
    return fastLog2(x.lo)
