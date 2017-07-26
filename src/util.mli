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


(** Apply trim and lowercase to a string *)
val tokenize: string -> string

(** Hash a string into md5 *)
val md5: string -> string 

(** Returns the url of a gravatar for an email *)
val gravatar_of:
  ?default:string
  -> ?force_default:bool
  -> ?rating:string
  -> ?size:int
  -> email
  -> uri

(** Add a char to a string *)
val add_char: string -> char -> string


(** Converts an in_channel into a string *)
val string_of_in_channel: (in_channel -> 'a) -> in_channel -> string

(** Execute a command shell and returns the result in a string *)
val run_to_string: string -> string

(** Execute a command shell and returns the result in a string list *)
val run_to_lines: string -> string list

(** Generate a seed *)
val seed: string

(** Generate an uniq separator (for regexp orelse *)
val uniq_separator: string
