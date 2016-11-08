(*
 * Piplet
 *
 * Copyright (C) 2016  Xavier Van de Woestyne <xaviervdw@gmail.com>
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

let open_process  = Unix.open_process_in
let close_process = Unix.close_process_in

let chan_coersion f empty close chan =
  let res = f empty  in
  if close then ignore (close_process chan);
  res

let chan_to_lines ?(close=true) chan =
  let rec aux acc =
    try aux ((input_line chan) :: acc)
    with End_of_file -> List.rev acc
  in chan_coersion aux [] close chan

let chan_to_string ?(close=true) chan =
  let rec aux acc =
    try aux (Printf.sprintf "%s%c" acc (input_char chan))
    with End_of_file -> acc
  in chan_coersion aux "" close chan

let perform f process = f (open_process process)
let process_to_lines  = perform chan_to_lines
let process_to_string = perform chan_to_string

