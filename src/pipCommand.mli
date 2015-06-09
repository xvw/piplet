type arg = (string * string option) 

type t = {
  command : string
; args    : (string * string option) list
; body    : string list
}

val make : name:string -> args:(arg list) -> string list -> t
val to_string: t -> string
val run : t -> string
val set_args : arg list -> t -> t
val set_body : string list -> t -> t
val add_args : arg list -> t -> t
val add_body : string list -> t -> t
val ( ||| )   : t -> t -> t
