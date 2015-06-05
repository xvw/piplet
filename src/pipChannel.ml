(* Easy channel utils *)

module In =
  struct
    
    let process_execute = Unix.open_process_in
    let process_close = Unix.close_process_in
    
    let to_lines chan =
      let rec lines acc =
        try lines ((input_line chan) :: acc)
        with End_of_file -> List.rev acc
      in
      let res = lines [] in
      let _ = process_close chan in res

    let to_string chan =
      let rec string acc =
        try string (Printf.sprintf "%s%c" acc (input_char chan))
        with End_of_file -> acc
      in
      let res = string "" in
      let _ = process_close chan in res
                         
  end
