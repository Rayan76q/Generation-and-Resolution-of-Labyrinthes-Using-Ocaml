# Projet Labyrinthe

## Members
- Antoine El KASSIS
- Rayan LALAOUI

## Description

Vous trouverz dans ce repartoire l'intégralité des fichiers permetttant de représenter, afficher et résoudre des labyrinthe en ocaml ainsi que la génération de fichiers html animé de toutes ces fonctionalités.<br>
Chaque module est décomposé en trois fichier : `interface` ,`code (implémentation des fonctions)`, `fichier de test`.<br>


Les modules sont:<br>
- Node: Gère l'implémentation du type noeud , brique de base des labyrinthe.

- Grille : Gère l'implémentation du type grille ainsi que les fonctions associés.

- Laby : Module principale , contient l'implémentation des labys et des différents algorithmes de générations et de résolutions ainsi que la gestion des entrées/sorties.

- Gui : Gère la génération de fichiers HTML pour l'affichage avancé.

Le `main` est contenu dans le fichier `maze.ml` qui peut être compilé et exectuer avec les commandes : 
```shell
dune build 
./maze.exe [arguments]
```
Ceci creer un dossier _build qui peut être supprimer avec la commande.
```
dune clean
```

Les `.sh` sont la pour faciliter la compilation et l'execution des tests liés aux modules séparemment sauf `clean.sh` qui supprime les fichiers résultant de la compilation.Ceux-ci peuvent être lancés avec la commande :
```bash
bash [filename]
```

- `/doc` contient le rapport.
- `/pics` contient les images utilisé comme illustrations dans le rapport.
- `/test` contient des fichiers de labyrinthes (valide ou pas) utilisé lors des différents tests.

