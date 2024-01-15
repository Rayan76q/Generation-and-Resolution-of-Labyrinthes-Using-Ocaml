type grille=Grid.grid
type node = Node.node
type laby= Laby.laby

let ()=
  let l = Laby.cree_laby_plein 10 10 (0,0) (5,5) in
  (* let l2 = {Laby.depart = l.depart ; Laby.arrive = l.arrive ; position = l.position ; grille = (Grid.supprime_mur l.grille (0,0) (0,1)) } in *)
  (* let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.supprime_mur l.grille (0,2) (0,1)) } 
  let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.supprime_mur l.grille (0,0) (1,0)) } *)
  Laby.print_laby l
;;


let ()=
  let l = Laby.cree_laby_vide 10 8 (0,0) (5,5) in
  (*let l = { depart= Laby.get_depart(l) ;arrive = Laby.get_arrive(l) ;position= Laby.get_position;grille =(Grid.ajoute_mur Laby.get_grille(l) (0,0) (1,0)) } in
  let l = {l.depart ; l.arrive ; l.position ; (Grid.ajoute_mur l.grille (5,5) (6,5)) } in *)
  let l=Laby.set_visite_case l (1,1) in
  Laby.print_laby l;
  Laby.print_laby (Laby.set_visite_case l (0,0));
  Laby.print_laby (Laby.set_visite_case l (1,0))

;;

let()=
  let random_laby = Laby.generate_random_laby_fusion 5 7 (0,6) (0,0) in
  Laby.print_laby random_laby ;
  Laby.print_laby (Laby.algo_main_droite random_laby)
;;

let ()=Laby.print_laby (Laby.resolve_cours(Laby.generate_random_laby_exploration 5 4 (0,0) (3,1))) 
;;

let ()= Laby.print_laby (Laby.resolve_cours (Laby.generate_random_laby_exploration 50 50 (5,18) (31,42)))
;;

let ()= Laby.print_laby (Laby.resolve_cours (Laby.generate_random_laby_exploration 7 8 (4,4) (6,7)))
;;

let ()= Laby.print_laby (Laby.resolve_cours (Laby.generate_random_laby_exploration 6 8 (3,4) (0,7)))
;;

let ()= Laby.print_laby (Laby.algo_main_droite (Laby.generate_random_laby_exploration 6 7 (3,4) (5,0)))