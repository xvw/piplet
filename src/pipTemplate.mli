type placeholder = string -> string
type placeholders = (string * placeholder) list
    
val substitute : string -> placeholders -> string
val placeholder : (string * placeholder) -> placeholders
val ( <+> ): placeholders -> placeholders -> placeholders
val ( => ) : 'a -> 'b -> ('a * 'b) list

val text: string -> placeholder
val int: int -> placeholder
val float: float -> placeholder
val char: char -> placeholder
