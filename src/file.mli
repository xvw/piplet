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

(** The module provides some helper to read/write easily files *)

type name = string
type content = string
type line = string
type chmod = int
type extension = string

(** Returns the content of a file into a Byte *)
val read : name -> content

(** Returns the content of a file into a String list *)
val read_lines: name -> line list

(** [write name content] write [content] into the file referenced by his [name] *)
val write: name -> content -> unit

(** Append content into a file *)
val append: ?chmod:chmod -> name -> content -> unit

(** Remove a file *)
val remove : name -> unit

(** Get the basename of a file *)
val basename: name -> string

(** Check if a file has an extension *)
val has_extension: name -> extension -> bool
