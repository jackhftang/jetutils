import unittest, ../../src/jetutils

suite "meta":

  test "vectorize(f,T)":    
    proc double(x:int): int = 2*x
    vectorize(double,int)
    check double([1,2,3]) == @[2,4,6]

  test "vectorize(f,T,S)":
    vectorize(`+`,int,int)
    check [1,2] + [3,4] == @[4,6]

  