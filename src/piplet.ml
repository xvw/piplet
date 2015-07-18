module Regexp   = PipRegexp
module Date     = PipDate
module Channel  = PipChannel
module Util     = PipUtil
module File     = PipFile
module Command  = PipCommand
module Git      = PipGit
module Pandoc   = PipPandoc
module Template = PipTemplate

module type PROJECT =
sig
  val branch_draft : string
  val branch_generator: string
  val branch_pages: string
end

module Project(F : PROJECT) =
struct
  let branch = [
    F.branch_draft;
    F.branch_pages;
    F.branch_generator
  ]
  let init_a_branch name =
    if not (Git.branch "." |> List.mem name)
    then Git.switch_branch ~create:true "." name
  let init_project =
    if (not (Sys.file_exists ".git/"))
    then Sys.command "git init" |> ignore
  let init_branch =
    List.iter init_a_branch branch
end
