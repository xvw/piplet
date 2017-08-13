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

(** The module describe a Json object *)

type t = string

(** Convert a list to a Json list *)
val of_list : ('a -> t) -> 'a list -> t

(** Convert an int to a Json int *)
val of_int : int -> t

(** Convert a float to a Json float *)
val of_float : float -> t

(** Convert a boolean to a Json boolean *)
val of_bool : bool -> t

(** Convert an optional value to a Json *)
val of_option : ('a -> t) -> 'a option -> t

(** Represents a Null value in Json  *)
val null : t 

(** Convert an Hashtbl to a Json object *)
val of_hashtbl : ('a -> t) -> (string, 'a) Hashtbl.t -> t
