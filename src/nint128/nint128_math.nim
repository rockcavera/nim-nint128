import ./nint128_arithmetic, ./nint128_bitwise, ./nint128_cast, ./nint128_comparisons, ./nint128_types

func abs*(x: Int128): Int128 =
  ## Returns the absolute value of `x`.
  ##
  ## Note:
  ## - If `x` is `low(Int128)`, an overflow exception is thrown (if overflow checking is turned on).
  result = x

  if isNegative(x):
    result = -result

proc floorSqrt*(x: Int128): Int128 =
  # https://www.geeksforgeeks.org/square-root-of-an-integer/
  ## Returns the floor square root of `x`.
  ##
  ## Notes:
  ## - Uses binary search without recursion.
  ## - Uses extended multiplication of two `UInt128`
  if unlikely(isNegative(x)):
    raise newException(ValueError, "`x` cannot be negative.")

  result = x
  if x > one(Int128):
    var
      x = nint128Cast[UInt128](x)
      start = one(UInt128)
      endd = x shr 1

    while start <= endd:
      var discarded, sqr: UInt128
      let mid = (start + endd) shr 1

      if mul128by128ToTwo128(mid, mid, discarded, sqr):
        endd = mid - 1'u64
      else:
        if sqr == x:
          result = nint128Cast[Int128](mid)
          break

        if sqr <= x:
          start = mid + 1'u64
          result = nint128Cast[Int128](mid)
        else:
          endd = mid - 1'u64
