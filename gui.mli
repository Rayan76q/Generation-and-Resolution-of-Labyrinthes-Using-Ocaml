(** Génère une représentation HTML d'un labyrinthe avec un chemin spécifié et la taille d'une case en px.
    @param laby Le labyrinthe à représenter.
    @param path Le chemin à mettre en évidence dans la représentation.
    @param size la largeur d'une case en px
    @return Une chaîne de caractères représentant un fichier HTML permettant d'afficher le Laby. *)
val generate_html : Laby.laby -> (int * int) list -> int -> string