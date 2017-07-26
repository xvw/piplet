all: main

lib:
	ocamlbuild -I src blog.cma

main: lib
	ocamlbuild -I src generator.native

toplevel: lib
	ledit ocaml -I _build/src blog.cma

clean:
	rm -rf *.byte
	rm -rf *.native
	rm -rf _build
