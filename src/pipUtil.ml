let md5 s =
  Digest.(to_hex (string s))
