let port =
  if Array.length (Sys.argv) > 1
  then int_of_string Sys.argv.(1)
  else 4000

let make_http_header =
  Printf.sprintf
    "HTTP/1.1 %s\nContent-type: %s\n\n"

let listener =
  Unix.(socket PF_INET SOCK_STREAM 0)

let send sock str =
  let length = String.length str in
  let _ = Unix.send sock str 0 length []
  in ()

let rec server_loop () =
  let (client, _) = Unix.accept listener in
  let _ = send client (make_http_header "200/OK" "text/html") in
  let _ = send client "<h2>Lol</h2>" in
  let _ = Unix.close client in
  server_loop ()

let _ =
  let _ = Printf.printf "Server started on %d\n" port in
  let _ =
    Unix.bind
      listener
      (Unix.ADDR_INET
         (Unix.inet_addr_of_string "127.0.0.1", port)
      )
  in
  let _ = Unix.listen listener 8 in server_loop ()
