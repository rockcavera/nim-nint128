import std/algorithm

import ./nint128_arithmetic, ./nint128_bitwise, ./nint128_comparisons, ./nint128_math, ./nint128_types

func basePrefix(x: string, i: var int): range[2..16] =
  result = 10

  if (len(x) - i) < 3: return

  if '0' == x[i]:
    if x[i + 1] in { 'X', 'x' }: # Hexadecimal
      result = 16
      
      inc(i, 2)
    elif x[i + 1] in { 'B', 'b' }: # Binary
      result = 2
      
      inc(i, 2)
    elif x[i + 1] in { 'O', 'o' }: # Octal
      result = 8
      
      inc(i, 2)

template parse(T: typedesc[SomeInt128]) =
  case basePrefix(x, i)
  of 2: # Binary
    while i < len(x):
      let c = x[i]

      case c
      of { '0' , '1' }:
        result = result shl 1
        result.lo = result.lo or uint64(ord(c) - static(ord('0')))
      of {'_'}: discard
      else:
        raise newException(ValueError, "Invalid charactere")

      inc(i)
  of 8: # Octal
    while i < len(x):
      let c = x[i]

      case c
      of { '0' .. '7' }:
        result = result shl 3
        result.lo = result.lo or uint64(ord(c) - static(ord('0')))
      of {'_'}: discard
      else:
        raise newException(ValueError, "Invalid charactere")

      inc(i)
  of 10: # Decimal
    while i < len(x):
      let c = x[i]

      case c
      of { '0'..'9' }:
        result *= ten(T)
        result += T(hi: 0,lo: uint64(ord(c) - static(ord('0'))))
      of {'_'}: discard
      else:
        raise newException(ValueError, "Invalid charactere")

      inc(i)
  of 16: # Hexadecimal
    while i < len(x):
      let c = x[i]

      case c
      of { '0'..'9' }:
        result = result shl 4
        result.lo = result.lo or uint64(ord(c) - static(ord('0')))
      of { 'A'..'F' }:
        result = result shl 4
        result.lo = result.lo or uint64(ord(c) - static(ord('A')) + 10)
      of { 'a'..'f' }:
        result = result shl 4
        result.lo = result.lo or uint64(ord(c) - static(ord('a')) + 10)
      of {'_'}: discard
      else:
        raise newException(ValueError, "Invalid charactere")

      inc(i)
  else: discard

func parseInt128*(x: string): Int128 =
  var
    neg = false
    i = 0

  if '-' == x[i]:
    neg = true

    inc(i)
  
  parse(Int128)

  if neg:
    result = -result

func parseUInt128*(x: string): UInt128 =
  var i = 0

  parse(UInt128)

func toInt(x: SomeInt128): int =
  cast[int](x.lo)

func toBinImpl(x: UInt128, len: range[1..128]): string =
  const bindigits = "01"

  var x = x

  setLen(result, len)

  for i in countdown(len - 1, 0):
    result[i] = bindigits[x.lo and 0x1'u64]
    x = x shr 1

func toBin*(x: UInt128, len: range[1..128]): string =
  toBinImpl(x, len)

func toBin*(x: UInt128): string =
  toBinImpl(x, 128)

func toOctImpl(x: UInt128, len: range[1..43]): string =
  const octdigits = "01234567"
  
  var x = x

  setLen(result, len)

  for i in countdown(len - 1, 0):
    result[i] = octdigits[x.lo and 7'u64]
    x = x shr 3

func toOct*(x: UInt128, len: range[1..43]): string =
  toOctImpl(x, len)

func toOct*(x: UInt128): string =
  toOctImpl(x, 43)

func toHexImpl(x: UInt128, len: range[1..32]): string =
  const hexdigits = "0123456789ABCDEF"
  
  var x = x

  setLen(result, len)

  for i in countdown(len - 1, 0):
    result[i] = hexdigits[x.lo and 0xF'u64]
    x = x shr 4

func toHex*(x: UInt128, len: range[1..32]): string =
  toHexImpl(x, len)

func toHex*(x: UInt128): string =
  toHexImpl(x, 32)

func toString*[T: SomeInt128](x: T): string =
  const digits = "0123456789"
  
  var (q, r) = divmod(x, ten(T))

  while true:
    when T is Int128:
      add(result, digits[toInt(abs(r))])
    else:
      add(result, digits[toInt(r)])

    if zero(T) == q:
      break
    
    (q, r) = divmod(q, ten(T))
  
  when T is Int128:
    if isNegative(x):
      add(result, '-')
  
  reverse(result)

func `$`*(x: SomeInt128): string {.inline.} = toString(x)
