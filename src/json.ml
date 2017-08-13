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

type t = string

let null = "null"
let of_int = string_of_int
let of_float = string_of_float
let of_bool x = if x then "true" else "false"

let of_option f = function
  | None -> null
  | Some x -> f x

let of_list f l =
  "[" ^ (Util.join f ", " l) ^ "]"

let of_hashtbl f hash =
  let result =
    Hashtbl.fold
      (fun k v acc ->
        let key = "\""^k^"\": " in
        let value = (f v) ^ ";" in
        acc ^ key ^ value
      )
      hash
      ""
  in "{" ^ result ^ "}"

