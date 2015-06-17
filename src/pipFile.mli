(* File API *)
val read : string -> string
val read_lines : string -> string list
val write : ?chmod:int -> string -> string -> unit
val append : ?chmod:int -> string -> string -> unit
val prepend : ?chmod:int -> string -> string -> unit
val remove : string -> unit
val basename : string -> string
val update_with : string -> (string -> string) -> unit
