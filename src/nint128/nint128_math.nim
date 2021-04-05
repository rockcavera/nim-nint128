import ./nint128_arithmetic, ./nint128_comparisons, ./nint128_types

func abs*(x: Int128): Int128 =
  result = x

  if isNegative(x):
    result = -result
