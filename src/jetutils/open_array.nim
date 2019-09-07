import tables

proc cmp*[T](a,b: openArray[T]): int =
  ## compare elements from left to right until the first unequal, shorter and smaller.
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

proc `<`*[T](a,b: openArray[T]): bool = 
  ## equivalent to `cmp(a,b) < 0`
  cmp(a,b) < 0

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

proc groupBy*[T,S](arr: openArray[S], group: proc(x:S): T): TableRef[T,seq[S]] = 
  ## classify the element of type T by group function S -> T and return a table mapping T to seq[S]
  runnableExamples:
    import tables
    let x = [1,2,3,4,5]
    let y = x.groupBy proc(x:int): string = 
      if x mod 2 == 0: result = "even"
      else: result = "odd"
    assert y[] == { "even": @[2,4], "odd": @[1,3,5] }.toTable
  result = newTable[T,seq[S]](rightSize(arr.len))
  for x in arr:
    let g = group(x)
    if result.contains g: result[g].add(x)
    else: result[g] = @[x]

proc liftSeq*[T,S](f: proc (x: T): S {.closure.}): proc(xs: seq[T]): seq[S] =
  ## lift a function over seq
  runnableExamples:
    template `|>`(x, f : untyped): untyped = f(x)
    proc double(x: int): int = 2*x
    let y = @[1,2,3] |> liftSeq double
    assert y == @[2,4,6]
  runnableExamples:
    template `|>`(x, f : untyped): untyped = f(x)
    proc double(x:int): int = 2*x 
    let y = @[@[1,2,3], @[4,5]] |> liftSeq (liftSeq double)
    assert y == @[@[2, 4, 6], @[8, 10]]
  result = proc (xs: seq[T]): seq[S] = 
    for x in xs: result.add(f(x))
  
proc each*[T](xs: openArray[T], f: proc(x: T)) =
  ## similar to for statement, but accept a procedure
  runnableExamples:
    var i = 1
    [1,2,3].each proc (x:int) =
      assert x == i
      inc i
  for x in xs: f(x) 