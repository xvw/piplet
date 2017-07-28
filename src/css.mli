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

(** Module to produce CSS *)

exception Malformed_css of string

type fragments
type builder


(** Convert a [Sexp.t] to a [css builder] *)
val builder_of_sexp : Sexp.t -> builder

(** Convert a file to a [css builder] *)
val builder_of_file : File.name -> builder

(** Inspect builder *)
val builder_to_string : builder -> string

(** Produce a css content from a builder *)
val produce : ?interactive:bool -> builder -> string

(** Returns a string (css representation) from a sexp file *)
val create : ?interactive:bool -> File.name -> string
