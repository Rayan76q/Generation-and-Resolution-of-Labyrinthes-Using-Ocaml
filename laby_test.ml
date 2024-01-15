
let l = cree_laby_plein 10 10 (0,0) (5,5)
let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.supprime_mur l.grille (0,0) (0,1)) }
let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.supprime_mur l.grille (0,2) (0,1)) }
let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.supprime_mur l.grille (0,0) (1,0)) }

let () = print_laby l


let l = cree_laby_vide 10 8 (0,0) (5,5)
let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.ajoute_mur l.grille (0,0) (1,0)) }
let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.ajoute_mur l.grille (5,5) (6,5)) }
let l={depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = Grid.visite_case l.grille (1,1)}
let () = print_laby l

let l={depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = Grid.visite_case l.grille (0,0)}
let () = print_laby l

let l={depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = Grid.visite_case l.grille (1,0)}
let () = print_laby l


let random_laby = generate_random_laby_fusion 5 7 (0,6) (0,0)
let () = print_laby random_laby  
let ()= print_laby (algo_main_droite random_laby)

let random_laby = generate_random_laby_exploration 5 4 (0,0) (3,1)
let l= resolve_cours random_laby 
let () = print_laby (l) 

let random_laby = generate_random_laby_exploration 50 50 (5,18) (31,42)
let ()= print_laby (resolve_cours random_laby)


let random_laby = generate_random_laby_exploration 7 8 (4,4) (6,7)
let ()= print_laby (resolve_cours random_laby)

let random_laby = generate_random_laby_exploration 6 8 (3,4) (0,7)
let ()= print_laby (resolve_cours random_laby)

let random_laby = generate_random_laby_exploration 6 7 (3,4) (5,0)
let ()= print_laby (pledge_algo random_laby) 

