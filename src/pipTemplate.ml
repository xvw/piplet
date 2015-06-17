type placeholder = string -> string
type placeholders = (string * placeholder) list

let change value (key, callback) =
  PipRegexp.str_replace key (callback key) value

let substitute value callbacks =
  List.fold_left change value callbacks
