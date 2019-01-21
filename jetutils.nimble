# Package

version       = "0.1.0"
author        = "Jack Tang"
description   = "A collection of data-structure and algorithm as a process of learning Nim"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 0.19.2"

# Tasks

before hello:
  echo("About to call hello!")

after hello:
  echo "bye"

task hello, "This is a hello task":
  echo("Hello World!")

task test, "Run the Nimble tester!":
  withDir "tests":
    exec "nim c -r test.nim"

