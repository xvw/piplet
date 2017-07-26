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

let parse_references record elt =
  let open Sexp in
  record

let parse_tags record elt =
  let open Sexp in
  match elt with
  | Atom tag | String tag ->
    { record with
      tags = ((Util.tokenize tag) :: record.tags)
    }
  | x ->
    raise (Util.Malformed_sexp (
        "Publication", "No idea what is : " ^ Sexp.to_string x))


let perform_extraction record elt =
  let open Sexp in
  match elt with
  | Node [Atom "title"; String title] ->
    { record with title = title }
  | Node [Atom "abstract"; String abstract] ->
    { record with abstract = abstract }
  | Node [Atom "permalink"; String permalink] ->
    { record with permalink = permalink }
  | Node [Atom "file"; String file] ->
    { record with file = file }
  | Node [Atom "draft"; Atom (("true" | "false") as flag)] ->
    { record with draft = (flag <> "false") }
  | Node [Atom "date"; String date] ->
    { record with date = Datetime.of_blog_format date }
  | Node [Atom "references"; Node references] ->
    List.fold_left parse_references record references
  | Node [Atom "tags"; Node tags] ->
    List.fold_left parse_tags record tags
  | x ->
    raise (Util.Malformed_sexp (
        "Publication", "No idea what is : " ^ Sexp.to_string x))

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
