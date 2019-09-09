import unittest, ../../src/jetutils

suite "control": 
  type 
    Foo = enum 
      fooA, fooB, fooC, fooD, fooE, fooF, fooG
  
  test "bsearchMaxIt (enum)":
    check bsearchMaxIt(fooA, fooG, it <= fooE) == fooE

  test "bsearchMaxIt":
    check bsearchMaxIt(0, 10, it <= 3) == 3
    
  test "bsearchMaxIt (imperative form)":
    var res = bsearchMaxIt(0, 10): 
      it <= 3
    check res == 3

  test "bsearchMax":
    let res = bsearchMax(0, 10) do (n:int) -> bool: n*n < 10
    check res == 3

  test "bsearchMin":
    let res = bsearchMin('a', 'z', proc (c:char): bool = c >= 'c')
    check res == 'c'

  test "times":
    var cnt = 0
    3.times: 
      cnt += 1
    check cnt == 3

  test "..< 10": 
    var i = 0
    for j in ..< 10:
      check j == i
      inc i

  test "..< 10u":
    var i : uint = 0
    for j in ..< 10u:
      check j == i
      inc i

  test "forSum":
    var res = ""
    var n = 0
    forSum i in 1..3, "abc":
      res = res & $i 
      n.inc 
    assert res == "123abc"
    assert n == 6

  test "forProd":
    var res : seq[(int,char)]
    var n = 0
    forProd i,j in [1,2], "ab":
      res.add (i,j) 
      n.inc
    assert res == [(1,'a'),(1,'b'),(2,'a'),(2,'b')]
    assert n == 4

  test "forZip i,j in [1,2,3], [4,5,6]":
    forZip i,j in [1,2,3], [4,5,6]:
      assert i + 3 == j

  test "forZip i,j in [1,2,3] \"abcdefg\"":
    forZip i,j in [1,2,3], "abcdefg":
      assert i + ord('a') == ord(j) + 1

  test "forIt [1,2,3]":
    var i = 1
    [1,2,3].forIt:
      check it == i
      inc i

  test "forIt ..10":
    var i = 0
    (..10).forIt: 
      check it == i
      inc i
    check i == 11

  test "forIt nested":
    forIt 'a'..'c':
      assert it is char
      (1..3).forIt:
        assert it is int
  
  test "forIt early break":
    var i = 0
    forIt ..10:
      if it > 5: break
      i += 1
    assert i == 6

  test "3 |> double |> plus1": 
    proc double(x: int): int = 2*x
    proc plus1(x: int): int = x + 1
    let y = 3 |> double |> plus1
    require y == 7