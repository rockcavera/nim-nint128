Nint128, as the name suggests, is a package to work with integers, signed and unsigned, of 128 bits.

Currently the package implements 128-bit operations in pure Nim. Therefore, it is highly portable.

For optimizations, you can use, when possible, the C extension for 128-bit integers present in the GCC and CLANG compiler or VCC compiler intrinsics. For more information, see this [here](https://rockcavera.github.io/nim-nint128/nint128/nint128_cint128.html).

# Status
The basic implementation is ready, but not fully tested. Visit the `tests` directory to see what has been tested and what remains to be tested.

Some things may change and break down in the future.

# Install
`nimble install nint128`

or

`nimble install https://github.com/rockcavera/nim-nint128.git`

# Basic Use
```nim
import pkg/nint128

const
  u999 = u128("0b1111100111") ## Defines a constant from a binary string.
  uHigh = u128("0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF") ## Defines a constant from a hexadecimal string.
  i333 = i128("0b101001101") ## Defines a constant from a binary string.
  iHigh = i128("0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF") ## Defines a constant from a hexadecimal string.

## Comparisons `UInt128`
echo uHigh == high(UInt128)
echo uHigh != low(UInt128)
echo uHigh > zero(UInt128)
echo uHigh >= one(UInt128)
echo uHigh < ten(UInt128)
echo uHigh <= u999

## Comparisons `Int128`
echo iHigh == high(Int128)
echo iHigh != low(Int128)
echo iHigh > zero(Int128)
echo iHigh >= one(Int128)
echo iHigh < ten(Int128)
echo iHigh <= i333
echo isNegative(iHigh)

## Initialization of `UInt128` and `Int128` variables.
var
  a, b: UInt128
  c, d: Int128

a = u128(1234567890) ## Transforms the `int` `1234567890` into `UInt128`
b = u128("18446744073709551616") ## Transforms `string` `18446744073709551616` into `UInt128`

c = i128(1234567890) ## Transforms the `int` `-13579` into `Int128`
d = i128("-18446744073709551616") ## Transforms `string` `-18446744073709551616` to `Int128`

## Basic arithmetic `UInt128`
a = a + b
b = b - u128(9223372036854775808'u64)
a = a * u999
b = uHigh div a
b = uHigh mod a
(a, b) = divmod(uHigh, a)

## Basic arithmetic `Int128`
c = c + d
d = d - i333
c = c * i128("-3")
d = iHigh div c
d = iHigh mod c
(c, d) = divmod(iHigh, c)

## Bitwise operation `UInt128`
a = a and b
a = a or b
a = a xor b
a = not(a)
a = a shl 12
b = b shr 64

## Bitwise operation `Int128`
c = c and d
c = c or d
c = c xor d
c = not(c)
c = c shl 12
d = d shr 64
```

# Documentation
https://rockcavera.github.io/nim-nint128/theindex.html

# License
- The file `div2n1n.nim`, in the directory `src/nint128/vendor/stint/`, is authored by Status Research & Development GmbH, part of the stint package.
- The file `endians2.nim`, in the directory `src/nint128/vendor/stew/`, is authored by Status Research & Development GmbH, part of the stew package.
