import ./nint128_types

import ./comparisons/[equal, greaterthan, greaterthanorequal, lessthan, lessthanorequal, notequal]

export equal, greaterthan, greaterthanorequal, lessthan, lessthanorequal, notequal

func isNegative*(x: Int128): bool {.inline.} =
  x.hi < 0
