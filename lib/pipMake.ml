let id x = x
let flip f x y = f y x

module Interfaces =
struct

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

end

module Monad =
struct

  include Interfaces.Monad

  module Join (M : JOIN) :
    BASIC_INTERFACE with type 'a t = 'a M.t =
  struct
    include M
    let bind m f = join (fmap f m)
  end

  module Bind (M : BIND) :
    BASIC_INTERFACE  with type 'a t = 'a M.t =
  struct
    include M
    let join m = bind m id
    let fmap f m = bind m (fun x -> return (f x))
  end

  module With (M : BASIC_INTERFACE) :
    INTERFACE with type 'a t = 'a M.t =
  struct

    include M

    let ( >>= ) = bind
    let ( >|= ) x f = fmap f x
    let ( >> ) m n = m >>= (fun _ -> n)

    let ( <=< ) f g = fun x -> g x >>= f
    let ( >=> ) f g = flip ( <=< ) f g
    let ( =<< ) f x = flip ( >>= ) f x

    let ( <*> ) fs ms =
      fs >>= fun f ->
      ms >>= fun x -> return (f x)

    let ( *> ) x = ( <*> ) (fmap (fun _ -> id) x)
    let ( <* ) x _ = ( <*> ) (return (fun x -> x)) x
    let ( <**> ) f x = flip ( <*> ) f x

    let ( <$> ) = fmap
    let ( <$ ) v = fmap (fun _ -> v)

    let liftM = fmap

    let liftM2 f m1 m2 =
      m1 >>= fun x ->
      m2 >>= fun y -> return (f x y)

    let liftM3 f m1 m2 m3 =
      m1 >>= fun x ->
      m2 >>= fun y ->
      m3 >>= fun z -> return (f x y z)

    let liftM4 f m1 m2 m3 m4 =
      m1 >>= fun x ->
      m2 >>= fun y ->
      m3 >>= fun z ->
      m4 >>= fun a -> return (f x y z a)

    let liftM5 f m1 m2 m3 m4 m5 =
      m1 >>= fun x ->
      m2 >>= fun y ->
      m3 >>= fun z ->
      m4 >>= fun a ->
      m5 >>= fun b -> return (f x y z a b)

    let void _ = return ()

  end

  module Plus
      (M : BASIC_INTERFACE)
      (P : PLUS with type 'a t = 'a M.t) :
    PLUS_INTERFACE with type 'a t = 'a M.t  =
  struct
    include With(M)
    let mempty = P.mempty
    let mplus a b = P.mplus a b
    let ( <+> ) = mplus
    let keep_if f x = if f x then return x else mempty
  end

end
