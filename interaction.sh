#!/bin/bash

ocamlopt -c Grid/node.mli
ocamlopt -c Grid/grid.mli
ocamlopt -c Grid/laby.mli
ocamlopt -c read_laby.mli

ocamlopt -c Grid/node.ml
ocamlopt -c Grid/grid.ml
ocamlopt -c Grid/laby.ml
ocamlopt -c read_laby.ml
ocamlopt -c maze.ml

ocamlopt -o interaction Grid/node.cmx Grid/grid.cmx Grid/laby.cmx read_laby.cmx maze.cmx
./interaction