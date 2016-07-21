type flag = (string * string option)

type command = {
  head   : string
; middle : flag list
; tail   : string list
}

let command_to_string cmd =
  let reduce_body acc value = acc ^ " " ^ value in
  let reduce_args acc (arg, value) =
    match value with
    | None   -> reduce_body acc arg
    | Some v ->
      let p = if PipRegex.according ".*\\=$" arg 0 then "" else " " in
      (reduce_body acc arg) ^ p ^ v
  in
  cmd.head
  ^ List.fold_left reduce_args "" cmd.middle
  ^ List.fold_left reduce_body "" cmd.tail

let print_command cmd = print_string (command_to_string cmd)

let open_execution_channel  = Unix.open_process_in
let close_execution_channel = Unix.close_process_in

let flag name value = (name, Some value)
let param name = (name, None)

let make_command ?(flags = []) name args = {
  head   = name
; middle = flags
; tail   = args
}
