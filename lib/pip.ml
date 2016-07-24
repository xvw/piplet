let id     x     = x
let flip   f x y = f y x
let ( % )  f g x = f (g x)
let ( %> ) f g x = g (f x)
let ( $ )  f x   = f x
let tap    f x   = let _ = f x in x
