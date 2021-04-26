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
    return x
  elif y < 64:
    result.hi = (x.hi shl y) or (x.lo shr (64.T - y))
    result.lo = x.lo shl y
  else:
    result.hi = x.lo shl (y - 64)

func `shl`*[T: SomeInteger](x: Int128, y: T): Int128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127

  if y == 0:
    return x
  elif y < 64:
    result.hi = (x.hi shl y) or cast[int64](x.lo shr (64.T - y))
    result.lo = x.lo shl y
  else:
    result.hi = cast[int64](x.lo shl (y - 64))

func `shr`*[T: SomeInteger](x: UInt128, y: T): UInt128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127

  if y == 0:
    return x
  elif y < 64:
    result.hi = x.hi shr y
    result.lo = (x.lo shr y) or (x.hi shl (64.T - y))
  else:
    result.lo = x.hi shr (y - 64)

func `shr`*[T: SomeInteger](x: Int128, y: T): Int128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127

  if y == 0:
    return x
  elif y < 64:
    result.hi = x.hi shr y
    result.lo = (x.lo shr y) or cast[uint64](x.hi shl (64.T - y))
  else:
    if x.hi < 0:
      result.hi = -1'i64
    result.lo = cast[uint64](x.hi shr (y - 64))
