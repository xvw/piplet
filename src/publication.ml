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
; file: File.name
; permalink: File.name
; draft: bool
; date: Datetime.t
; contributors: Contributor.t list
; references: reference list
}

let empty = {
  title = "Unknown"
; abstract = "Unknown"
; tags = []
; file = ""
; permalink = ""
; draft = false
; date = Datetime.now ()
; contributors = []
; references = []
}

let perform_extraction record _ =
  record

let t_of_sexp = function
  | Sexp.(Node [Atom "publication"; Node li]) ->
    List.fold_left perform_extraction empty li
  | _ -> raise (
      Util.Malformed_sexp (
        "Publication", "You should have : (publication (...))"))

let of_file filename =
  filename
  |> Sexp.of_file
  |> t_of_sexp

