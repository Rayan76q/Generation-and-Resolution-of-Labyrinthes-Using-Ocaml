(*Tests de cree_grid*)
let () = Printf.printf "Tests de cree_grid: \n"
let g = Grid.cree_grid 5 5 [((1,2),(1,1));  ((1,1),(0,1)) ]
let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(2)
let () = Printf.printf "---------------------------------\n"
let g = Grid.cree_grid 5 5 []
let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(2)
let () = Printf.printf "---------------------------------\n"

let g = Grid.cree_grid 5 5 [((5,5),(1,1));  ((1,1),(0,1)) ]  (* (5,5) est invalide est donc ignoré*)
let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
let () = Printf.printf "---------------------------------\n"

(*Tests de suprrime_mur*)
let () = Printf.printf "Tests de supprime_mur: \n"
let g = Grid.cree_grid 5 5 [((1,2),(1,1));  ((1,1),(0,1)) ]
let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(2)
let () = Printf.printf "---------------------------------\n"

let g = Grid.supprime_mur g (1,2) (1,3)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(2)
let () = Printf.printf "---------------------------------\n"
let g = Grid.supprime_mur g (1,1) (0,1)
let g = Grid.supprime_mur g (1,1) (0,1)
let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
let () = Printf.printf "---------------------------------\n"
let g = Grid.ajoute_mur g (1,1) (0,1)
let g = Grid.supprime_mur g (0,1) (1,1)
let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
(*let g = Grid.supprime_mur g (0,1) (2,2) plante*)


(*Tests de ajoute_mur*)
let () = Printf.printf "Tests de ajoute_mur: \n"
let g = Grid.cree_grid 5 5 [((1,2),(1,1));  ((1,1),(0,1)) ]
let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(2)
let () = Printf.printf "---------------------------------\n"
let g = Grid.ajoute_mur g (1,2) (2,2)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(2)
let () = Printf.printf "---------------------------------\n"
let g = Grid.ajoute_mur g (1,2) (1,1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(2)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
let () = Printf.printf "---------------------------------\n"
let g = Grid.supprime_mur g (1,1) (1,2)
let g = Grid.ajoute_mur g (1,1) (0,1)
let g = Grid.ajoute_mur g (1,1) (0,1)
let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
let () = Printf.printf "---------------------------------\n"
let g = Grid.supprime_mur g (0,1) (1,1)
let g = Grid.ajoute_mur g (1,1) (0,1)
let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
(*let g = Grid.ajoute_mur g (0,1) (2,2) plante*)


(*Tests de sont_egaux*)
let () = Printf.printf "Tests de sont_egaux: \n"
let g = Grid.cree_grid 5 5 [((1,2),(1,1));  ((1,1),(0,1)) ]
let g2 = Grid.cree_grid 5 5 [((1,2),(1,1));  ((1,1),(0,1))]
let () = Printf.printf "%b\n" (Grid.sont_egaux g g2)
let g2 = Grid.cree_grid 5 5 [((1,2),(1,1));  ((1,1),(0,1)) ; ((5,5) , (1,1)) ;((2,2) , (1,1)) ]
let () = Printf.printf "%b\n" (Grid.sont_egaux g g2)
let g2 = Grid.cree_grid 5 5 [((1,2),(1,1));  ((0,2),(0,1))]
let () = Printf.printf "%b\n" (Grid.sont_egaux g g2)
let g2 = Grid.cree_grid 5 5 [((1,2),(1,1))]
let () = Printf.printf "%b\n" (Grid.sont_egaux g g2)
let g2 = Grid.supprime_mur g2 (0,1) (1,1)    (*identifiants inversés*)
let () = Printf.printf "%b\n" (Grid.sont_egaux g g2)



let print_ids l = 
  Printf.printf "[ ";
  List.iter (fun (x,y) -> Printf.printf "(%d,%d) " x y) l ;
  Printf.printf "]\n"
let () = Printf.printf "Tests de get_voisins: \n"
let () = print_ids (Grid.get_voisins 5 5 (1,1))
let () = print_ids (Grid.get_voisins 5 5 (0,1))
let () = print_ids (Grid.get_voisins 5 5 (4,1))
let () = print_ids (Grid.get_voisins 5 5 (4,4))
let () = print_ids (Grid.get_voisins 5 5 (0,0))
