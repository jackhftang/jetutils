# Package

version       = "0.1.0"
author        = "Jack Tang"
description   = "A collection of data-structure and algorithm as a process of learning Nim"
license       = "MIT"
srcDir        = "src"

# Dependencies
requires "nim >= 0.19.0"

# Tasks

const testDir = "tests"

task docs, "generate docs":
  # todo: find option to output to /docs
  exec """nim doc2 --project --index:on src/jetutils.nim"""
  rmDir "docs"
  # todo: not work 
  # mvDir "src/htmldocs", "docs"
  exec """mv src/htmldocs docs"""
  
task test, "run test":
  withDir testDir:
    exec "nim c -r test.nim"

