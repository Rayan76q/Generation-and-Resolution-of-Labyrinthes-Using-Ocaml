#!/bin/bash
ocamlopt -c node.mli;
ocamlopt -o test_node node.ml node_test.ml;
./test_node;