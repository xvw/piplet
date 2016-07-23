module Monad =
struct

  module type COMMON =
  sig
    type 'a t
    val return : 'a -> 'a t
  end

  module type BIND =
  sig
    include COMMON
    val bind : 'a t -> ('a -> 'b t) -> 'b t
  end

  module type JOIN =
  sig
    include COMMON
    val join : ('a t) t -> 'a t
    val fmap : ('a -> 'b) -> 'a t -> 'b t
  end

  module type BASIC_INTERFACE =
  sig
    include COMMON
    val join : ('a t) t -> 'a t
    val bind : 'a t -> ('a -> 'b t) -> 'b t
    val fmap : ('a -> 'b) -> 'a t -> 'b t
  end

  module type INFIX =
  sig
    type 'a t
    val ( <*> ) : ('a -> 'b) t -> 'a t -> 'b t
    val ( <$> ) : ('a -> 'b) -> 'a t -> 'b t
    val ( <$  ) : 'a -> 'b t -> 'a t
    val ( *>  ) : 'a t -> 'b t -> 'b t
    val ( <*  ) : 'a t -> 'b t -> 'a t
    val ( <**>) : 'a t -> ('a -> 'b) t -> 'b t
    val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
    val ( >|= ) : 'a t -> ('a -> 'b) ->  'b t
    val ( <=< ) : ('b -> 'c t) -> ('a -> 'b t) -> 'a -> 'c t
    val ( >=> ) : ('a -> 'b t) -> ('b -> 'c t) -> 'a -> 'c t
    val ( =<< ) : ('a -> 'b t) -> 'a t -> 'b t (* >> *)
    val ( >> )  : 'a t -> 'b t -> 'b t

  end

  module type LIFT =
  sig
    type 'a t

    val liftM : ('a -> 'b) -> 'a t -> 'b t

    val liftM2 :
      ('a -> 'b -> 'c)
      -> 'a t-> 'b t-> 'c t

    val liftM3 :
      ('a -> 'b -> 'c -> 'd)
      -> 'a t-> 'b t-> 'c t -> 'd t

    val liftM4 :
      ('a -> 'b -> 'c -> 'd -> 'e)
      -> 'a t-> 'b t-> 'c t -> 'd t -> 'e t

    val liftM5 :
      ('a -> 'b -> 'c -> 'd -> 'e -> 'f)
      -> 'a t-> 'b t-> 'c t -> 'd t
      -> 'e t -> 'f t
  end

  module type INTERFACE =
  sig
    include BASIC_INTERFACE
    include INFIX with type 'a t := 'a t
    include LIFT with type 'a t := 'a t
    val void : 'a t -> unit t
  end

  module type PLUS =
  sig
    type 'a t
    val mempty : 'a t
    val mplus : 'a t -> 'a t -> 'a t
  end

  module type PLUS_INTERFACE =
  sig
    include INTERFACE
    include PLUS with type 'a t := 'a t
    val ( <+> ) : 'a t -> 'a t -> 'a t
    val keep_if : ('a -> bool) -> 'a -> 'a t
  end

end
