(* Wrapper for pandoc *)
val convert:
  ?option:PipCommand.arg list ->
  ?format_in:string ->
  ?format_out:string ->
  string ->
  string
  
val convert_file:
  ?option:PipCommand.arg list ->
  ?format_in:string ->
  ?format_out:string ->
  string ->
  string ->
  unit
