import tables, algorithm 
export algorithm.reverse

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

proc each*[T](xs: openArray[T], f: proc(x: T)) =
  ## similar to for statement, but accept a procedure
  runnableExamples:
    var i = 1
    [1,2,3].each proc (x:int) =
      assert x == i
      inc i
  for x in xs: f(x) 