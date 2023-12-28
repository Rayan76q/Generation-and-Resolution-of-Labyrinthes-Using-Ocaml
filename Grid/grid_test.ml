
let g = Grid.cree_grid 5 5 [((1,2),(1,1));  ((1,1),(0,1)) ]

let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(2)
(*let g = ajoute_mur g (1,1) (0,4)    plante*) 
let g = Grid.supprime_mur g (1,1) (0,1)
let g = Grid.supprime_mur g (1,1) (0,1)
let g = Grid.supprime_mur g (1,1) (0,1)

let () = Printf.printf "Apres suppression du mur: \n"
let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
let () = Node.print_noeud (Grid.get_nodes (g)).(1).(2)


let g2 = Grid.cree_grid 5 5 [((1,2),(1,1));  ((1,1),(0,1)) ; ((5,5),(4,3))]
let () = Printf.printf "%b\n" (Grid.sont_egaux g g2)