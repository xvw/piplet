open Pip

let in_to_lines chan =
  let rec lines acc =
    try lines ((input_line chan) :: acc)
    with End_of_file -> List.rev acc
  in lines []

let in_to_string chan =
  let open Printf in
  let rec to_string acc =
    try to_string (sprintf "%s%c" acc (input_char chan))
    with End_of_file -> acc
  in to_string ""
