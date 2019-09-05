import unittest, ../../src/jetutils

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