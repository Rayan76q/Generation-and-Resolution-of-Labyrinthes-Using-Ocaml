#!/bin/bash
ocamlopt -c node.mli;
ocamlopt -c grid.mli;
ocamlopt -o grid_test node.ml grid.ml grid_test.ml;
./grid_test;