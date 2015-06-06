(* Date's Helpers *)


let months_array =
    [| "Jan"; "Feb"; "Mar"; "Apr"; "May"; "Jun";
       "Jul"; "Aug"; "Sep"; "Oct"; "Nov"; "Dec"; |]
    
let months_hash () =
  let hash = Hashtbl.create 12 in
  let _ =
    Array.iteri
      (fun i x -> Hashtbl.add hash x i) months_array
  in hash

let days_array = [| "Sun"; "Mon"; "Tue"; "Wed"; "Thu"; "Fri"; "Sat" |]

let days_hash () =
  let hash = Hashtbl.create 7 in
  let _ =
    Array.iteri
      (fun i x -> Hashtbl.add hash x i) days_array
  in hash
  

let months = months_hash ()
let days = days_hash ()

let month_to_int = Hashtbl.find months
let day_to_int = Hashtbl.find months
let int_to_month i = months_array.(i)
let int_to_day i = days_array.(i)
  
let string_to_gtm str_date =
  let open Unix in 
  Scanf.sscanf
    str_date
    "%3s, %02d %3s %04d %02d:%02d:%02d %s"
    (fun day d m y h min sec gmt ->
       {
         (gmtime(time ())) with
         tm_sec  = sec
       ; tm_min  = min
       ; tm_hour = h
       ; tm_mday = d
       ; tm_mon  = month_to_int m
       ; tm_year = y - 1900
       }
    )
  |> Unix.mktime
  |> fst (* Inference of variable data *)
  |> Unix.localtime

let gmt_to_string ?(i="+0100") gmt_date =
  let open Unix in
  Printf.sprintf
    "%3s, %02d %3s %04d %02d:%02d:%02d %s"
    (int_to_day gmt_date.tm_wday)
    gmt_date.tm_mday
    (int_to_month gmt_date.tm_mon)
    (gmt_date.tm_year + 1900)
    gmt_date.tm_hour
    gmt_date.tm_min
    gmt_date.tm_sec
    i
    
