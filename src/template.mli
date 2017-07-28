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

(** Template processing *)

type 'a rule
type 'a ruleset = 'a rule list

(** Create a template rule *)
val macro : string -> ('a -> string -> string) -> 'a rule

(** Apply a rule to a string *)
val apply : 'a ruleset -> 'a  -> string -> string

(** {2 Presaved rules} *)

val inject : ?f:(string -> string -> string) -> 'a -> 'a rule
