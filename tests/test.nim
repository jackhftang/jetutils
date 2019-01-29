# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest
import jetutils

test "can add":
  check add(5, 5) == 10

test "can bsearch":
  let res = bsearch(-10, 20) do (x : int) -> bool : x <= 5
  check res == (5,6)

test "sieve result is same as rabinMiller" : 
  let arr = sieve 100000
  for i in 0 ..< arr.len: 
    let r = rabinMiller i
    check arr[i] == r 