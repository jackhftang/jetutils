import unittest, ../../src/jetutils

suite "meta":

  test "vectorize(f,T)":    
    proc double(x:int): int = 2*x
    vectorize(double,int)
    check double([1,2,3]) == @[2,4,6]

  test "vectorize(f,T,S) vector-vector":
    vectorize(`+`,int,int)
    check [1,2] + [3,4] == @[4,6]
    check 1 + [2,3] == @[3,4]
    check [1,2] + 3 == @[4,5]

  test "vectorize(f,T,S)":
    vectorize(`+`,int,int)
    vectorize(`*`,int,int)
    let x = [1,2,3]
    check (1+x) * 4 == 4*x + 4
  