import ./nint128_types

import ./arithmetic/[addition, division, minus, multiplication, subtraction]

export addition, division, minus, multiplication, subtraction

func inc*[T: SomeInt128](x: var T, y: T = one(T)) {.inline.} =
  x = x + y

func dec*[T: SomeInt128](x: var T, y: T = one(T)) {.inline.} =
  x = x - y

#
# Possible addition to the package
#

func add64Plus64ToU128*(x, y: uint64): UInt128 {.inline.} =
  result.lo = x + y
  result.hi = uint64(result.lo < y)

func add64Plus64ToI128*(x, y: uint64): Int128 {.inline.} =
  result.lo = x + y
  result.hi = int64(result.lo < y)
