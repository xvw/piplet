main:
	ocamlbuild -I src main.byte
	cp main.byte example/build

top: main
	ocaml -I _build/src unix.cma str.cma util.cmo regex.cmo datetime.cmo contributor.cmo file.cmo sexp.cmo color.cmo publication.cmo

clean:
	rm -rf *.byte
	rm -rf *.native
	rm -rf _build
