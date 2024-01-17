# Projet Labyrinthe en OCaml


### Binôme
- Membre 1: Antoine El-Kassis
- Membre 2: Lalaoui Rayan

## Répartition du Travail
Pour la repartition des taches , on a essayé de faire en sorte qu'elle soit la plus equitable possible sans que chacun ait a implemente du code pour chaque partie du projet (generation , resolution, affichage) ce aui revienderait a faire le projet deux fois. On s'est donc repartie les taches comme suit:
- Rayan: 
    - Implementation de la structure de base
    - Generation
    - affichage avance
- Antoine: 
    - Resolution 
    - Lecture de Labyrinthe 
    - affichage simple

Les taches "mineurs" tels que : l'ecriture de tests et les eventuelles debugging ont ete menees par l'un ou l'autre suivant les besoins du projet et des disponibilite de chacun. Cela nous a permit de developpe une meilleure comprehension du code de l'autre tout au long du projet.

Cette repartition est aussi tres utile car elle limite les conflits de versions git etant donne que l'on a travaille sur des fichiers differents pour la grande partie du projet. Vers la fin ou il a fallut mieux nous coordonner dans les modifications apporte que ce soit a maze.ml ou aux differents fichiers pour rectifications avant le rendu finale.

## Structure de Données


### Modèle du Labyrinthe
on a etait tentee de penser au debut que la meilleure implementation serait celle de graphe "classique" i.e des noeuds representees par un identifiant et leurs listes de connexions, puis un type graphe qui serait une liste de noeuds. L'inconvenient majeur etait que l'on ne tire pas profit du faite que les cases d'un labyrinthe ont une position fixe et donc on pourrait acceder a n'importe quelle case a partir du type graphe sans avoir a parcourir l'integralite des connexions (on ajouterai un facteur lineaire a la complexite). Ceci nous a pousse a ajuster cette idee d'implementation. Dans un soucis de modularite nous avons 3 types qui permettent de representer nos labys.

### Type Ocaml

#### Node
- TYPE:
    ```ocaml
    type node =  {id : int*int ; connexions : node list ; visite : bool}
    ```
    - `id` : Une paire représentant l'identifiant unique du nœud (position dans la grille).
    - `connexions` : Une liste de nœuds avec lesquels il est connectés.
    - `visite` : Un booléen indiquant si le nœud a été visité ou pas.

- Fonctions Associees:
    ```ocaml
    (** Indique si le nœud [node] a été visité.
        @param node Le nœud dont on veut vérifier l'état de visite.
        @return true si le nœud a été visité, false sinon. *)
    val est_visite : node -> bool
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
    ```
    la documentation se suffit a elle meme pour l'explication des fonctions.La majorite vont servir d'interface avec les types Grille et Laby.<br>
    N'oublions pas les getters et les setters qui serviront dans la suite du projet

#### Grille
- TYPE:
    ```ocaml
    type grid = {length: int; width:int;nodes : node array array ; edges : ((int * int) * (int * int)) list}
    ```
    - `length` : La longueur de la grille.
    - `width` : La largeur de la grille.
    - `nodes` : Un tableau bidimensionnel de nœuds représentant la disposition des nœuds dans la grille.
    - `edges` : Une liste de paires de coordonnées représentant les arêtes entre les nœuds adjacents.
- Fonctions associees:
    ```ocaml
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
    ```
    La documentation explique plus au moins les fonctions implementees.<br>
    Quelques points a remarquer:
    - Pour cree_grid, la fonction ignore les arretes qui ne sont pas correctes. (par exemple des connexions entre deux noeuds qui ne sont pas des voisins en soit) <br>
    - Pour ajoute_mur et supprime_mur, ajouter un mur entre deux noeuds revient a supprime une connexion entre ceux-ci et supprime_mur ajoute un connexion entre ces deux noeuds.
#### Laby
- TYPE:
    ```ocaml
    type laby = {depart : int*int ; arrive : int*int ; position : int*int ; grille : grid}
    ```
    - `depart` : Les coordonnées du point de départ dans le labyrinthe.
    - `arrive` : Les coordonnées du point d'arrivée dans le labyrinthe.
    - `position` : Les coordonnées actuelles de la position dans le labyrinthe.
    - `grille` : La grille représentant la structure du labyrinthe.
