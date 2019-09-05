# Package
version       = "0.1.0"
author        = "Jack Tang"
description   = "A collection of data-structure and algorithm as a process of learning Nim"
license       = "MIT"
srcDir        = "src"

# Dependencies
requires "nim >= 0.19.0"

# variables
const testDir       = "tests"

# Tasks
task docs, "generate docs":
  # exec """nim doc --project --index:on src/jetutils.nim"""
  # exec """nim buildIndex -o:src/htmldocs/theindex.html src/htmldocs"""
  exec """nim doc --project src/jetutils.nim"""
  rmDir "docs"
  mvDir "src/htmldocs", "docs"
  
task test, "run test":
  withDir testDir:
    exec "nim c -r test.nim"

