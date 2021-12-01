# https://stackoverflow.com/questions/3329541/does-gcc-support-128-bit-int-on-amd64
# https://stackoverflow.com/questions/16088282/is-there-a-128-bit-integer-in-gcc/54815033#54815033
# GCC 4.6 and later has a __int128 / unsigned __int128 defined as a built-in type. Use ifdef __SIZEOF_INT128__ to detect it.
# GCC 4.1 and later define __int128_t and __uint128_t as built-in types. (You don't need #include <stdint.h> for these, either.
# CLANG 3.1 and later define __int128 and unsigned __int128
# CLANG 3.0 and later define __int128_t and __uint128_t

## This module allows, when possible, to use the C extension of the GCC and
## CLANG compilers for 128-bit integers (`__int128` and `unsigned __int128`),
## or to use VCC compiler intrinsics. Therefore, there are possibilities to
## optimize the generated code, since, by default, the nint128 package only uses
## pure Nim. It doesn't need to be imported.
## 
## Usage
## =====
## To enable its use it is necessary to compile with:
## `-d:useCInt128=SYMBOL,SYMBOL,...,SYMBOL`.
## 
## Symbols for GCC and CLANG:
## - Comparisons: `cunotequal`, `cnotequal`, `cuequal`, `cequal`,
##   `cugreaterthanorequal`, `cgreaterthanorequal`, `cugreaterthan`,
##   `cgreaterthan`, `culessthan`, `clessthan`, `culessthanorequal`,
##   `clessthanorequal`.
## - Bitwise: `cubitand`, `cbitand`, `cubitor`, `cbitor`, `cubitnot`, `cbitnot`,
##   `cubitxor`, `cbitxor`, `cushl`, `cshl`, `cushr`, `cshr`.
## - Arithmetic: `cuplus`, `cplus`, `cuminus`, `cminus`, `cuminusunary`,
##   `cminusunary`, `cumul64by64To128`, `cumul`, `cmul`, `cudivmod`, `cdivmod`,
##   `cudiv`, `cdiv`, `cumod`, `cmod`.
##
## Symbols for VCC:
## - Comparisons: none.
## - Bitwise: `cushl`, `cushr`.
## - Arithmetic: `cuplus`, `cuminus`, `cumul64by64To128`, `cumul`.
## 
## Symbols prefixed with `c` are for operators of type `Int128` and symbols
## prefixed with `cu` are for operators of type `UInt128`.
##
## Important notes
## ===============
## - Only available for C and C++ backend.
## - The GCC and CLANG compiler do not provide further details on when the C
##   extension for 128-bit integers is available. However, it is believed to be
##   only available for targets that natively support 64-bit integers.
## - The intrinsics used with the VCC compiler are only supported on amd64
##   architecture.
## - The GCC compiler supports `__int128` and `unsigned __int128` types from
##   version 4.6; The CLANG compiler supports it from version 3.1 onwards.
## - To use legacy type for 128-bit integers (`__int128_t` and `__uint128_t`),
##   compile with `-d:useLegacyCInt128`. These types are present in GCC from
##   version 4.1 and CLANG from version 3.0.


const useCInt128 {.strdefine, used.}: string = ""

when defined(useCInt128):
  import std/[strutils, sets]

  var ccSupports {.compileTime.} = initHashSet[string]()

  when sizeof(int) == 8:
    when defined(gcc) or defined(clang):
      const fakeCInt128 = false
      
      when defined(useLegacyCInt128):
        type
          CInt128* {.importc: "__int128_t".} = object
            a, b: uint64

          CUInt128* {.importc: "__uint128_t".} = object
            a, b: uint64
      else:
        type
          CInt128* {.importc: "__int128".} = object
            a, b: uint64

          CUInt128* {.importc: "unsigned __int128".} = object
            a, b: uint64
      
      static:
        ccSupports = toHashSet(["cunotequal", "cnotequal", "cuequal", "cequal",
                                "cugreaterthanorequal", "cgreaterthanorequal",
                                "cugreaterthan", "cgreaterthan", "culessthan",
                                "clessthan", "culessthanorequal",
                                "clessthanorequal", "cubitand", "cbitand",
                                "cubitor", "cbitor", "cubitnot", "cbitnot",
                                "cubitxor", "cbitxor", "cushl", "cshl", "cushr",
                                "cshr", "cuplus", "cplus", "cuminus", "cminus",
                                "cuminusunary", "cminusunary",
                                "cumul64by64To128", "cumul", "cmul", "cudivmod",
                                "cdivmod", "cudiv", "cdiv", "cumod", "cmod"])
    elif defined(vcc):
      const fakeCInt128 = true

      static:
        ccSupports = toHashSet(["cushl", "cushr", "cuplus", "cuminus",
                                "cumul64by64To128", "cumul"])
    else:
      const fakeCInt128 = true
  else:
    const fakeCInt128 = true

  var useCInt128procs {.compileTime.} = initHashSet[string]()

  static:
    for cproc in split(useCInt128, ','):
      if contains(ccSupports, cproc):
        incl(useCInt128procs, cproc)
      else:
        echo "Warning[useCInt128]: `" & cproc & "` is not supported by this compiler or architecture."
else:
  const fakeCInt128 = true

when fakeCInt128:
  type
    CInt128* = object ## For internal use of the package.
      a, b: uint64

    CUInt128* = object ## For internal use of the package.
      a, b: uint64

proc shouldUseCInt128*(cproc: string): bool {.compileTime.} =
  ## For internal use of the package.
  when (not defined(useCInt128)) or (sizeof(int) != 8):
    return false
  else:
    contains(useCInt128procs, cproc)
