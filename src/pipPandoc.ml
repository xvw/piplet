(* Wrapper for Pandoc *)

let pandoc ~f ~t =
  PipCommand.make
    ~name:"pandoc"
    ~args:[
      ("--latex-engine=", Some "xelatex");
      ("-f", Some f);
      ("-t", Some t)
    ]
    []

let echo content =
  PipCommand.make
    ~name:"echo"
    ~args:[]
    ["\""^content^"\""]

let convert format_in format_out content =
  let open PipCommand in 
  echo content
  ||| pandoc ~f:format_in ~t:format_out
  |> run

