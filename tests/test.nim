import unittest
import jetutils
import tables

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



suite "prime": 
  test "sieve result is same as rabinMiller" : 
    let arr = sieve 100000
    for i, b in arr: 
      let r = rabinMiller i
      check b == r 

suite "array": 
  test "reverse iterator":
    let a = [1,2,3]

    # copy and in-place reverse 
    var b = a
    b.reverse 

    # iterator should be the same as array
    var i = 0 
    for e in a.reverse: 
      check e == b[i]
      i.inc 

  test "groupBy":
    let x = [(1,2),(1,3),(2,4),(3,5)]
    let y = x.groupBy do (x:auto) -> auto: x[0]
    assert y[1] == @[(1,2),(1,3)]
    assert y[2] == @[(2,4)]
    assert y[3] == @[(3,5)]


suite "arithmetic":
  test "pow":
    for b in 2..5:
      var t = 1 
      for n in 0..10:
        check pow(b,n) == t
        t *= b 

  test "pow with modulo":
    for m in [2,3,5,7,11]:
      for b in 2..5:
        var t = 1 
        for n in 0..10:
          check pow(b,n,m) == t mod m
          t *= b mod m 

  test "argmin":
    let a = [2,3,1,4]
    check argmin(a) == 2 

  test "argmin should return -1 if array is empty":
    let a: seq[int] = @[]
    check argmin(a) == -1

  test "fac":
    check fac(0) == 1
    check fac(10) == 3628800

  test "binom":
    for i,n in [1,2,1]:
      check binom(2,i) == n
    for i,n in [1,3,3,1]:
      check binom(3,i) == n
    for i,n in [1,10,45,120,210,252,210,120,45,10,1]:
      check binom(10,i) == n
    
  test "extgcd":
    for v in [(3,5,2,-1), (23,101,22,-5)]:
      let (a,b,m,n) = v
      var x,y = 0
      let g = extgcd(a,b,x,y)
      check g == 1 
      check x == m 
      check y == n

  test "inv":
    for m in [2,3,5,7,101]:
      for i in 1 ..< m:
        let t = inv(i,m)
        check (i*t mod m) == 1



