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

(** Module to describe a publication *)

type reference = {
    name: string
  ; url: string
  ; authors: string list
  ; year: int
  }

type t = {
    title: string
  ; abstract: string
  ; tags: string list
  ; files: File.name list
  ; permalink: File.name
  ; draft: bool
  ; date: float
  ; contributors: Contributor.all
  ; references: reference list
  ; formatted_abstract : string
  ; content : string
  ; lang: string
  }

(** Convert a Sexp to a reference *)
(* val reference_of_sexp : Sexp.t -> reference *)

(** Convert a Sexp to a publication *)
val t_of_sexp : Sexp.t -> t

(** Convert a Sexp file to a publication  *)
val of_file : File.name -> t

(** Convert a publication to an XML node  *)
val to_rss_item : Util.uri -> t -> Rss.item

(** Convert a publication to a Json node *)
val to_json : Util.uri -> t -> Json.t
  
(** Convert a template and a sexpfile to an html publication *)
val create : File.name -> t -> string

  
