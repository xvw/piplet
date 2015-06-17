(* File API *)

let read filename =
  let channel = open_in filename in
  let length  = in_channel_length channel in
  let result  = Bytes.create length in
  let _       = really_input channel result 0 length in
  let _       = close_in channel in
  Bytes.to_string result

let read_lines filename =
  read filename
  |> PipRegexp.str_split "\n"

let raw_write chmod state filename content =
  let channel = open_out_gen state chmod filename in
  let _ = output_string channel content in
  close_out channel

let write ?(chmod=0o664) filename content =
  raw_write
    chmod
    [
      Open_wronly;
      Open_creat;
      Open_trunc;
      Open_text
    ]
    filename content
  
let append ?(chmod=0o664) filename content =
  raw_write
    chmod
    [
      Open_wronly;
      Open_creat;
      Open_append;
      Open_text
    ]
    filename content
  
let prepend ?(chmod=0o664) filename content =
  let total = content ^ (read filename) in
  write ~chmod filename total

let remove = Sys.remove

let basename filename =
  filename
  |> Filename.basename
  |> Filename.chop_extension

let update_with filename callback =
  read filename
  |> callback
  |> write filename
