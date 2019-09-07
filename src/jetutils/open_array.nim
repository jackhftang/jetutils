import tables

proc cmp*[T](a,b: openArray[T]): int =
  runnableExamples:
    assert cmp(@[1,2],@[2,1]) == -1
    assert cmp(@[2,1],@[1,2]) == 1
    assert cmp(@[1,2],@[1,2,3]) == -1
    assert cmp(@[1,2,3],@[1,2]) == 1
  let 
    la = a.len
    lb = b.len
  result = 0 
  for i in 0 ..< min(la,lb):
    let c = cmp(a[i], b[i])
    if c != 0: return c
  if la < lb: return -1
  if la > lb: return 1

proc `<`*[T](a,b: openArray[T]): bool = cmp(a,b) < 0

iterator reverse*[T](arr: openArray[T]): T = 
  ## Reverse iterator 
  runnableExamples:
    var 
      i = 0
      y = [3,2,1]
    for x in [1,2,3].reverse: 
      assert x == y[i]
      inc i 

  var i = arr.high
  while arr.low <= i: 
    yield arr[i] 
    i.dec

proc argmin*[T](arr: openArray[T]): int = 
  ## Find the minimum index of minimum value in an array.
  ## Return -1 if empty.
  if arr.len == 0: return -1 
  var val = arr[result]
  for i in 1..arr.high:
    if arr[i] < val:
      result = i 
      val = arr[i] 

proc argmax*[T](arr: openArray[T]): int = 
  ## Find the maximum index of maximum value in an array.
  ## Return -1 if empty. 
  if arr.len == 0: return -1 
  var val = arr[result]
  for i in 1..arr.high:
    if arr[i] >= val:
      result = i 
      val = arr[i] 

proc groupBy*[T,U](arr: openArray[U], group: proc(x:U): T): TableRef[T,seq[U]] = 
  result = newTable[T,seq[U]](rightSize(arr.len))
  for x in arr:
    let g = group(x)
    if result.contains g: result[g].add(x)
    else: result[g] = @[x]

proc liftSeq*[T,S](f: proc (x: T): S {.closure.}): proc(xs: seq[T]): seq[S] =
  ## lift a function over seq
  runnableExamples:
    proc double(x: int): int = 2*x
    let y = @[1,2,3] |> map double
    check y == @[2,4,6]
  result = proc (xs: seq[T]): seq[S] = 
    for x in xs: result.add(f(x))
  
proc each*[T](xs: openArray[T], f: proc(x: T)) =
  ## similar to for statement, but accept a procedure
  runnableExamples:
    var i = 1
    [1,2,3].each do (x:int) :
      assert x == i
      inc i
  for x in xs: f(x) 