- Fonctions associees:
    ```ocaml 
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
    ```
    - cree_laby_plein : cree un laby ou chaque noeud a aucune connexion. Le resultat est un laby rempli de murs. Utile pour les algos de generations parce qu'on aura pas besoin de verifier la connexite a chaque iteration.
    - cree_laby_vide : cree un laby ou chaque noeud est connecte a tous ses voisins. Le resultat est un laby sans aucun mur (interne).
    - cree_laby : prends en plus comme parametre une grille est cree un laby en fonction de la grille. Ce constructeur est tres utile pour la construction a partir de la lecture de laby
    - set_visite_case : rends un laby ou la valeur de visite du noeud de parametre la paire est changee.
    
    On passe aux algos plus consistents: 
    - print_laby: utilise deux fonctions recursives locales:
        - une qui print la premiere et la derniere ligne (les bords)
        - une autre qui print les ligne des noeuds (lignes de la forme |  |), qui sauvegarde l'affichage des connexions verticales dans un string est qui print le string une fois la ligne finit, puis passe a la deuxieme ligne. Notons qu'on gere la derniere ligne de noeuds a part. 

    - generate_random_laby_fusion : On se donne:<br>
    Une matrice d'identifiants tous unique (de 1 jusqu'a nm-1 ) qu'on appelera tag<br>
    Une liste des arretes possibles dans un ordre aleatoire
    On sait que pour obtenir un labyrinthe il faut supprimer nm-1 murs et donc
    le fonctionnement de l'algo est le suivant:
        - Si on a supprimer nm-1 murs alors on s'arrete et on renvoie le laby
        - Sinon <br>
            - On prend le premier element de notre liste d'arretes (id1, id2) et on compare les tags associes aux noeuds i.e tag[id1] et tag[id2] de positions id1 et id2.
            - On parcours tous le labyrinthe a partir du noeud a la position de max(tag[id1],tag[id2]) ,de proche en proche (donc que les noeuds attaignables a partir de notre position)  et mettant tous les tags des neouds parcourus a  min(tag[id1],tag[id2])
            - On incremente notre compteur de murs supprimer
            - On se rappelle recursivement

        l'idee avec cet algo c'est d'identifier chaque case d'un laby hermetiquement ferme puis apres suppression d'un mur de la grille, on set l'identifiant des cases qui sont devenu connexes au min des deux parties connexes precedentes que l'on vient de fusionner a l'aide d'une auxiliere.
        On a donc a cote de notre laby une matrice qui au fur et a mesure de l'algo va tendre a devenir une matrice nulle et donc on retourne le laby associe. 

    - generate_random_laby_exploration : Le principe de cet algo est assez similaire à celui utiliser pour résoudre un laby.<br>
    On se donne un laby plein avec toutes ces cases initialisé à non visité et une liste de noeuds visité initialisé à vide, puis:
        - On choisit une case de manière aléatoire, on la marque à visité et on l'insere dans la liste.
        - On regardes la listes de ses voisins avec lequels elle n'est pas connecté (présence d'un mur) puis:
            - Si cette liste n'est pas vide, alors parmi ceux-ci:
                - Si cette liste n'est pas vide alors on choisit un de ces voisins au hasard et on se rapelle récursivement.
                - Sinon
                    on dépile la dernière case visité et on relance l'algo à partir de là
            - Sinon on renvoie le laby 

    `Note : Les deux algos de génération ne sont pas équivalent:
    le premier priviligie l'apparition "d'arborecense" (les chemins sont beaucoup plus en zig-zag), la ou le deuxième génère des labys avec des long chemins et très peu de bifurcation, les différences sont d'autant plus visible à mesure que les labys grandissent en taille. `

    - resolve_with_path : rends une paire de laby et une liste de coordonnees qui indique le bon chemin de s vers e (utile pour l'affichage html avec animation). 
    <br>Elle utilise en particulier plusieurs sous fonctions:
        - Une fonction boucle qui s'itere sur les connexions d'un noeud sauf a une condition: si il existe une route (sans back track) du noeud jusqu'a la sortie du laby. Cette fonction rends le meme tuple que la deuxieme fonction qu'on va presenter.
        - Une fonction qui rend un tuple : un bool qui indique si le laby est resoluble en passant par une certaine route (qui sera vrai que pour la bonne route et qui est en faite la condition pour loop) et une paire de laby et bonne route.
        - Une fonction reset_visits: qui prends un laby est pose tout les visites des noeuds a false
        - Une fonction clean_path_laby : qui rend un laby avec les cases de la bonne route visitees. (on fait reset visits puis cette fonction)
        - N.B: cet algo est lineaire au nombre de noeud mais on peut baisse la complexite par un facteur constant en faisant par exemple reset et clean en meme temps.
    - algo_main_droite : On a qu'a expliquer l'algo, la fonction est une implementation directe de celui-ci. On pose notre main droite sur un mur et on traverse le labyrinthe sans le lacher, on arrivera forcement a la sortie. Cette algorithme marche que pour les labyrinthes definients tel que pour toutes deux cases, il existe un unique chemin entre celles-ci. On utilise du back-tracking, ou quand on revient sur nos pas, on `set_visite` les cases pour finir qu'avec le bon chemin. Cet algorithme est aussi lineaire en nombre de noeuds.
    - construct_laby : cette fonction lis un fichier, verifie que c'est un labyrinthe valide, puis construit le labyrinthe a partir du fichier stockee dans une liste de strings qui representent chaque ligne du fichier.
    
    

## Difficulté d'Implémentation

Les plus grandes difficultes qu'on a fait face seraient dans les affichages. Un premier point a note est que si on voyait qu'un labyrinthe ne s'affichait pas comme voulu, on ne savait pas directement si cela venait de la fonction d'affichage elle meme ou des fonctions de constructions de laby. Deuxiemement, lors des tests pour les affichages, on a rencontre beaucoup de bugs. La plupart d'eux etaient des bugs avec des solutions rapides. Souvent, c'etait des cas qu'on devait avoir geree( la raison pour laquelle on a fait des tests sur ces cas) mais qu'on a finalement oublie d'implementer dans nos codes (faute humaine pas grave). D'autres bugs devaient plus de reflexions pour les resoudre. Nous allons detailler les bugs ainsi que les solutions adoptees pour les bugs rencontrees.

## Affichage simple
### bugs dans l'affichage simple:
- derniere barre | qu'on oubliait de print.
- affichage erronne a cause d'ajout de caractere ' ' (faute d'inattention).
- affichait "." au lieu de "S" ou "E".
- caractere 'S','E' qui ne s'affichait pas si S etait dans la derniere ligne.
- caractere "." au niveau des "+ +" (et non | |) qui ne s'affichait pas dans la derniere colonne.
- affichage simple ne marchait pas pour les labys construient par construct_laby (fonction qui construit un laby depuis un fichier text) car construct_laby vers la fin declarait width comme length et length comme width donc on obtenait des affichages avec dimensions incorrectes et des parties non-connexes (remplies de murs).
- transposition des coordonnees: vu qu'on a une fonction non recursive terminale sur deux termes i et j, on a echangeait les coordonnees i et j ce qui affichait le labyrinthe avec une rotation de 90 degres.
### Solutions pour l'affichage simple :
- Au lieu de print `"|%s" str` recursivement on print `"%s|" str` recursivement et on gere simplement la premiere barre "|" sans avoir besoin donc de conditions en plus
- il fallait juste enlever un caractere ' ' dans une ligne du code, mais il fallait bien trouver cette ligne.
- on a ajoute le string string_Node qui gere ce cas entierement
- Quand on arrivait a la derniere ligne, on oubliait de toujours gere les cas ou le noeud est visite ou le noeud est la case start ou End, on avait juste a ajoute ces cas dans la partie derniere ligne.
- On obtenait des schemas de la sorte:<br> ![Image Alt Text](pics/image.png) 
![Image Alt Text](pics/image2.png) <br>
mais on a realise rapidement que ce bug provenait de `construct_laby`, donc il fallait que echanger m et n dans `construct_laby`.
- En comparant la longueur et la largeur definient avec la longueur et la largeur dans le print, on a remarque qu'ils etait inverses, puis en comparant l'affichage avec des fichiers labys, on a remarque qu'en faite tout le laby etait inversee, a 90 degres. La solution donc etait d'echanger i et j un peu partout dans l'affichage. Exemple de comparaison entre laby du fichier et laby affichee erronnee. Voici un exemple de Rotation 90 degres (l'exemple qui nous a fait realise notre erreur) :<br>
![Image Alt Text](pics/image3.png)
![Image Alt Text](pics/image4.png)

