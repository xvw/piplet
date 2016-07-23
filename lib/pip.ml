let id x = x
let flip f x y = f y x

module List =
struct

  include List
  open PipMake.Monad

  module Req = Join (
    struct
      type 'a t = 'a list
      let return x = [x]
      let fmap = map
      let join = flatten
    end)

  include Plus
      (Req)
      (struct
        type 'a t = 'a list
        let mempty = []
        let mplus = append
      end)
end
