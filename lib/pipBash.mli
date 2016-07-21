type command
type flag

val command_to_string : command -> string
val print_command     : command -> unit

val flag         : string -> string -> flag
val param        : string -> flag
val make_command : ?flags:flag list -> string -> string list -> command
