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

(** Actually this module is only for the externals CSS *)

(** Returns the cache's folder name *)
val directory : string

(** Initialize the cache's folder using [Cache.directory] *)
val init : unit -> unit

(** Store an external file *)
val of_external : Util.uri -> File.content -> unit

(** Check if an external file is in the cache *)
val has_external : Util.uri -> bool

(** Get the content of an external file *)
val get_external : Util.uri -> string
