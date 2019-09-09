import unittest, ../../src/jetutils

suite "meta":

  test "vectorize(f,T)":    
    proc double(x:int): int = 2*x
    vectorize(double,int)
    check double([1,2,3]) == [2,4,6]

  test "vectorize(f,T,S) vector-vector":
    vectorize(`+`,int,int)
    check [1,2] + [3,4] == [4,6]
    check 1 + [2,3] == [3,4]
    check [1,2] + 3 == [4,5]

  test "vectorize(f,T,S)":
    vectorize(`+`,int,int)
    vectorize(`*`,int,int)
    let x = [1,2,3]
    check (1+x) * 4 == 4*x + 4
  
  test "nestedUnary (seq)":
    proc double(x:int): int = 2*x
    nestedUnary(double)
    let x = @[@[1,2],@[3,4]]
    check double(x) == @[@[2,4],@[6,8]]

  test "nestedUnary (array)":
    proc double(x:int): int = 2*x
    nestedUnary(double)
    let x = [[1,2],[3,4]]
    check double(x) == [[2,4],[6,8]]

  test "nestedBinary (seq)":
    nestedBinary(`+`) 
    let x = @[@[1,2],@[3,4]]
    let y = @[@[5,6],@[7,8]]
    let z = @[@[6,8],@[10,12]]
    check x + y == z
    check x + @[5,6] == @[@[6,8],@[8,10]]

  test "nestedBinary (array)":
    nestedBinary(`+`) 
    let x = [[1,2],[3,4]]
    let y = [[5,6],[7,8]]
    let z = [[6,8],[10,12]]
    check x + y == z
    check x + [5,6] == [[6,8],[8,10]]