(* Implémentation de la structure Grille *)

type node = Node.node
type grid

type directions = Up | Down | Left | Right

(** Retourne la direction[dir] sous forme de tuple
    @param dir La direction pour laquelle obtenir les coordonnées.
    @return Une paire d'entiers représentant les coordonnées correspondantes. *)
val get_dir : directions -> int * int

(** Vérifie si les coordonnées [coords] sont correctes pour une grille de dimensions [length] x [width].
    @param coords Les coordonnées à vérifier.
    @param length La longueur de la grille.
    @param width La largeur de la grille.
    @return true si les coordonnées sont correctes, false sinon. *)
val coords_correctes : int * int -> int -> int -> bool

(** Crée une nouvelle grille de dimensions [length] x [width] avec les murs à supprimer définis par la liste [edges].
    @param length La longueur de la grille.
    @param width La largeur de la grille.
    @param edges La liste des connexions représentés par des paires de coordonnées.
    @return La nouvelle grille créée. *)
val cree_grid : int -> int -> ((int * int) * (int * int)) list -> grid

(** Ajoute un mur entre les coordonnées [coords1] et [coords2] dans la grille [grid].
    @param grid La grille à modifier.
    @param coords1 Les coordonnées du premier nœud.
    @param coords2 Les coordonnées du deuxième nœud.
    @return La grille modifiée. *)
val ajoute_mur : grid -> int*int -> int*int -> grid

(** Supprime le mur entre les coordonnées [coords1] et [coords2] dans la grille [grid].
    @param grid La grille à modifier.
    @param coords1 Les coordonnées du premier nœud.
    @param coords2 Les coordonnées du deuxième nœud.
    @return La grille modifiée. *)
val supprime_mur : grid -> int*int -> int*int -> grid

(** Retourne la liste des coordonnées des voisins du nœud situé aux coordonnées [coords] dans une grille de dimensions [length] x [width].
    @param length La longueur de la grille.
    @param width La largeur de la grille.
    @param coords Les coordonnées du nœud pour lequel obtenir les voisins.
    @return La liste des coordonnées des voisins. *)
val get_voisins : int -> int -> int*int -> (int*int) list

(** Indique si les grilles [grid1] et [grid2] sont égales.
    @param grid1 La première grille.
    @param grid2 La deuxième grille.
    @return true si les grilles sont égales, false sinon. *)
val sont_egaux : grid -> grid -> bool

(** Retourne la longueur de la grille [grid].
    @param grid La grille dont on veut obtenir la longueur.
    @return La longueur de la grille. *)
val get_length : grid -> int

(** Retourne la largeur de la grille [grid].
    @param grid La grille dont on veut obtenir la largeur.
    @return La largeur de la grille. *)
val get_width : grid -> int

(** Retourne la matrice de nœuds de la grille [grid].
    @param grid La grille dont on veut obtenir la matrice de nœuds.
    @return La matrice de nœuds de la grille. *)
val get_nodes : grid -> Node.node array array

(** Retourne la liste des murs de la grille [grid].
    @param grid La grille dont on veut obtenir la liste des murs.
    @return La liste des murs de la grille. *)
val get_edges : grid -> ((int * int) * (int * int)) list

(** Modifie la largeur de la grille [grid] avec la valeur [width].
    @param grid La grille dont on veut modifier la largeur.
    @param width La nouvelle largeur.
    @return La grille modifiée. *)
val set_width : grid -> int -> grid

(** Modifie la longueur de la grille [grid] avec la valeur [length].
    @param grid La grille dont on veut modifier la longueur.
    @param length La nouvelle longueur.
    @return La grille modifiée. *)
val set_length : grid -> int -> grid
