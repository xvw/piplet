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


type t =
  | Sec of float
  | Min of float
  | Hour of float
  | Day of float
  | Week of float

let unwrap = function
  | Sec x  -> ` Sec, x
  | Min x  -> `Min, x
  | Hour x -> `Hour, x
  | Day x  -> `Day, x
  | Week x -> `Week, x

let to_sec = function
  | Sec x  -> Sec x
  | Min x  -> Sec (x *. 60.)
  | Hour x -> Sec (x *. 60. *. 60.)
  | Day x  -> Sec (x *. 60. *. 60. *. 24.)
  | Week x -> Sec (x *. 60. *. 60. *. 24. *. 7.)


let second x = Sec x
let minut x = Min x
let hour x = Hour x
let day x = Day x
let week x = Week x

let fun_of = function
  | `Sec -> second
  | `Min -> minut
  | `Hour -> hour
  | `Day -> day
  | `Week -> week

let map f value =
  let (kind, v) = unwrap value in
  let g = fun_of kind in
  g (f v)

let of_tm value =
  value
  |> Unix.mktime
  |> fst
  |> second

let now () =
  Unix.time ()
  |> second
  
let to_tm value =
  value
  |> to_sec
  |> unwrap
  |> snd
  |> Unix.localtime


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





