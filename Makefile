main:
	ocamlbuild -I src main.byte

top: main
	ocaml -I _build/src unix.cma str.cma util.cmo regex.cmo  datetime.cmo file.cmo sexp.cmo color.cmo

clean:
	rm -rf *.byte
	rm -rf *.native
	rm -rf _build
