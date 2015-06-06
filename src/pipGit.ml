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

    let select = sprintf "git -C %s"
    let this = select "."
    let exec ?(repo = ".") = sprintf "%s %s" (select repo)

    let log ?(repo = ".") ?(file = ".") format =
      file
      |> sprintf "log --pretty=format:'%s' %s" format
      |> exec ~repo

    let authors ?(repo = ".") ?(file = ".") format =
      file
      |> sprintf
           "log --no-merges --pretty=format:'%s' %s | sort | uniq"
           format
      |> exec ~repo
    
  end

let retreive cmd =
  PipChannel.In.process_execute cmd
  |> PipChannel.In.to_string

let authors_of ?(file = ".") repo =
  Commands.authors ~repo ~file  "%an|%ae"
  |> retreive
  |> PipRegexp.str_split "\n"
  |> List.map (Elt.string_to_people)

let emails_of ?(file = ".") repo =
  authors_of ~file repo
  |> List.map (fun usr -> usr.Elt.email)

let micro_commits_of ?(file = ".") repo =
  Commands.log
    ~repo ~file "%H|||%ae|||%aD|||%s"
  |> retreive
  |> PipRegexp.str_split "\n"
  |> List.map (Elt.string_to_micro_commit)

let last_update_of ?(file = ".") repo =
  Commands.log
    ~repo ~file "%ar"
  |> retreive
  |> PipRegexp.str_split "\n"
  |> List.hd

let current_branch repo =
  Commands.exec ~repo "symbolic-ref -q --short HEAD"
  |> retreive
  |> PipRegexp.str_purge "\n"

let branch repo =
  Commands.exec ~repo "branch"
  |> retreive
  |> PipRegexp.str_purge "*"
  |> PipRegexp.str_purge " "
  |> PipRegexp.str_split "\n"
