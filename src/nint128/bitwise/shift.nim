import ../nint128_types, ../nint128_cint128

when defined(amd64) and defined(vcc):
  func shiftleft128(lo, hi: uint64, shift: uint8): uint64 {.importc: "__shiftleft128", header: "<intrin.h>".}
  func shiftright128(lo, hi: uint64, shift: uint8): uint64 {.importc: "__shiftright128", header: "<intrin.h>".}

func nimShiftLeft[T: SomeInteger](x: UInt128, y: T): UInt128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127
  if y == 0:
    result = x
  elif y == 64:
    result.hi = x.lo
  elif y > 64.T:
    result.hi = x.lo shl (y and 63)
  else:
    result.hi = (x.hi shl y) or (x.lo shr (64.T - y))
    result.lo = x.lo shl y

func cShiftLeft[T: SomeInteger](x: UInt128, y: T): UInt128 {.inline.} =
  when defined(gcc) or defined(clang):
    let x = cast[CUInt128](x)

    var r {.noInit.}: CUInt128

    {.emit: """`r` = `x` << `y`;""".}

    result = cast[UInt128](r)
  elif defined(vcc):
    result.hi = shiftleft128(x.lo, x.hi, cast[uint8](y))
    result.lo = x.lo shl y
    if (y and 64) > 0:
      result.hi = result.lo
      result.lo = 0'u64

func nimShiftLeft[T: SomeInteger](x: Int128, y: T): Int128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127
  if y == 0:
    result = x
  elif y == 64:
    result.hi = cast[int64](x.lo)
  elif y > 64.T:
    result.hi = cast[int64](x.lo shl (y and 63))
  else:
    result.hi = (x.hi shl y) or cast[int64](x.lo shr (64.T - y))
    result.lo = x.lo shl y

func cShiftLeft[T: SomeInteger](x: Int128, y: T): Int128 {.inline.} =
  let x = cast[CInt128](x)

  var r {.noInit.}: CInt128

  {.emit: """`r` = `x` << `y`;""".}

  result = cast[Int128](r)

func nimShiftRight[T: SomeInteger](x: UInt128, y: T): UInt128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127
  if y == 0:
    return x
  elif y == 64:
    result.lo = x.hi
  elif y > 64.T:
    result.lo = x.hi shr (y and 63)
  else:
    result.hi = x.hi shr y
    result.lo = (x.lo shr y) or (x.hi shl (64.T - y))

func cShiftRight[T: SomeInteger](x: UInt128, y: T): UInt128 {.inline.} =
  when defined(gcc) or defined(clang):
    let x = cast[CUInt128](x)

    var r {.noInit.}: CUInt128

    {.emit: """`r` = `x` >> `y`;""".}

    result = cast[UInt128](r)
  elif defined(vcc):
    result.lo = shiftright128(x.lo, x.hi, cast[uint8](y))
    result.hi = x.lo shr y
    if (y and 64) > 0:
      result.lo = result.hi
      result.hi = 0'u64

func nimShiftRight[T: SomeInteger](x: Int128, y: T): Int128 {.inline.} =
  # There is no undefined behavior when `y` is greater than 127
  let y = y and 127
  if y == 0:
    return x
  elif y == 64:
    result.lo = cast[uint64](x.hi)
    if x.hi < 0:
      result.hi = -1'i64
  elif y > 64.T:
    result.lo = cast[uint64](x.hi shr (y and 63))
    if x.hi < 0:
      result.hi = -1'i64
  else:
    result.hi = x.hi shr y
    result.lo = (x.lo shr y) or cast[uint64](x.hi shl (64.T - y))

func cShiftRight[T: SomeInteger](x: Int128, y: T): Int128 {.inline.} =
  let x = cast[CInt128](x)

  var r {.noInit.}: CInt128

  {.emit: """`r` = `x` >> `y`;""".}

  result = cast[Int128](r)

func `shl`*[T: SomeInteger](x: UInt128, y: T): UInt128 {.inline.} =
  when nimvm:
    nimShiftLeft(x, y)
  else:
    when shouldUseCInt128("cushl"):
      cShiftLeft(x, y)
    else:
      nimShiftLeft(x, y)

func `shl`*[T: SomeInteger](x: Int128, y: T): Int128 {.inline.} =
  when nimvm:
    nimShiftLeft(x, y)
  else:
    when shouldUseCInt128("cshl"):
      cShiftLeft(x, y)
    else:
      nimShiftLeft(x, y)

func `shr`*[T: SomeInteger](x: UInt128, y: T): UInt128 {.inline.} =
  when nimvm:
    nimShiftRight(x, y)
  else:
    when shouldUseCInt128("cushr"):
      cShiftRight(x, y)
    else:
      nimShiftRight(x, y)

func `shr`*[T: SomeInteger](x: Int128, y: T): Int128 {.inline.} =
  when nimvm:
    nimShiftRight(x, y)
  else:
    when shouldUseCInt128("cushr"):
      cShiftRight(x, y)
    else:
      nimShiftRight(x, y)
