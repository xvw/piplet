(* Wrapper for pandoc *)
val convert: ?format_in:string -> ?format_out:string -> string -> string
val convert_file: ?format_in:string -> ?format_out:string ->
  string -> string -> unit
