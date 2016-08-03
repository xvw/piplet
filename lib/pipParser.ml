open Pip

type 'a result =
  | Ok of 'a
  | Failure of string
