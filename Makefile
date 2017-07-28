all: generator css_generator

lib:
	ocamlbuild -I src blog.cma

%: src/%.ml
	ocamlbuild -I src $(@).native

toplevel: lib
	ledit ocaml -I _build/src blog.cma

clean:
	rm -rf *.byte
	rm -rf *.native
	rm -rf _build
	rm -rf .cache
