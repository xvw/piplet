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

exception Malformed_sexpbuilder of string

type fragments =
  | File of File.name
  | External of string
  | Plain of string

type builder = fragments list

let each_nodes elt acc =
  let open Sexp in 
  match elt with
  | Node [Atom "file"; String str] -> (File str) :: acc
  | Node [Atom "plain"; String str]
  | Node [Atom "text"; String str]
  | Node [Atom "txt"; String str]
  | Node [String str] -> (Plain str) :: acc
  | Node [Atom "external"; String str] -> (External str) :: acc 
  | _ ->
    raise (
      Malformed_sexpbuilder (
        "this is invalid: " ^ Sexp.to_string elt))

let builder_of_sexp = function
  | Sexp.Node [Sexp.Atom "css_builder"; Sexp.Node li] ->
    List.fold_right each_nodes li []
  | _ ->
    raise (
      Malformed_sexpbuilder
        "you should have: (css_builder (...))"
    )

let builder_of_file file =
  file
  |> Sexp.of_file
  |> builder_of_sexp


let builder_to_string =
  List.fold_left
    (fun acc e -> match e with
       | File f -> acc ^ "|_ file("^f^")\n"
       | Plain t -> acc ^ "|_txt("^t^")\n"
       | External e -> acc ^ "|_external("^e^")\n")
    ""


let minimize env elt = elt
  

let concat env acc elt =
  acc ^ " " ^ (minimize env elt)

let produce =
  let env = Hashtbl.create 10 in
  List.fold_left (fun acc fragment ->
      match fragment with
      | File file -> let txt = File.read file in concat env acc txt
      | Plain txt -> concat env acc txt
      | External _ -> raise (Util.Not_implemented "External :'(")
    )
    ""

let create filename =
  filename
  |> builder_of_file
  |> produce
   
