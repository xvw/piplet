(* Wrapper for Pandoc *)

let pandoc ~f ~t =
  PipCommand.make
    ~name:"pandoc"
    ~args:[
      ("--latex-engine=", Some "xelatex");
      ("-f", Some f);
      ("-t", Some t)
    ] []

let echo content =
  PipCommand.make
    ~name:"echo"
    ~args:[]
    ["\""^content^"\""]

let convert
    ?(option=[])
    ?(format_in="markdown")
    ?(format_out="html")
    content
  =
  let open PipCommand in 
  echo content
  ||| pandoc ~f:format_in ~t:format_out
  |> add_args option 
  |> run

let convert_file
    ?(option=[])
    ?(format_in="markdown")
    ?(format_out="html")
    file_in file_out
  =
  let open PipCommand in 
  pandoc ~f:format_in ~t:format_out
  |> add_body [file_in]
  |> add_args [("-o", Some file_out)]
  |> run
  |> ignore
