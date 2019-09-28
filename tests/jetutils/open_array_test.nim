import unittest, ../../src/jetutils, algorithm
import algorithm

suite "array": 
  test "argmin":
    let xs = [2,3,1,3,1,2]
    assert argmin(xs) == 2

  test "argmax":
    let xs = [2,3,1,3,1,2]
    assert argmax(xs) == 1

  test "argmins":
    let xs = [2,3,1,3,1,2]
    assert argmins(xs) == @[2,4]

  test "argmaxs":
    let xs = [2,3,1,3,1,2]
    assert argmaxs(xs) == @[1,3]

  test "position":
    let xs = [2,3,1,3,1,2]
    assert xs.position(1) == 2
    assert xs.position(2) == 0
    assert xs.position(3) == 1

  test "positions":
    let xs = [2,3,1,3,1,2]
    assert xs.positions(1) == @[2,4]
    assert xs.positions(2) == @[0,5]
    assert xs.positions(3) == @[1,3]

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

  test "eachIt":
    let x = [0,1,2]
    var i = 0
    x.eachIt:
      assert i == it
      inc i

  test "newSeq - generator":
    let s = newSeq(3, proc(i:int): int = i)
    assert s == @[0,1,2]

  test "summation":
    assert summation([1,2,3]) == 6

  test "fold":
    let y = [1,2,3].fold(0, (a,b) => a+b)
    assert y == 6

  test "unroll":
    let y = [1,2,3].unroll(0, (a,b) => a+b)
    assert y == @[0,1,3,6]