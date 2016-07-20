type regex = string
val reg : string -> Str.regexp
val according : regex -> string -> int -> bool
