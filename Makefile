main:
	ocamlbuild -I src main.byte

clean:
	rm -rf *.byte
	rm -rf *.native
	rm -rf _build
