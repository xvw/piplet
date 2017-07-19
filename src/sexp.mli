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

(** A cheap approach of Sexp parsing... *)

type t =
  | Atom of string
  | Node of t list

exception Malformed_sexp of int

(** Convert a string to a Sexp *)
val of_string : string -> t

(** Convert a file into a Sexp *)
val of_file: File.name -> t

(** Convert a Sexp to a string *)
val to_string: t -> string

(** Provide function to serialize/deserialize into sexp *)
module type SEXP_CONV =
sig
  type base
  val from_sexp : t -> base
  val to_sexp: base -> t
end
