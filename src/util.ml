(*
 * My personnal blog engine ...
 *
 * Copyright (C) 2017  Xavier Van de Woestyne <xaviervdw@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *)

exception Not_implemented of string
exception Malformed_sexp of (string * string)

type email = string
type uri = string

let add_char =
  Printf.sprintf "%s%c"

let tokenize value =
  value
  |> String.trim
  |> String.lowercase_ascii


let md5 value =
  value
  |> Digest.string
  |> Digest.to_hex

let gravatar_of
      ?(default="identicon")
      ?(force_default=false)
      ?(rating="g")
      ?(size=200)
      email
  =
  let fd = if force_default then "&f=y" else "" in
  let base = "https://www.gravatar.com/avatar/" in
  let hash = md5 @@ tokenize @@ email in
  Printf.sprintf
    "%s%s?s=%d&d=%s&r=%s%s"
    base
    hash
    size
    default
    rating
    fd

let string_of_in_channel close channel =
  let length = in_channel_length channel in
  let result = Bytes.create length in
  let () = really_input channel result 0 length in
  let _ = close channel in
  Bytes.to_string result

let run_to_string command =
  let channel = Unix.open_process_in command in
  let rec aux acc =
    try aux (add_char acc (input_char channel))
    with End_of_file -> acc
  in
  let result = aux "" in
  let _ = Unix.close_process_in channel in
  result

let exec = run_to_string

let run_to_lines command =
  let channel = Unix.open_process_in command in
  let rec aux acc =
    try aux ((input_line channel) :: acc)
    with End_of_file -> List.rev acc
  in
  let result = aux [] in
  let _ = Unix.close_process_in channel in
  result

let seed =
  Unix.gettimeofday ()
  |> Printf.sprintf "xvw-blog-%h"

let uniq_separator =
  Printf.sprintf "<!%s!>" seed

let external_data uri =
  exec ("curl -L --fail --silent --show-error " ^ uri)


let uniq_to_option s =
  if s = uniq_separator then None
  else Some s


let print color text =
  Color.(c ~fg:color @@ text)
  |> print_endline


let join f separator = function
  | [] -> ""
  | x :: xs ->
    List.fold_left (fun acc elt -> acc ^ separator ^ (f elt) ) (f x) xs
  
