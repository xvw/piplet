(*
 * My personnal blog engine ...
 *
 * Copyright (C) 2017  Xavier Van de Woestyne <xaviervdw@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *)


type t = float

let of_tm value =
  value
  |> Unix.mktime
  |> fst

let now = Unix.time
let to_tm = Unix.localtime

let to_rfc822 value =
  let t = to_tm value in
  let day =
    [| "Sun"; "Mon"; "Tue"; "Wed"; "Thu"; "Fri"; "Sat"|].(t.Unix.tm_wday)
  and month =
    [|
      "Jan"; "Feb"; "Mar"; "Apr";
      "May"; "Jun"; "Jul"; "Aug";
      "Sep"; "Oct"; "Nov"; "Dec";
    |].(t.Unix.tm_mon)
  in
  Printf.sprintf
    "%s, %02d %s %04d %02d:%02d:%02d UT"
    (day)
    (t.Unix.tm_mday)
    (month)
    (t.Unix.tm_year + 1900)
    (t.Unix.tm_hour)
    (t.Unix.tm_min)
    (t.Unix.tm_sec)

let of_blog_format str_representation =
  Scanf.sscanf
    str_representation
    "%02d/%02d/%04d"
    (fun d m y ->
       {
         (to_tm (now ())) with
         Unix.tm_sec = 0
       ; Unix.tm_min = 0
       ; Unix.tm_hour = 0
       ; Unix.tm_mday = d
       ; Unix.tm_mon = (m -1)
       ; Unix.tm_year = (y - 1900)
       }
       |> of_tm
    )
    
