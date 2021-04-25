Nint128, as the name suggests, is a package to work with integers, signed and unsigned, of 128 bits, always aiming at the best possible performance.

Currently the package implements 128-bit operations in pure Nim. Therefore, it is highly portable.

There may be C code and embedded assembly, as well as use of intrinsics.

# Status
The basic implementation is ready, but not fully tested. Visit the `tests` directory to see what has been tested and what remains to be tested.

Some things may change and break down in the future.

# Install
`nimble install https://github.com/rockcavera/nim-nint128.git`

# Basic Use
```nim
import pkg/nint128

var a = u128(1234567890'u64) + u128(9876543210'u64)

echo a

a = a * u128(high(uint64))

echo a

a = a div u128(918273645'u64)

echo a

echo a == u128("223205603201487305154")

echo a > (one(UInt128) shl 127)

echo a and u128("8888888888888")

echo u128("0xabcdef1234567890abcdf")

echo u128("0b10101010101010101010101010101010101010101010101010101010101010101010101010101010101010")
```

# License
The file `nint128_udiv.nim`, in the directory `src`, is authored by Status Research & Development GmbH, part of the Stint package.
