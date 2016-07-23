type regex = string
type source = string

val reg : string -> Str.regexp
val according : regex -> source -> int -> bool
val is_matching : regex -> source -> int -> bool
val replace : regex -> string -> source -> string
val purge : regex -> source -> string
