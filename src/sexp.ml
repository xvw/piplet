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

type t =
  | Atom of string
  | Node of t list
  | String of string

let atom x = Atom x
let node x = Node x
let string x = String x

let abstract_trim sexp length =
  let rec parse i =
    if length = i then i
    else match sexp.[i] with
      | ' ' | '\t' | '\n' -> parse (succ i)
      | _ -> i
  in parse

let to_eol sexp length =
  let rec parse i =
    if length = i then i
    else match sexp.[i] with
      | '\n' -> succ i
      | _ -> parse (succ i)
  in parse

let parse_atom sexp length =
  let rec parse acc i =
    if length = i then (Atom acc, i)
    else 
      match sexp.[i] with
      | ' ' | '\t' | '\n' | ')' | '(' | ';' -> (Atom acc, i)
      | x -> parse (Util.add_char acc x) (succ i)
  in parse ""

let parse_string sexp length =
  let rec parse acc i =
    if length = i then (String acc, i)
    else
      match sexp.[i] with
      | '"' -> (String acc, succ i)
      | x -> parse (Util.add_char acc x) (succ i)
  in parse ""

let parse_node sexp length i =
  let rec parse acc i =
    match sexp.[i] with
    | ')' -> (List.rev acc, succ i)
    | '(' ->
      let (node, new_i) = parse [] (succ i) in
      let new_acc =
        match node with
        | [] | [Atom ""] -> acc 
        | _ -> (Node node) :: acc
      in parse new_acc (abstract_trim sexp length new_i)
    | ';' -> parse acc (to_eol sexp length i)
    | '"' ->
      let (string, new_i) = parse_string sexp length (succ i) in
      let new_acc = string :: acc in
      parse new_acc (abstract_trim sexp length new_i)
    | _ ->
      let (atom, new_i) = parse_atom sexp length i in
      let new_acc =
        match atom with
        | Atom "" -> acc
        | new_atom -> new_atom :: acc
      in parse new_acc (abstract_trim sexp length new_i)
  in let (res, new_i) = parse [] i in
  (Node res, new_i)


let of_string input =
  let sexp = String.trim input in
  let len = String.length sexp in
  let rec parse i =
    match sexp.[i] with
    | '(' -> fst (parse_node sexp len (succ i))
    | '"' -> fst (parse_string sexp len (succ i))
    | ';' -> parse (to_eol sexp len i)
    | ' ' | '\t' | '\n' -> parse (succ i)
    | _ -> fst (parse_atom sexp len 0)
  in parse 0


let of_file filename =
  filename
  |> File.read
  |> of_string


let string_to_real_string x = "\"" ^ x ^ "\""
let atom_to_string x = " " ^ x ^ " "
let node_to_string x = " (" ^ x ^ ") "
let rec sexp_list_to_string acc = function
  | [] -> acc
  | Atom x :: xs ->
    sexp_list_to_string (acc ^ (atom_to_string x)) xs
  | String x :: xs ->
    sexp_list_to_string (acc ^ (string_to_real_string x)) xs
  | Node x :: xs ->
    let temp = sexp_list_to_string "" x in
    sexp_list_to_string (acc ^ (node_to_string temp)) xs

let to_string = function
  | String x -> string_to_real_string x
  | Atom x -> atom_to_string x
  | Node x ->
    sexp_list_to_string "" x
    |> node_to_string
