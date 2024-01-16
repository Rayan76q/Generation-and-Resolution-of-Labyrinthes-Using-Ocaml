(* Implémentation du type Noeud, Brique de base des graphes *)

type node

(** Obtient l'identifiant du nœud [node].
    @param node Le nœud dont on veut obtenir l'identifiant.
    @return Une paire d'entiers représentant l'identifiant du nœud. *)
val get_id : node -> int * int

(** Obtient la liste des connexions du nœud [node].
    @param node Le nœud dont on veut obtenir la liste des connexions.
    @return Une liste de nœuds représentant les connexions du nœud. *)
val get_connexions : node -> node list

(** Indique si le nœud [node] a été visité.
    @param node Le nœud dont on veut vérifier l'état de visite.
    @return true si le nœud a été visité, false sinon. *)
val est_visite : node -> bool

(** Modifie l'identifiant du nœud [node] avec la valeur [id].
    @param node Le nœud dont on veut modifier l'identifiant.
    @param id La nouvelle paire d'entiers représentant l'identifiant.
    @return Le nœud modifié. *)
val set_id : node -> int * int -> node

(** Modifie la liste des connexions du nœud [node] avec la liste [connexions].
    @param node Le nœud dont on veut modifier les connexions.
    @param connexions La nouvelle liste de nœuds représentant les connexions.
    @return Le nœud modifié. *)
val set_connexions : node -> node list -> node

(** Modifie l'état de visite du nœud [node] avec la valeur [visited].
    @param node Le nœud dont on veut modifier l'état de visite.
    @param visited La nouvelle valeur de l'état de visite.
    @return Le nœud modifié. *)
val set_visite : node -> bool -> node

(** Indique si les nœuds [node1] et [node2] sont connectés, dans le sens node1 -> node2.
    @param node1 Le premier nœud.
    @param node2 Le deuxième nœud.
    @return true si les nœuds sont connectés, false sinon. *)
val sont_connecte : node -> node -> bool

(** Indique si les identifiants [id1] et [id2] sont adjacents.
    @param id1 Le premier identifiant.
    @param id2 Le deuxième identifiant.
    @return true si les identifiants sont adjacents, false sinon. *)
val sont_adjacent : int * int -> int * int -> bool

(** Ajoute la connexion entre les nœuds [node1] et [node2] (la connexion est ajouté au deux noeuds)
    et retourne le couple de nœuds modifié.
    @param node1 Le premier nœud.
    @param node2 Le deuxième nœud.
    @return Un couple de nœuds modifié. *)
val ajoute_connexion : node -> node -> (node * node)

(** Supprime la connexion entre les nœuds [node1] et [node2] (la supression se fait sur les deux noeuds)
    et retourne le couple de nœuds modifié.
    @param node1 Le premier nœud.
    @param node2 Le deuxième nœud.
    @return Un couple de nœuds modifié. *)
val supprime_connexion : node -> node -> (node * node)

(** Crée un nouveau nœud avec l'identifiant [id] et la liste de connexions [connexions].
    @param id La paire d'entiers représentant l'identifiant du nœud.
    @param connexions La liste de nœuds représentant les connexions du nœud.
    @return Le nouveau nœud créé. *)
val cree_noeud : int * int -> node list -> node

(** Affiche les informations du nœud [node].
    @param node Le nœud à afficher. *)
val print_noeud : node -> unit
