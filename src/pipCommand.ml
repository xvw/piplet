(* Command Line format *)

type arg = (string * string option) 

type t = {
  command : string
; args    : arg list
; body    : string list
}

let make ~name ~args body =
  {
    command = name
  ; args    = args
  ; body    = body
  }

let reduce_args acc (arg, value) =
  match value with
  | None    -> acc ^ " " ^ arg
  | Some v  ->
    let placeholder =
      if Str.string_match (Str.regexp ".*\\=$") arg 0
      then ""
      else " "
    in 
    acc ^ " " ^ arg ^ placeholder ^ v

let reduce_body acc value = acc ^ " " ^ value

let to_string cmd =
  let open Printf in
  cmd.command
  ^ List.fold_left reduce_args "" cmd.args
  ^ List.fold_left reduce_body "" cmd.body

let run cmd =
  to_string cmd
  |> PipChannel.In.process_execute
  |> PipChannel.In.to_string

let set_args args cmd = { cmd with args = args }
let set_body body cmd = { cmd with body = body }
                        
let add_args args cmd =
  let total_args = cmd.args @ args in
  set_args total_args cmd

let add_body body cmd =
  let total_body = cmd.body @ body in
  set_body total_body cmd
