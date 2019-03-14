import unittest
import jetutils

test "bsearchMax":
  let res = bsearchMax(0, 10) do (n:int) -> bool: n*n < 10
  check res == 3

test "bsearchMin":
  let res = bsearchMin('a', 'z', proc (c:char): bool = c >= 'c')
  check res == 'c'

test "times":
  var cnt = 0
  3.times do: 
    cnt += 1
  check cnt == 3

test "sieve result is same as rabinMiller" : 
  let arr = sieve 100000
  for i, b in arr: 
    let r = rabinMiller i
    check b == r 

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

