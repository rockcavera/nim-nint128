type
  Int128* = object
    when system.cpuEndian == littleEndian:
      lo*: uint64
      hi*: int64
    else:
      hi*: int64
      lo*: uint64

  UInt128* = object
    when system.cpuEndian == littleEndian:
      lo*, hi*: uint64
    else:
      hi*, lo*: uint64

  SomeInt128* = Int128|UInt128

func low*(x: typedesc[Int128]): Int128 {.inline.} =
  ## `-170141183460469231731687303715884105728`
  result.hi = 0x8000000000000000'i64

func high*(x: typedesc[Int128]): Int128 {.inline.} =
  ## `170141183460469231731687303715884105727`
  result.lo = 0xFFFFFFFFFFFFFFFF'u64
  result.hi = 0x7FFFFFFFFFFFFFFF'i64

func low*(x: typedesc[UInt128]): UInt128 {.inline.} = discard
  ## `0`

func high*(x: typedesc[UInt128]): UInt128 {.inline.} =
  ## `340282366920938463463374607431768211455`
  result.lo = 0xFFFFFFFFFFFFFFFF'u64
  result.hi = 0xFFFFFFFFFFFFFFFF'u64

func zero*[T: SomeInt128](x: typedesc[T]): T {.inline.} = discard

func one*[T: SomeInt128](x: typedesc[T]): T {.inline.} =
  result.lo = 1'u64

func ten*[T: SomeInt128](x: typedesc[T]): T {.inline.} =
  result.lo = 10'u64
