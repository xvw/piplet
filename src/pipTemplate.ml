type placeholder = string -> string
type placeholders = (string * placeholder) list

let change value (key, callback) =
  PipRegexp.str_replace key (callback key) value

let substitute value callbacks =
  List.fold_left change value callbacks


let ( => ) a b = [(a, b)]
let placeholder r = [r]
let ( <+> ) list r = List.append list r 

let text s = (fun _ -> s)
let int i = (fun _ -> string_of_int i)
let float f = (fun _ -> string_of_float f)
let char c = (fun _ -> Printf.sprintf "%c" c)
