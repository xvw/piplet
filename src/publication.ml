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

let empty_ref = {
    name = ""
  ; url = ""
  ; authors = []
  ; year = 0
  }

type t = {
    title: string
  ; abstract: string
  ; tags: string list
  ; files: File.name list
  ; permalink: File.name
  ; draft: bool
  ; date: Datetime.t
  ; contributors: (Contributor.name, Contributor.email) Hashtbl.t
  ; references: reference list
  ; formatted_abstract : string
  ; content : string
  ; lang: string
  }

let empty = {
    title = "Unknown"
  ; abstract = "Unknown"
  ; tags = []
  ; files = []
  ; permalink = ""
  ; draft = false
  ; date = Datetime.now ()
  ; contributors = Hashtbl.create 1
  ; references = []
  ; formatted_abstract = ""
  ; content = ""
  ; lang = "fr"
  }

let specific_reference record elt =
  let open Sexp in
  match elt with
  | Node [Atom "name"; String name] ->
     { record with name = name}
  | Node [Atom "url"; String url] ->
     { record with url = url}
  | Node [Atom "year"; (Atom year | String year)] ->
     { record with year = int_of_string year}
  | Node [Atom "authors"; Node authors] ->
     let authors =
       List.fold_left
         (fun acc author ->
           match author with
           | String name -> name :: acc
           | x ->
              raise (
                  Util.Malformed_sexp (
                      "Publication", "No idea what is : " ^ Sexp.to_string x))
         )
         record.authors
         authors
     in { record with authors = authors}
  | x ->
     raise (
         Util.Malformed_sexp (
             "Publication", "No idea what is : " ^ Sexp.to_string x))

let parse_references record elt =
  let open Sexp in
  match elt with
  | Node data ->
     let a_ref = List.fold_left specific_reference empty_ref data in
     { record with references = (a_ref :: record.references) }
  | x ->
     raise (
         Util.Malformed_sexp (
             "Publication", "No idea what is : " ^ Sexp.to_string x))

let parse_tags record elt =
  let open Sexp in
  match elt with
  | Atom tag | String tag ->
     { record with tags = ((Util.tokenize tag) :: record.tags)}
  | x ->
     raise (
         Util.Malformed_sexp (
             "Publication", "No idea what is : " ^ Sexp.to_string x))

let parse_files record elt =
  let open Sexp in
  match elt with
  | Atom file | String file ->
     { record with files = file :: record.files}
  | x ->
     raise (
         Util.Malformed_sexp (
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
  | Node [Atom ("file" | "files"); String file] ->
     { record with files = file :: record.files }
  | Node [Atom ("file" | "files"); Node files] ->
     List.fold_left parse_files record files
  | Node [Atom "draft"; Atom (("true" | "false") as flag)] ->
     { record with draft = (flag <> "false") }
  | Node [Atom "date"; String date] ->
     { record with date = Datetime.of_blog_format date }
  | Node [Atom "references"; Node references] ->
     List.fold_left parse_references record references
  | Node [Atom "lang"; (Atom lang | String lang)] ->
     { record with lang = lang}
  | Node [Atom "tags"; Node tags] ->
     List.fold_left parse_tags record tags
  | x ->
     raise (
         Util.Malformed_sexp (
             "Publication", "No idea what is : " ^ Sexp.to_string x))

let t_of_sexp = function
  | Sexp.(Node [Atom "publication"; Node li]) ->
     let record = List.fold_left perform_extraction empty li in
     { record with files = List.rev record.files }
  | _ -> raise (
             Util.Malformed_sexp (
                 "Publication", "You should have : (publication (...))"))

let create_content content file =
  content ^ (Processor.of_file file) ^ "  \n"

let process_files files =
  let content = List.fold_left create_content "" files in
  let length = String.length content in
  if length > 3 then String.sub content 0 (length - 3)
  else content

let of_file filename =
  let record =
    filename
    |> Sexp.of_file
    |> t_of_sexp
  and contributors = File.contributors filename in
  {
    record with
    contributors = contributors
  ; formatted_abstract = Processor.of_markdown record.abstract
  ; content = List.fold_left create_content "" record.files
  }

let tag_to_li acc tags =
  acc
  ^ Format.sprintf
      "<li class=\"piplet--li-tag\" data-class=\"tag\" data-tag=\"%s\">%s</li>"
      tags
      tags

let tags_to_ul post _ =
  "<ul class=\"piplet--ul-tags\" data-class=\"tag\">"
  ^ (List.fold_left tag_to_li "" post.tags)
  ^ "</ul>"

let title_rule =
  Template.macro
    "title"
    (fun post _ -> post.title)
  
let abstract_rule =
  Template.macro
    "abstract"
    (fun post _ -> post.abstract)
  
let content_rule =
  Template.macro
    "content"
    (fun post _ -> post.content)
  
let tags_rules =
  Template.macro
    "tags"
    (fun post _ -> Util.join_str ", " post.tags)

let tags_list_rules =
  Template.macro
    "li-tags"
    tags_to_ul


let to_rss_item base_link publication =
  "<item>"
  ^ "<title>" ^ publication.title ^ "</title>"
  ^ "<link>" ^ (Util.concat_uri base_link publication.permalink)
  ^ "</link>"
  ^ "<description>" ^ publication.abstract ^  "<description>"
  ^ "<pubDate>" ^ (Datetime.to_rfc822 publication.date)  ^ "</pubDate>"
  ^ "<generator>piplet-v1</generator>"
  ^ "<language>" ^ publication.lang  ^ "</language>"
  ^ "</item>"
  |> Rss.item_of_string


let to_json base_link pub =
  Format.sprintf
    {json|
     {
       "title": %s; 
       "link": %s; 
       "date": %s; 
       "tags": %s;
       "abstract": %s;
     }
     |json}
    (pub.title)
    (Util.concat_uri base_link pub.permalink)
    (Datetime.to_rfc822 pub.date)
    (Json.of_list Util.id pub.tags)
    pub.abstract
  

let create template sexp =
  let publication = t_of_sexp sexp in
  File.read template
  |> Template.apply
       [
         title_rule
       ; abstract_rule
       ; content_rule
       ; tags_rules
       ; tags_list_rules
       ]
       publication
