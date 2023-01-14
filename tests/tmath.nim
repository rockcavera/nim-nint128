import nint128

block abs:
  doAssert abs(i128("-170141183460469231731687303715884105727")) == high(Int128)
  doAssert abs(i128(-1)) == one(Int128)
  doAssert abs(zero(Int128)) == zero(Int128)
  doAssert abs(one(Int128)) == one(Int128)
  doAssert abs(high(Int128)) == high(Int128)
  when defined(danger):
    doAssert abs(low(Int128)) == low(Int128)

block floorSqrt:
  doAssert floorSqrt(zero(Int128)) == zero(Int128)
  doAssert floorSqrt(one(Int128)) == one(Int128)
  doAssert floorSqrt(i128(2)) == one(Int128)
  doAssert floorSqrt(i128(3)) == one(Int128)
  doAssert floorSqrt(i128(4)) == i128(2)
  doAssert floorSqrt(i128(5)) == i128(2)
  doAssert floorSqrt(i128(6)) == i128(2)
  doAssert floorSqrt(i128(7)) == i128(2)
  doAssert floorSqrt(i128(8)) == i128(2)
  doAssert floorSqrt(i128(9)) == i128(3)
  doAssert floorSqrt(i128(16)) == i128(4)
  doAssert floorSqrt(i128(25)) == i128(5)
  doAssert floorSqrt(i128(36)) == i128(6)
  doAssert floorSqrt(i128(49)) == i128(7)
  doAssert floorSqrt(i128(64)) == i128(8)
  doAssert floorSqrt(i128(81)) == i128(9)
  doAssert floorSqrt(i128(100)) == i128(10)
  doAssert floorSqrt(i128(121)) == i128(11)
  doAssert floorSqrt(i128(128)) == i128(11)
  doAssert floorSqrt(i128(144)) == i128(12)
  doAssert floorSqrt(i128(169)) == i128(13)
  doAssert floorSqrt(i128(196)) == i128(14)
  doAssert floorSqrt(i128(225)) == i128(15)
  doAssert floorSqrt(i128(255)) == i128(15)
  doAssert floorSqrt(i128(32890)) == i128(181)
  doAssert floorSqrt(i128(8421371)) == i128(2901)
  doAssert floorSqrt(i128(2155872252)) == i128(46431)
  doAssert floorSqrt(i128(551903297533)) == i128(742901)
  doAssert floorSqrt(i128(141287244169214)) == i128(11886431)
  doAssert floorSqrt(i128(36169534507319295)) == i128(190182897)
  doAssert floorSqrt(i128("9259400833873739776")) == i128(3042926360)
  doAssert floorSqrt(i128("2370406613471677382657")) == i128(48686821763)
  doAssert floorSqrt(i128("606824093048749409959938")) == i128(778989148222)
  doAssert floorSqrt(i128("155346967820479848949743619")) == i128(12463826371563)
  doAssert floorSqrt(i128("39768823762042841331134365690")) == i128(199421221945014)
  doAssert floorSqrt(i128("10180818883082967380770397618171")) == i128(3190739551120236)
  doAssert floorSqrt(i128("2606289634069239649477221790253052")) == i128(51051832817923781)
  doAssert floorSqrt(i128("667210146321725350266168778304782333")) == i128(816829325086780506)
  doAssert floorSqrt(i128("85735205728127073802295555388082225154")) == i128("9259330738672589062")
  doAssert floorSqrt(high(Int128)) == i128("13043817825332782212")
