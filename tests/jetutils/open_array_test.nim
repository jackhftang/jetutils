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

  test "liftSeq":
    proc double(x: int): int = 2*x
    let y = @[1,2,3] |> liftSeq double
    check y == @[2,4,6]

  test "map - indexed":
    let x = [1,2,3]
    let y = x.map(proc(i, x:int): int = i+x)
    assert y == [1,3,5]

  test "each - indexed":
    let x = [0,1,2]
    x.each(proc(i:int, x:int): void = assert(i == x))

  test "newSeq - generator":
    let s = newSeq(3, proc(i:int): int = i)
    assert s == @[0,1,2]