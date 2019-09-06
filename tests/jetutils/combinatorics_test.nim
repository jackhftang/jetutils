import unittest, ../../src/jetutils

suite "combinatorics":

  test "combination(3,2)":
    var res = [
      @[0,1],
      @[0,2],
      @[1,2]
    ]
    var i = 0
    for xs in combination(3,2):
      check xs == res[i]
      inc i

  test "combination(5,3)":
    var res = @[
      @[0, 1, 2],
      @[0, 1, 3],
      @[0, 1, 4],
      @[0, 2, 3],
      @[0, 2, 4],
      @[0, 3, 4],
      @[1, 2, 3],
      @[1, 2, 4],
      @[1, 3, 4],
      @[2, 3, 4]
    ]
    var i = 0
    for xs in combination(5,3):
      check xs == res[i]
      inc i

  test "permutation(3)":
    var res : seq[seq[int]] = @[]
    for xs in permutation(3):
      res.add(xs)
    res.sort()
    check res == @[
      @[0,1,2],
      @[0,2,1],
      @[1,0,2],
      @[1,2,0],
      @[2,0,1],
      @[2,1,0],
    ]
    
    

