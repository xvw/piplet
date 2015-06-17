#!/bin/sh

# Collection of little tools for oasis Management
if [ "$1" = "clean" ];
then
    echo "Clean emacs files"
    rm -rf *~
    rm -rf */*~
    rm -rf \#*
    rm -rf */\#*
    make clean
    make distclean

elif [ "$1" = "setup-oasis" ];
then 
     echo "Setup Oasis"
     oasis setup -setup-update dynamic
elif [ "$1" = "run" ];
then
    echo "Run OCaml with piplet"
    make
    ocaml -I _build/src unix.cma str.cma Piplet.cma
    echo "Bye"

else
    ocamlc -I _build/src unix.cma str.cma Piplet.cma $*
fi
