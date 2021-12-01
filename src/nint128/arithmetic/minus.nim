import ../nint128_bitwise, ../nint128_types, ../nint128_cint128

import addition

func nimUnaryMinus128(x: UInt128): UInt128 {.inline.} =
  not(x) + one(UInt128)

func nimUnaryMinus128(x: Int128): Int128 {.inline.} =
  not(x) + one(Int128)

func cUnaryMinus128(x: UInt128): UInt128 {.inline, used.} =
  let x = cast[CUInt128](x)

  var r {.noInit.}: CUInt128

  {.emit: """`r` = -`x`;""".}

  return cast[UInt128](r)

func cUnaryMinus128(x: Int128): Int128 {.inline, used.} =
  let x = cast[CInt128](x)

  var r {.noInit.}: CInt128

  {.emit: """`r` = -`x`;""".}

  return cast[Int128](r)

func `-`*(x: UInt128): UInt128 {.inline.} =
  ## Unary operator minus
  when nimvm:
    nimUnaryMinus128(x)
  else:
    when shouldUseCInt128("cuminusunary"):
      cUnaryMinus128(x)
    else:
      nimUnaryMinus128(x)

func `-`*(x: Int128): Int128 {.inline.} =
  ## Unary operator minus
  when nimvm:
    nimUnaryMinus128(x)
  else:
    when shouldUseCInt128("cminusunary"):
      cUnaryMinus128(x)
    else:
      nimUnaryMinus128(x)
