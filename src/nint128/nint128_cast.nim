import ./nint128_types

template nint128Cast*[T: Int128|UInt128](x: Int128|UInt128): T =
  when nimvm:
    when T is Int128 and x is UInt128:
      Int128(hi: cast[int64](x.hi), lo: x.lo)
    elif T is UInt128 and x is Int128:
      UInt128(hi: cast[uint64](x.hi), lo: x.lo)
    elif T is x:
      x
  else:
    cast[T](x)