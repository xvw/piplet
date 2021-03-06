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



type name = string
type content = string
type line = string
type chmod = int
type extension = string

type document_kind =
  | Html
  | Text
  | Markdown
  | TeX
  (* | AsciiDoc *)

exception Already_exists of name

let read filename =
  filename
  |> open_in
  |> Util.string_of_in_channel close_in

let read_lines filename =
  filename
  |> read
  |> Regex.split "\n"

let write filename content =
  let channel = open_out filename in
  let () = output_string channel content in
  close_out channel

let append ?(chmod=0o664) filename content =
  let channel =
    open_out_gen
      [Open_rdonly; Open_append; Open_creat; Open_text]
      chmod
      filename
  in
  let () = output_string channel content in
  close_out channel

let remove = Sys.remove

let basename filename =
  filename
  |> Filename.basename
  |> Filename.chop_extension

let has_extension filename extension =
  let e = Filename.extension filename in
  e = extension

let mtime filename =
  let stats = Unix.stat filename in
  stats.Unix.st_mtime

let contributors ?(hash = Hashtbl.create 1) filename =
  try
    let _ = 
      "git log --format=\"%an"
      ^ Util.uniq_separator
      ^ "%ae\" "
      ^ filename
      ^ " | uniq"
      |> Util.run_to_lines
      |> List.iter (fun elt ->
             let contrib = Contributor.from_gitlog elt in
             let open Contributor in
             Hashtbl.add hash contrib.email contrib.name
           )
    in hash
  with _ -> hash

let exists = Sys.file_exists

let create ?(chmod=0o777) name content =
  if (exists name) then raise (Already_exists name)
  else append ~chmod:chmod name content

let overwrite ?(chmod=0o777) name content =
  let () =
    try remove name
    with _ -> ()
  in create ~chmod name content

let kind_of filename =
  match Filename.extension filename with
  | ".html" | ".htm"      -> Html
  | ".md"   | ".markdown" -> Markdown
  | ".tex"  | ".latex"    -> TeX
  | _ -> Text

let is_directory = Sys.is_directory

let available_directory filename =
  (exists filename) && (is_directory filename)
