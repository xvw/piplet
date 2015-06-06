(* Regexp Helpers *)
include Str
          
let str_split pattern =
  split (regexp pattern) 

let str_replace pattern form =
  global_replace (regexp pattern) form

let str_purge pattern =
  str_replace pattern ""


