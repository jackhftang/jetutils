import unittest, ../../src/jetutils

suite "async":
  test "newFutureOf":
    newFutureOf(1).addCallback(proc(i:Future[int]) = check i.read == 1)
