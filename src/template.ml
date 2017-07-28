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

type 'a rule =
  | Macro of string * ('a -> string -> string)

type 'a ruleset = 'a rule list

let macro key f = Macro (key, f)

let _apply context content rule =
  match rule with
  | Macro (key, f) ->
    let open Str in
    global_substitute
      (regexp ("{{\\("^key^"\\)}}"))
      (fun buffer ->
         let matched_key = matched_group 1 buffer in 
         f context matched_key
      )
      content

let apply ruleset ctx content =
  List.fold_left
    (_apply ctx)
    content
    ruleset

let delimiter = Str.regexp ":"
let inject =
  macro
    "inject:.+"
    (fun _ matched ->
       match Str.split delimiter matched with
       | [_; key] -> File.read key
       | _ -> raise (Failure "Unparsable injection")
    )
