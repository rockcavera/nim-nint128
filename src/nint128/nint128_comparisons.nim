import ./nint128_types

func `==`*(x, y: SomeInt128): bool {.inline.} =
   (x.hi == y.hi) and (x.lo == y.lo)

func `<`*(x, y: SomeInt128): bool {.inline.} =
  (x.hi < y.hi) or ((x.hi == y.hi) and (x.lo < y.lo))

func `<=`*(x, y: SomeInt128): bool {.inline.} =
  # not (x > y)
  (x.hi < y.hi) or ((x.hi == y.hi) and (x.lo <= y.lo))

func isNegative*(x: Int128): bool {.inline.} =
  x.hi < 0
