import unittest, ../../src/jetutils, algorithm
import algorithm

suite "array": 

  test "each":
    var 
      arr = [1,2,3]
      i = 1
    arr.each do (x:int): 
      check x == i
      inc i

  test "reverse()":
    var b = [1,2,3]
    b.reverse()
    require b == [3,2,1]

  test "reverse iterator":
    let x = [1,2,3]
    var i = 3
    for e in x.reverse: 
      check e == i
      dec i

  test "groupBy":
    let x = [(1,2),(1,3),(2,4),(3,5)]
    let y = x.groupBy do (x:auto) -> auto: x[0]
    assert y[1] == @[(1,2),(1,3)]
    assert y[2] == @[(2,4)]
    assert y[3] == @[(3,5)]