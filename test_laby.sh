#!/bin/bash
ocamlopt -c node.mli;
ocamlopt -c grid.mli;
ocamlopt -c laby.mli;
ocamlopt -o laby_test node.ml grid.ml laby.ml laby_test.ml;
./laby_test;