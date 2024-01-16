type grille=Grid.grid
type node = Node.node
type laby= Laby.laby

let ()=
  let l = Laby.cree_laby_plein 10 10 (0,0) (5,5) in
  Printf.printf "******************************** \n";
  Printf.printf "* test cree_laby_plein (10,10) * \n";
  Printf.printf "******************************** \n";
  Laby.print_laby l
;;

let ()=
  let l = Laby.cree_laby_plein 8 5 (0,0) (6,4) in
  Printf.printf "******************************** \n";
  Printf.printf "*  test cree_laby_plein (8,5)  * \n";
  Printf.printf "******************************** \n";
  Laby.print_laby l
;;


let ()=
  let l = Laby.cree_laby_vide 10 8 (0,0) (7,7) in
  Printf.printf "******************************** \n";
  Printf.printf "*  test cree_laby_vide (10,8)  * \n";
  Printf.printf "******************************** \n";
  Laby.print_laby l;
  let l=Laby.set_visite_case l (1,1) in
  Printf.printf "**************************************** \n" ;
  Printf.printf "*test set_visite_case (10,8) case (1,1)* \n" ;
  Printf.printf "**************************************** \n" ;
  Laby.print_laby l;
  Printf.printf "**************************************** \n" ;
  Printf.printf "*test set_visite_case (10,8) case (0,0)* \n" ;
  Printf.printf "**************************************** \n" ;
  Laby.print_laby (Laby.set_visite_case l (0,0));
  Printf.printf "**************************************** \n" ;
  Printf.printf "*test set_visite_case (10,8) case (1,0)* \n" ;
  Printf.printf "**************************************** \n" ;
  Laby.print_laby (Laby.set_visite_case l (1,0))

;;

let()=
  Printf.printf "******************************************** \n" ;
  Printf.printf "* test generate_random_laby_fusion dim 5 7 * \n" ;
  Printf.printf "******************************************** \n" ;
  let random_laby = Laby.generate_random_laby_fusion 5 7 (0,6) (0,0) in
  Laby.print_laby random_laby ;
  Printf.printf "********************************************** \n" ;
  Printf.printf "* test resolution algo_main_droite same laby * \n" ;
  Printf.printf "********************************************** \n" ;
  Laby.print_laby (Laby.algo_main_droite random_laby)
;;

let ()=
  Printf.printf "************************************************************** \n" ;
  Printf.printf "* resolution algo_resolve_with_path laby_exploration dim 5 4 * \n" ;
  Printf.printf "************************************************************** \n" ;
  Laby.print_laby (fst (Laby.resolve_with_path(Laby.generate_random_laby_exploration 5 4 (0,0) (3,1)) ) ) 
;;

let ()= 
  Printf.printf "*********************************************************** \n" ;
  Printf.printf "* resolution algo_resolve_with_path laby_fusion dim 50 50 * \n" ;
  Printf.printf "*********************************************************** \n" ;
  Laby.print_laby (fst (Laby.resolve_with_path (Laby.generate_random_laby_fusion 50 50 (5,18) (31,42))))
;;

let ()=
  Printf.printf "********************************************************** \n" ;
  Printf.printf "* resolution algo_resolve_with_path laby_fusion dim 7 8  * \n" ;
  Printf.printf "********************************************************** \n" ;
  Laby.print_laby (fst (Laby.resolve_with_path (Laby.generate_random_laby_fusion 7 8 (4,4) (6,7))))
;;

let ()= 
  Printf.printf "******************************************************** \n" ;
  Printf.printf "* resolution algo_main_droite laby_exploration dim 6 8 * \n" ;
  Printf.printf "******************************************************** \n" ;
  Laby.print_laby (Laby.algo_main_droite (Laby.generate_random_laby_exploration 6 8 (3,4) (0,7)))
;;

let ()= 
  Printf.printf "********************************************************* \n" ;
  Printf.printf "* resolution algo_main_droite laby_exploration dim 12 8 * \n" ;
  Printf.printf "********************************************************* \n" ;
  Laby.print_laby ( Laby.algo_main_droite (Laby.generate_random_laby_exploration 12 8 (11,0) (0,7)))
;;

let ()= 
  Printf.printf "********************************************************** \n" ;
  Printf.printf "* resolution algo_main_droite laby_exploration dim 50 50 * \n" ;
  Printf.printf "********************************************************** \n" ;
  Laby.print_laby ( Laby.algo_main_droite (Laby.generate_random_laby_exploration 50 50 (49,49) (0,0)))
;;

let()=
  Printf.printf "********************************************************* \n" ;
  Printf.printf "* resolution algo_main_droite laby_exploration dim 7 46 * \n" ;
  Printf.printf "********************************************************* \n" ;
  Laby.print_laby (Laby.algo_main_droite (Laby.generate_random_laby_exploration 7 46 (0,45) (6,0)))
;;

let()=
  Printf.printf "labys pour tester read \n";
;;

let()=
  Printf.printf "testing read_laby \n";
  let fon_fake str =
    try 
      Laby.print_laby (Laby.construct_laby str)
    with
    | Failure msg -> Printf.printf "fake: %s\n" msg;
  in List.iter fon_fake ["test/maze_11x6.laby";"test/maze_4x8.laby";"test/maze_4x9.laby";"test/maze_3x2.laby";"test/maze_6x12.laby";"test/fake1.laby";"test/fake2.laby";"test/fake3.laby";"test/fake4.laby";"test/fake5.laby";"test/fake6.laby";"test/fake7.laby";"test/fake8.laby";"test/fake9.laby";"test/fake10.laby"]