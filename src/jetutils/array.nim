import tables

proc reverse*[T](arr: var openArray[T]) = 
  ## Reverse an array in-place
  var 
    i = arr.low 
    j = arr.high 
  while i < j: 
    swap(arr[i], arr[j])
    i.inc 
    j.dec

iterator reverse*[T](arr: openArray[T]): T = 
  ## Reverse iterator 
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


