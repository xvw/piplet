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

type name  = string
type email = string
type all = (name, email) Hashtbl.t
           
type t = {
  name:  name
; email: email
}

let create name email = {
  name  = name
; email = email
}

let from_gitlog log =
  match Regex.(split uniq_separator log) with
  | [name; email] -> create name email
  | _ -> create "unknown" "unknown"

let init () = Hashtbl.create 1
