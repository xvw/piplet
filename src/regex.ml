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

type pattern = string
type source = string
type replacer = string

let split pattern = Str.split @@ Str.regexp pattern
                  
let replace ?(all=true) pattern =
  let f = if all then Str.global_replace else Str.replace_first in
  f @@ Str.regexp pattern

let purge pattern =
  replace ~all:true pattern ""

let minimize = purge "\n"

let uniq_separator =
  Str.quote Util.uniq_separator