## Description des Tests
On utilisera la commande `bash filename.sh` pour ne pas oublier une ligne de commande lors de la compilation. D'ailleurs, on mets des points virgules a la fin de chaque ligne car sinon le caractere `'\r'` serait confondu avec les lignes de commande et donc la commande bash ne marcherait pas. C'est une faute reliee au differentes interpretations linux/windows des caracteres du fichier. le point virgule transforme alors `'\r'` en une commande unique qui donnera un message d'erreur `"command not found"` mais le reste sera bien executee.

Passons aux tests.
### node_test
fichiers utilisees:
- `node_test.ml`
- `test_node.sh`<br>
On test ici toutes les fonctions utiles aux Nodes, et la facon dont on check les test est avec la fonction `print_noeud` ou print les exceptions `Failure`.

Le but est de tester si la creation, la modification du champ visite, l'ajout et la suppression de connexion se fait bien. 

Node etant une structure de donnee assez simple, on a pas rencontre de bug et tout les tests ont passe. 

### grille_test
fichiers utilisees:
- grille_test.ml
- test_grid.sh <br>

On test ici les fonctions utiles a la grille, la facon de verifier les tests est en affichant les noeuds de la grille a l'aide de la fonction `Node.print_noeud`.

On test ici si la grille qu'on cree est bien implementee, si l'ajout d'un mur valide est bon, si la suppression d'un mur se passe comme voulu, si des grilles sont egales et a la fin si les voisins sont biens mis en place dans la grille.

