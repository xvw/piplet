(* Describe minimalist Git API 
   to retreive information about commits
 *)

(* Describe Git Datastructures *)
module Elt =
  struct

    type people = {
      name      : string
    ; email     : string option 
    }

    type micro_commit = {
      author       : string
    ; hash         : string
    ; date         : Unix.tm
    ; subject      : string
    }

    exception Unbound_people of string
    exception Malformed_commit
    
    let string_to_people s =
      match PipRegexp.str_split "|" s with
      | [name; mail] ->
         {
           name  = name;
           email = if mail <> "" then Some mail else None
         }
      | _ -> raise (Unbound_people s)

    
    let string_to_micro_commit s =
      match PipRegexp.str_split "|||" s with
      | [hash;mail;date;subject] ->
        {
          author  = mail;
          hash    = hash;
          date    = PipDate.string_to_gtm date;
          subject = subject 
        }
      | _ -> raise Malformed_commit
                    
  end
                    

(* Command line for git informations 
   Thanks to Zangther (DE LA GALERE)
*)    
module Commands =
  struct

    open Printf

    let select repo =
      PipCommand.make
        ~name:"git"
        ~args:[("-C", Some repo)]
        []

    let log ?(repo=".") ?(file = ".") format =
      (select repo)
      |> PipCommand.add_args
        [("log", None); ("--pretty=", Some ("format:'" ^ format ^ "'"))]
      |> PipCommand.set_body [file]
        
    let authors ?(repo=".") ?(file = ".") format =
      log ~repo ~file format
      |> PipCommand.add_args [("--no-merges", None)]

    let curren_branch repo =
      select repo
      |> PipCommand.add_args
        [
          ("symbolic-ref", None);
          ("-q", None);
          ("--short", Some "HEAD");
        ]

    let branch repo =
      select repo
      |> PipCommand.set_body ["branch"]

  end

let authors_of ?(file = ".") repo =
  Commands.authors ~repo ~file  "%an|%ae"
  |> PipCommand.run
  |> PipRegexp.str_split "\n"
  |> List.map (Elt.string_to_people)

let emails_of ?(file = ".") repo =
  authors_of ~file repo
  |> List.map (fun usr -> usr.Elt.email)

let micro_commits_of ?(file = ".") repo =
  Commands.log
    ~repo ~file "%H|||%ae|||%aD|||%s"
  |> PipCommand.run
  |> PipRegexp.str_split "\n"
  |> List.map (Elt.string_to_micro_commit)

let last_update_of ?(file = ".") repo =
  Commands.log
    ~repo ~file "%ar"
  |> PipCommand.run
  |> PipRegexp.str_split "\n"
  |> List.hd

let current_branch repo =
  Commands.curren_branch repo
  |> PipCommand.run
  |> PipRegexp.str_purge "\n"

let branch repo =
  Commands.branch repo
  |> PipCommand.run
  |> PipRegexp.str_purge "*"
  |> PipRegexp.str_purge " "
  |> PipRegexp.str_split "\n"
