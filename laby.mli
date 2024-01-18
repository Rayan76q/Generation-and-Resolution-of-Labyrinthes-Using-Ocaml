(* Implémentation de la structure Labyrinthe *)

type laby

(** Crée un labyrinthe avec tous les murs.
    @param length La longueur du labyrinthe.
    @param width La largeur du labyrinthe.
    @param depart Les coordonnées de la case de départ.
    @param arrive Les coordonnées de la case d'arrivée.
    @return Un labyrinthe initialisé. *)
val cree_laby_plein : int -> int -> int*int -> int*int -> laby

(** Crée un labyrinthe vide (sans murs).
    @param length La longueur du labyrinthe.
    @param width La largeur du labyrinthe.
    @param depart Les coordonnées de la case de départ.
    @param arrive Les coordonnées de la case d'arrivée.
    @return Un labyrinthe initialisé sans murs. *)
val cree_laby_vide : int -> int -> int*int -> int*int -> laby

(** Crée un labyrinthe avec des murs définis par la grille [grid].
    @param length La longueur du labyrinthe.
    @param width La largeur du labyrinthe.
    @param depart Les coordonnées de la case de départ.
    @param arrive Les coordonnées de la case d'arrivée.
    @param grid La grille définissant les murs du labyrinthe.
    @return Un labyrinthe initialisé avec les murs définis par la grille. *)
val cree_laby : int -> int -> int*int -> int*int -> Grid.grid -> laby

(** Modifie l'état de visite de la case située aux coordonnées [coords] dans le labyrinthe [laby].
    @param laby Le labyrinthe à modifier.
    @param coords Les coordonnées de la case à visiter.
    @return Le labyrinthe modifié. *)
val set_visite_case : laby -> int*int -> laby

(** Déplace la position actuelle du joueur dans le labyrinthe selon la direction [dir].
    @param laby Le labyrinthe dans lequel se déplacer.
    @param dir La direction dans laquelle se déplacer.
    @return Le labyrinthe modifié après le déplacement. *)
val se_deplacer : laby -> Grid.directions -> laby

(** Indique si le labyrinthe est résolu, c'est-à-dire si le joueur est arrivé à la case d'arrivée.
    @param laby Le labyrinthe à vérifier.
    @return true si le labyrinthe est résolu, false sinon. *)
val est_resolu : laby -> bool

(** Affiche le labyrinthe.
    @param laby Le labyrinthe à afficher. *)
val print_laby : laby -> unit

(** Génère un labyrinthe aléatoire par la méthode de fusion.
    @param length La longueur du labyrinthe.
    @param width La largeur du labyrinthe.
    @param depart Les coordonnées de la case de départ.
    @param arrive Les coordonnées de la case d'arrivée.
    @return Un labyrinthe généré aléatoirement. *)
val generate_random_laby_fusion : int -> int -> int*int -> int*int -> laby

(** Génère un labyrinthe aléatoire par la méthode d'exploration.
    @param length La longueur du labyrinthe.
    @param width La largeur du labyrinthe.
    @param depart Les coordonnées de la case de départ.
    @param arrive Les coordonnées de la case d'arrivée.
    @return Un labyrinthe généré aléatoirement. *)
val generate_random_laby_exploration : int -> int -> int*int -> int*int -> laby

(** Résout le labyrinthe [laby] en renvoyant un couple composé du labyrinthe résolu et du chemin suivi (cf. TP4) .
    N.B. cet algo donne plusieurs chemins si le labyrinthe en offre, 
    on n'obtient donc pas la bonne complexite dans ces cas (cf. fin du mli).
    @param laby Le labyrinthe à résoudre.
    @return Un couple composé du labyrinthe résolu et du chemin suivi. *)
val resolve_with_path : laby -> laby * (int*int) list

(** Construit un labyrinthe à partir d'une chaîne de caractères représentant sa structure.
    @param filename Le nom du fichier contenant la structure du labyrinthe.
    @return Le labyrinthe construit. *)
val construct_laby : string -> laby

(** Algorithme de résolution du labyrinthe en suivant la main droit à partir du départ.
    @param laby Le labyrinthe à résoudre.
    @return Le labyrinthe résolu. *)
val algo_main_droite : laby -> laby


(** Algorithme qui donne une liste de paires de toutes les configurations possibles pour start et end sur le rectangle
   en enlevant les doublons.
    @param m la première dimension du rectangle
    @param n la deuxième dimension du rectangle
    @return la liste *)
val genere_tout_points : int -> int -> ((int*int)*(int*int)) list 

(** Algo qui calcul la complexite du labyrinthe
    @param laby labyrinthe
    @return la complexite du labyrinthe*)
val complexite_du_laby : laby -> float

(** @return Les coordonnées de la case de départ du labyrinthe [laby].
    @param laby Le labyrinthe dont on veut obtenir les coordonnées de départ.
    @return Les coordonnées de la case de départ. *)
val get_depart : laby -> int*int

(** @return Les coordonnées de la case d'arrivée du labyrinthe [laby].
    @param laby Le labyrinthe dont on veut obtenir les coordonnées d'arrivée.
    @return Les coordonnées de la case d'arrivée. *)
val get_arrive : laby -> int*int

(** @return Les coordonnées de la position actuelle dans le labyrinthe [laby].
    @param laby Le labyrinthe dont on veut obtenir les coordonnées de la position actuelle.
    @return Les coordonnées de la position actuelle. *)
val get_position : laby -> int*int

(** @return La grille représentant les murs du labyrinthe [laby].
    @param laby Le labyrinthe dont on veut obtenir la grille.
    @return La grille représentant les murs du labyrinthe. *)
val get_grille : laby -> Grid.grid

(** Modifie les coordonnées de la case de départ du labyrinthe [laby] avec la valeur [coords].
    @param laby Le labyrinthe dont on veut modifier les coordonnées de départ.
    @param coords Les nouvelles coordonnées de la case de départ.
    @return Le labyrinthe modifié. *)
val set_depart : laby -> int*int -> laby

(** Modifie les coordonnées de la case d'arrivée du labyrinthe [laby] avec la valeur [coords].
    @param laby Le labyrinthe dont on veut modifier les coordonnées d'arrivée.
    @param coords Les nouvelles coordonnées de la case d'arrivée.
    @return Le labyrinthe modifié. *)
val set_arrive : laby -> int*int -> laby
