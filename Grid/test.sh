#!/bin/bash
ocamlopt -c node.mli;
ocamlopt -c grid.mli;
ocamlopt -o test node.ml grid.ml test.ml;
./test;