Encore une fois, vu que la structure est assez simple et qu'on a pas de fonctions qui implementent des algos difficiles, tout les tests ont bien passe du premier coup.

### laby_test
Il y a deux parties dans ce test. C'est le module le plus testee du projet, parce que le module laby implemente les algorithmes les plus durs. En plus, on a besoin de verifier beaucoup de cas speciaux vu que c'est une structure assez complexe.
#### tester les algo de generations et de resolutions
fichiers utilisees:
- `laby_test.ml`
- `test_laby.sh`

On test dans la premiere section les algorithmes de generations de labys, les algorithmes de resolutions ainsi que de fonctions utiles comme `cree_laby_plein` , `cree_laby_vide`, etc.

Pour ne pas avoir des labys random a chaque test, on a initialiser un nombre random et on a repete les tests avec celui-ci.

On test les generations et les resolutions avec des cas extremes, par exemple avec des labys rectangulaire avec `'S'` et `'E'` aux extremites, avec `'S'` qui se met entre 3 murs au debut (test utile pour `algo_main_droite`), etc.

On en fait plusieurs pour bien s'assurer que tout est bien implementer.


#### Parti pour tester construit_laby
Il manque encore les fonctions qui lisent des labys et qui les generent dont `construct_laby`. On donne en premiers quelques bon labys pour voir si laby est capable de les lire et de les refaire et resoudre.<br>
On choisit expres des cases aux extremites pour 'S' et 'E' dans plusieurs labys, des labyrinthes rectangulaires pour verifier que le laby n'inverse pas width et length et des labys pas si grands pour pouvoir verifier qu'ils sont vraiment les memes que ceux des fichiers. On a ensuite mis des fake labys. On specifira chaque erreur dans la documentation chaque fake. Voici les noms des fichiers :
- maze_11x6
- maze_4x8
- maze_4x9
- maze_3x2
- maze_6x12
- maze_6x6
- Fake1 a un + en moins a la toute fin
- Fake2 a 'E' au mauvais endroit (en dessous d'un plus ligne un au lieu den dessous de -)
- Fake3 a un + au lieu d'un | a la ligne 51 a la toute fin
- Fake4 a deux caracteres 'S' au lieu d'un. Un au debut de la dernière ligne et un a la fin de la ligne au dessus pour s'assurer que es flags se transmettent bien.
- fake5 n'a pas de case 'E'
- fake6 a un + manquant a la ligne 88 vers la fin
- Fake7 a un | au mauvais endroit a la ligne 21
- Fake8 a un | en moins a la ligne 2 (la taille de la ligne est donc plus petite que celle originale)
- Fake9 a un + en moins a la ligne 71, remplacee par un un caractere ' '
- Fake10 n'a pas de case 'S'



## Affichage Avancé

Pour cette section on a decidé de partir sur de l'html principalement pour notre familiarté avec celui-ci. La principale contrainte avec ce choix est que l'on doit faire un sorte qu'un seul redirect shell ( > ) soit nécéssaire pour générer le résultat finale.

### Gestion des éléments de style:

 Pour cela on a décidé d'utiliser des variables dans un fichier `main.css` qui contient l'essentiel des éléements de style commun à toute les cases, cela permet d'énoremement factoriser le code ocaml qui genere l'html, voici un petit apreçu de `main.css`, avec l'élement contenant les cases du laby:
```css
#grid{
    display: grid;
    grid-template-columns: repeat(var(--nb_columns),1fr);
    grid-template-rows: repeat(var(--nb_rows),1fr);
    width: calc(var(--s)* var(--nb_columns));
    height: calc(var(--s)*var(--nb_rows));
    margin: auto ;
    position: relative;
    border: 2px solid black;
}
```
- `--nb_columns` : nombre de colonnes
- `nb_rows` : nombre de ligne
- `--s` : taille d'une case en px (parametre spécifiable)

Ainsi, pour obtenir nos style il suffit d'ajouter à l'entete du fichier html 
```css
    <style>
        *{
            --nb_columns : [val];
            --nb_rows : [val];
            --s: [val]px;
        }
    </style>
```
Avec ça il nous reste plus qu'a générer les élements html nécéssaire et styliser les cases visités pour une animation, il est aussi nécéssaire de faire celle-ci dans le fichier html car un calcul de delais est nécéssaire du moins selon la contrainte qu'on s'est imposé qui est d'écrire que dans un seul fichier.

### Structure générale :

En html, on représente notre laby avec un `div` englobant la grille appelé `#grid` , celui-ci est ensuite ramplis de `div` constituant les cases et ceux grace au style css ci-dessus. Un fois les cases placé correctement dans l'enceinte on va utiliser 4 classe `upWall`, `downWall` , `rightWall`, `leftWall` , dont voici un exemple:
```css
.upWall{
    border-top: 1px solid black;
}
```

A l'aide d'une auxilière qui étant donné le laby renvoie pour chaque noeud une liste de strings "up", "down", "left", "right" suivant si un mur est present à cette direction , couplé avec les classes précédente on a donc nos murs qui sont bien représenté.

On a égalment 3 autres classes particulière `.start` , `.end` , `.visite` qui change la couleur de la case respectiviment en `vert` , `rouge` , `orange` et une classe `.text` pour styliser les eventuels caracteres.

Ce qui nous donne :
![Image Alt Text](pics/Capture2.PNG)

### Animation

Pour l'animation, il est déja essentiel d'identifier les cases qui vont subir les changements , et vu que chaque style sera légèrement différent (à cause des changements de delais) il est préférable d'utiliser les identifiants. Pour simplifier on va considérer ici l'identifiant d'une case comme étant égal à `i * longueur + j`, auquel on va ajouter une lettre au début (on a choisi c) pour que l'id soit valide.<br>
Et donc pour toutes les cases avec `visite = true` on va les ajouter à la classe `visited` avec l'id correspondant.<br>
On va maintenant définir une variable delais initialisé à 200ms et que l'on va incrémenter de 100ms au fur et à mésure que l'on parcours le chemin renvoyé par la fonction résolve (qui est dans le bon ordre). 

Petit aperçu du code liée au cases:
```css
#c53{
    animation: changeColor 1s ease forwards 300ms;
    }
#c54{
    animation: changeColor 1s ease forwards 400ms;
    }
    .
    .
    .

    @keyframes changeColor {
    0% {
        background-color: #3498db;
    }
    50% {
        background-color: #ff9248;
    }
    100% {
        background-color: #ff9248;
    }
    }
```


Toujours pour la labyrinthe précédant cela donne:
![Image Alt Text](pics/Capture3.PNG)
