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

(** The main generator for Publication  *)


let usage = "./publication_generator.native [-o output] [-url permalink] post.el"
let output = ref Util.uniq_separator
let url = ref "/"
let args = ref ""
let callback_function x = args := x

let () =
  let _ =
    Arg.parse
      [
        "-o", Arg.Set_string output, "The target of the generation";
        "-url", Arg.Set_string url, "The permalink of the publication";
      ]
      callback_function
    
  in
  Printf.printf
    "%s\n%s\n%s"
    !output
    !url
    !args