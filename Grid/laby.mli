type laby

val cree_laby_plein : int -> int -> int*int -> int*int -> laby
val cree_laby_vide : int -> int -> int*int -> int*int -> laby

val set_visite_case : laby->int*int->laby

val se_deplacer : laby -> Grid.directions -> laby

val est_resolu : laby -> bool

val print_laby : laby -> unit

val delete_wall :laby->(int*int)*(int*int)->laby

val generate_random_laby_fusion : int->int->int*int->int*int->laby

val generate_random_laby_exploration : int->int->int*int->int*int->laby

val resolve_cours :laby->laby

val pledge_algo:laby->laby
(*Getters*)
val get_depart : laby -> int*int
val get_arrive : laby -> int*int
val get_position : laby -> int*int
val get_grille : laby -> Grid.grid

(*Setters*)
val set_depart : laby -> int*int -> laby
val set_arrive : laby -> int*int -> laby
