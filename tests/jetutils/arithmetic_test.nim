import unittest, ../../src/jetutils

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