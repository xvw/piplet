module Elt : sig

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
    
end

val authors_of: ?file:string -> string -> Elt.people list
val emails_of: ?file:string -> string -> string option list
val micro_commits_of: ?file:string -> string -> Elt.micro_commit list
val last_update_of: ?file:string -> string -> string
val current_branch: string -> string
val branch: string -> string list
