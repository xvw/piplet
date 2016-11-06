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

let chan_to_lines ?(close=true) chan =
  let rec aux acc =
    try aux ((input_line chan) :: acc)
    with End_of_file -> List.rev acc
  in
  let res = aux [] in
  if close then ignore (close_process chan);
  res

let chan_to_string ?(close=true) chan =
  let rec aux acc =
    try aux (Printf.sprintf "%s%c" acc (input_char chan))
    with End_of_file -> acc
  in
  let res = aux "" in
  if close then ignore (close_process chan);
  res

