module In : sig

  val process_execute : string -> in_channel
  val process_close : in_channel -> Unix.process_status
  val to_lines : in_channel -> string list
  val to_string : in_channel -> string
  
end
