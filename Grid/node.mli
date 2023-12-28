(*Implémentation du type Noeud , Brique de base des graphes*)

type node 


val get_id : node -> int*int
val get_connexions : node -> node list

val set_id : node -> int*int -> node
val set_connexions : node -> node list -> node

val sont_connecte : node -> node -> bool
val sont_adjacent : int*int -> int*int -> bool

val ajoute_connexion : node->node->(node*node)
val supprime_connexion : node -> int*int -> node

val cree_noeud : int*int -> node list -> node

val print_noeud : node -> unit

