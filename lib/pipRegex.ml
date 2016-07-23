open Pip

type regex = string
type source = string

let reg = Str.regexp

let according r = Str.string_match (reg r)
let is_matching = according

let replace pattern source =
  Str.global_replace (reg pattern) source

let purge pattern = replace pattern ""
