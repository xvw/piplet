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


(** The module provides some tools to deal with Datetime *)

type t


(** Create seconds *)
val second : float -> t

(** Create minuts *)
val minut : float -> t

(** Create hour *)
val hour : float -> t

(** Create day *)
val day : float -> t

(** Create Week *)
val week : float -> t

(** Extract the data of a Datetime.t *)
val unwrap: t -> ([`Sec | `Min | `Hour | `Day | `Week ] * float)

(** map on Datetime.t *)
val map : (float -> float) -> t -> t


(** Converts Datetime.t to float (in seconds)*)
val to_sec : t -> t


(** Get the current time *)
val now : unit -> t

(** Converts Datetime.t to Unix.tm *)
val to_tm : t -> Unix.tm

(** Convert Unix.tm to Datetime.t*)
val of_tm: Unix.tm -> t

(** Convert Datetime.t to a RSS2 compliant format *)
val to_rfc822 : t -> string
