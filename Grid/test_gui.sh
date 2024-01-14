#!/bin/bash
ocamlopt -c node.mli;
ocamlopt -c grid.mli;
ocamlopt -c laby.mli;
ocamlopt -o gui_test node.ml grid.ml laby.ml gui.ml;
./gui_test;