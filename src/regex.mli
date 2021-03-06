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

(** The module provides some helper to use regex *)

type pattern = string
type source = string
type replacer = string

(** An uniq separator ... *)
val uniq_separator : pattern

(** Split source with a pattern *)
val split: pattern -> source -> string list

(** Replace [pattern] with [replacer] from [source]*)
val replace: ?all:bool -> pattern -> replacer -> source -> string

(** Remove the [pattern] of the [source] *)
val purge: pattern -> source -> string

(** Minimize (whitespace etc) of a string *)
val minimize: source -> string
