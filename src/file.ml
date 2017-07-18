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


type name = string
type content = string
type line = string
type chmod = int

let read filename =
  let channel = open_in filename in
  let length = in_channel_length channel in
  let result = Bytes.create length in
  let () = really_input channel result 0 length in
  let () = close_in channel in
  Bytes.to_string result

let read_lines filename =
  filename
  |> read
  |> Regex.split "\n"

let write filename content =
  let channel = open_out filename in
  let () = output_string channel content in
  close_out channel

let append ?(chmod=0o664) filename content =
  let channel =
    open_out_gen
      [Open_rdonly; Open_append; Open_creat; Open_text]
      chmod
      filename
  in
  let () = output_string channel content in
  close_out channel

let remove = Sys.remove

let basename filename =
  filename
  |> Filename.basename
  |> Filename.chop_extension