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

let let_regexp = Str.regexp "@let \\([A-Za-z]+\\)(\\([^()]+\\))"
let get_regexp = Str.regexp "@get(\\([A-Za-z]+\\))"
let comment_regexp = Str.regexp "/\\*\\|\\*/"
let space_regexp = Str.regexp " +"

exception Malformed_css of string

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
      Util.Malformed_sexp (
        ("Css", "this is invalid: " ^ Sexp.to_string elt)))

let builder_of_sexp = function
  | Sexp.Node [Sexp.Atom "css_builder"; Sexp.Node li] ->
    List.fold_right each_nodes li []
  | _ ->
    raise (
      Util.Malformed_sexp
        ("Css", "you should have: (css_builder (...))"))

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


let remove_comments str =
  let res = Str.full_split comment_regexp str in
  List.fold_left (
    fun (flag, str) elt ->
      match (flag, elt) with
      | (true, Str.Delim "*/") -> (false, str)
      | (true, _) -> (true, str)
      | (false, Str.Delim "/*") -> (true, str)
      | (false, Str.Text block) -> (false, str ^ block)
      | (_, Str.Delim x) -> raise (Malformed_css x)
  ) (false, "") res
  |> snd


let set_variables env elt =
  Str.(
    global_substitute
      let_regexp
      (fun result ->
         let key = matched_group 1 result in
         let value = matched_group 2 result in
         let _ = Hashtbl.add env key value in
         ""
      )
      elt
  )

let replace_variables env elt =
  Str.(
    global_substitute
      get_regexp
      (fun result ->
         let key = matched_group 1 result in
         Hashtbl.find env key
      )
      elt
  )

let minimize elt =
  elt
  |> Regex.replace "\n" " "
  |> remove_comments
  |> Regex.replace "\t" " "
  |> Str.global_replace space_regexp " "


let concat acc elt =
  acc ^ " " ^ (minimize elt) ^ "\n"


let concat_with_env env acc elt =
  elt
  |> minimize
  |> set_variables env
  |> replace_variables env
  |> concat acc

let produce ?(interactive=false) =
  let env = Hashtbl.create 1 in
  List.fold_left (fun acc fragment ->
      match fragment with
      | File file ->
        let txt = File.read file in
        concat_with_env env acc txt
      | Plain txt -> concat_with_env env acc txt
      | External uri ->
        if not (Cache.has_external uri) then
          let ext = Util.external_data uri in
          let () =
            if interactive
            then Cache.of_external uri ext
          in concat acc ext
        else concat acc (Cache.get_external uri)
    )
    ""

let create ?(interactive=false)filename =
  let res =
    filename
    |> builder_of_file
    |> produce ~interactive
    |> String.trim
  in res ^ " /* EOF */"
