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
  check bsearch(0,10, proc (x:int):bool = x <= 5) == (5,6)
