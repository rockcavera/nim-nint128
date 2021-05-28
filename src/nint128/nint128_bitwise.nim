import ./nint128_types

func `and`*[T: SomeInt128](x, y: T): T {.inline.} =
  result.hi = x.hi and y.hi
  result.lo = x.lo and y.lo

func `or`*[T: SomeInt128](x, y: T): T {.inline.} =
  result.hi = x.hi or y.hi
  result.lo = x.lo or y.lo

func `xor`*[T: SomeInt128](x, y: T): T {.inline.} =
  result.hi = x.hi xor y.hi
  result.lo = x.lo xor y.lo

func `not`*[T: SomeInt128](x: T): T {.inline.} =
  result.hi = not x.hi
  result.lo = not x.lo

func `shl`*[T: SomeInteger](x: UInt128, y: T): UInt128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127
  if y == 0:
    result = x
  elif y == 64:
    result.hi = x.lo
  elif y > 64:
    result.hi = x.lo shl (y and 63)
  else:
    result.hi = (x.hi shl y) or (x.lo shr (64.T - y))
    result.lo = x.lo shl y

func `shl`*[T: SomeInteger](x: Int128, y: T): Int128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127
  if y == 0:
    result = x
  elif y == 64:
    result.hi = cast[int64](x.lo)
  elif y > 64:
    result.hi = cast[int64](x.lo shl (y and 63))
  else:
    result.hi = (x.hi shl y) or cast[int64](x.lo shr (64.T - y))
    result.lo = x.lo shl y

func `shr`*[T: SomeInteger](x: UInt128, y: T): UInt128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127
  if y == 0:
    return x
  elif y == 64:
    result.lo = x.hi
  elif y > 64:
    result.lo = x.hi shr (y and 63)
  else:
    result.hi = x.hi shr y
    result.lo = (x.lo shr y) or (x.hi shl (64.T - y))

func `shr`*[T: SomeInteger](x: Int128, y: T): Int128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127
  if y == 0:
    return x
  elif y == 64:
    result.lo = cast[uint64](x.hi)
    if x.hi < 0:
      result.hi = -1'i64
  elif y > 64:
    result.lo = cast[uint64](x.hi shr (y and 63))
    if x.hi < 0:
      result.hi = -1'i64
  else:
    result.hi = x.hi shr y
    result.lo = (x.lo shr y) or cast[uint64](x.hi shl (64.T - y))

template `shl`*[T: SomeInt128](x: T, y: SomeInt128): T =
  x shl y.lo

template `shr`*[T: SomeInt128](x: T, y: SomeInt128): T =
  x shr y.lo
