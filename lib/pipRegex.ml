type regex = string

let reg = Str.regexp
let according r = Str.string_match (reg r)
