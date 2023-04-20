import ./nint128_bitwise.nim, ./nint128_types

import ./vendor/stew/endians2

## This module copies the structure of the `stew/endians2` package, as well as uses it.

#[  `__builtin_bswap128` emerged in gcc 11, so I don't think it should be used /!\

const useBuiltins = not defined(noIntrinsicsEndians)

when defined(gcc) and sizeof(int) == 8 and useBuiltins:
  type
    cuint128_t {.importc: "__uint128_t".} = object
      a, b: uint64

  func swapBytesBuiltin(x: cuint128_t): cuint128_t {.importc: "__builtin_bswap128", nodecl.}
]#

func swapBytesNim(x: UInt128): UInt128 =
  result.lo = swapBytes(x.hi)
  result.hi = swapBytes(x.lo)

func swapBytes*(x: UInt128): UInt128 {.inline.} =
  ## Returns `x` with the order of the bytes reversed.
  when nimvm:
    swapBytesNim(x)
  else:
    when false:
      cast[UInt128](swapBytesBuiltin(cast[cuint128_t](x)))
    else:
      swapBytesNim(x)

func toBytes*(x: UInt128, endian: Endianness = system.cpuEndian): array[16, byte] {.inline.} =
  ## Convert `x` to its corresponding byte sequence using the chosen endianness. By default, native
  ## endianness is used which is not portable!
  let x = if endian == system.cpuEndian: x
          else: swapBytes(x)

  when nimvm:
    for i in 0 .. 15:
      let p = (x shr (i * 8)) and UInt128(hi: 0'u64, lo: 0xff'u64)
      result[i] = byte(p.lo)
  else:
    # https://github.com/nim-lang/Nim/issues/21687
    # Prevents occurrence of this error when nimscript: `Error: undeclared identifier: 'copyMem'`
    when not defined(nimscript):
      copyMem(addr result, unsafeAddr(x), 16)

func toBytesLE*(x: UInt128): array[16, byte] {.inline.} =
  ## Convert a native endian integer to a little endian byte sequence.
  toBytes(x, littleEndian)

func toBytesBE*(x: UInt128): array[16, byte] {.inline.} =
  ## Convert a native endian integer to a big endian byte sequence.
  toBytes(x, bigEndian)

func fromBytes*(T: typedesc[UInt128], x: openArray[byte], endian: Endianness = system.cpuEndian):
               UInt128 {.inline.} =
  ## Converts the sequence of bytes in `x` to a `UInt128` according to the given endianness.
  ##
  ## Note: The default value of `system.cpuEndian` is not portable across machines.
  ##
  ## Panics when `len(x) < 16`. For shorter buffers, copy the data to an `array`, taking care to
  ## zero-fill at the right end - usually the beginning for big endian and the end for little
  ## endian, but this depends on the serialization of the bytes.
  assert(len(x) >= 16, "len(x) < 16")

  when nimvm:
    for i in 0 .. 15:
      result = result or (UInt128(hi: 0'u64, lo: uint64(x[i])) shl (i * 8))
  else:
    # https://github.com/nim-lang/Nim/issues/21687
    # Prevents occurrence of this error when nimscript: `Error: undeclared identifier: 'copyMem'`
    when not defined(nimscript):
      copyMem(addr result, unsafeAddr(x[0]), 16)

  if endian != system.cpuEndian:
    result = swapBytes(result)

func fromBytesBE*(T: typedesc[UInt128], x: openArray[byte]): UInt128 {.inline.} =
  ## Converts a sequence of big endian bytes to a `UInt128`. `x` must be at least 16 bytes long.
  fromBytes(UInt128, x, bigEndian)

func toBE*(x: UInt128): UInt128 {.inline.} =
  ## Convert a native endian value to big endian. Consider `toBytesBE()` instead which may prevent
  ## some confusion.
  if cpuEndian == bigEndian:
    x
  else:
    swapBytes(x)

func fromBE*(x: UInt128): UInt128 {.inline.} =
  ## Convert a big endian value to a native endian. Same as `toBE()`.
  toBE(x)

func fromBytesLE*(T: typedesc[UInt128], x: openArray[byte]): UInt128 {.inline.} =
  ## Converts a sequence of little endian bytes to a `UInt128`. `x` must be at least 16 bytes long.
  fromBytes(UInt128, x, littleEndian)

func toLE*(x: UInt128): UInt128 {.inline.} =
  ## Convert a native endian value to little endian. Consider `toBytesLE()` instead which may
  ## prevent some confusion.
  if cpuEndian == littleEndian:
    x
  else:
    swapBytes(x)

func fromLE*(x: UInt128): UInt128 {.inline.} =
  ## Convert a little endian value to a native endian. Same as `toLE()`.
  toLE(x)
