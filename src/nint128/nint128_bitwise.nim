import ./nint128_types

import ./bitwise/[bitand, bitor, bitxor, bitnot, shift]

export bitor, bitand, bitxor, bitnot, shift

template `shl`*[T: SomeInt128](x: T, y: SomeInt128): T =
  x shl y.lo

template `shr`*[T: SomeInt128](x: T, y: SomeInt128): T =
  x shr y.lo
