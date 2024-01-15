#!/bin/bash
ocamlopt -c node.mli;
ocamlopt -c grid.mli;
ocamlopt -c laby.mli;
ocamlopt -c read_laby.mli;


ocamlopt -o read node.ml grid.ml laby.ml read_laby.ml;
./read;