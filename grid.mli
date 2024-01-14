type grid
type directions = Up | Down | Left | Right


val get_dir : directions -> int * int

val coords_correctes : int * int -> int -> int -> bool

val cree_grid : int -> int -> ((int * int) * (int * int)) list -> grid
val ajoute_mur : grid -> int*int -> int*int -> grid
val supprime_mur : grid -> int*int -> int*int -> grid

val get_voisins : int -> int -> int*int -> (int*int) list

val sont_egaux : grid -> grid -> bool

val get_length : grid -> int
val get_width : grid -> int
val get_nodes : grid -> Node.node array array
val get_edges : grid -> ((int * int) * (int * int)) list 

val set_width : grid -> int -> grid
val set_length : grid -> int -> grid