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

(** The main generator for process CSS *)

let usage = "./css_generator.native [-o output] config.el"
let output = ref Util.uniq_separator
let args  = ref []
let callback_function x = args := x :: (!args)


let () =
  let _ =
    Arg.parse
      ["-o", Arg.Set_string output, "The target of the generation"]
      callback_function
      usage
  in
  let outp = Util.uniq_to_option !output in
  match !args with
  | [] -> Util.print Color.red  "No configuration file"
  | [css_file] ->
    if File.exists css_file then begin
      let () = Cache.init () in
      let res = Css.create ~interactive:true css_file in
      Cli.default_finish outp res
    end else Util.print Color.red ("The file: " ^ css_file ^ ", does not exists")
  |  _ -> Util.print Color.red "You can send only one configuration file !"
