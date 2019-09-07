import unittest, ../../src/jetutils

suite "meta":

  test "vectorize":    
    proc double(x:int): int = 2*x
    vectorize(int,double)
    check double([1,2,3]) == @[2,4,6]


  