#!/bin/bash
ocamlopt -c node.mli
ocamlopt -o test_grid node.ml grid.ml
./test_grid