import unittest, ../../src/jetutils

suite "prime": 
  test "sieve result is same as rabinMiller" : 
    let arr = sieve 100000
    for i, b in arr: 
      let r = rabinMiller i
      check b == r 