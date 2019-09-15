import asyncdispatch
export asyncdispatch

proc newFutureOf*[T](val: T, fromProc: string = "unspecified"): Future[T] =
  # create new Future of immediate value.
  result = newFuture[T](fromProc)
  result.complete(val)
