type placeholder = string -> string
type placeholders = (string * placeholder) list
    
val substitute : string -> placeholders -> string
