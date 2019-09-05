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
    3.times do: 
      cnt += 1
    check cnt == 3

  test "..< 10": 
    var i = 0
    for j in ..< 10:
      assert i == j 
      i.inc 
    assert i == 10 

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

  test "forMin":
    forMin i,j in [1,2,3], [4,5,6]:
      assert i + 3 == j

    forMin i,j in [1,2,3], "abcdefg":
      assert i + ord('a') == ord(j) + 1