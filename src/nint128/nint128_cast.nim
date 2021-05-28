import ./nint128_types

func nint128CastImpl[T: SomeInteger](x: SomeInteger): T {.compileTime.} =
  cast[T](x)

func nint128CastImpl[T: Int128|UInt128](x: Int128|UInt128): T {.compileTime.} =
  result.hi = nint128CastImpl[typeof(result.hi)](x.hi)
  result.lo = x.lo

template nint128Cast*[T](x: Int128|UInt128): T =
  when nimvm:
    nint128CastImpl[T](x)
  else:
    cast[T](x)
