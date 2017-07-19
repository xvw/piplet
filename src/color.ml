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

type color = int
type clean_color = string
type text = string
type colorized_text = string
  
let reset = "\027[0m"
  
let black   = 0
let red     = 1 
let green   = 2 
let yellow  = 3
let blue    = 4
let magenta = 5
let cyan    = 6
let white   = 7

let colorize ?fg ?bg =
  let f = match fg with None -> 7 | Some x -> x in
  let b = match bg with None -> 0 | Some x -> x in
  Printf.sprintf "\027[3%dm\027[4%dm%s\027[0m" f b

let c = colorize
