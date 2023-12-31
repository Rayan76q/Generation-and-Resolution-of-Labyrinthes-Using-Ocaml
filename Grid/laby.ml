(*Directions*)
type node = Node.node
type grid = Grid.grid
type directions = Grid.directions

let dir_tab = Array.of_list (List.map Grid.get_dir [Up; Right ; Down ; Left])
let ( +* ) t1 t2 = (fst t1 + fst t2,snd t1 + snd t2) 


type laby = {depart : int*int ; arrive : int*int ; position : int*int ; grille : grid}


let cree_laby_plein n m s e = 
  if not (Grid.coords_correctes s n m)  || not (Grid.coords_correctes e n m) then failwith "Coordonnées de départ ou d'arrivé incorrectes." 
  else
    {depart = s ; arrive = e ; position = s ; grille = (Grid.cree_grid n m []) }


let cree_laby_vide n m s e = 
  if not (Grid.coords_correctes s n m)  || not (Grid.coords_correctes e n m) then failwith "Coordonnées de départ ou d'arrivé incorrectes." 
  else
    let g = Grid.cree_grid n m [] in   (*grille pleine de murs*)
      let rec loopi i g = 
        let rec loopj j g =
          if j = m then g
          else
            let voisins = (Grid.get_voisins n m (i,j))  in 
            let rec connecte_voisins l g= 
                match l with 
                [] -> g
                | v :: suite -> connecte_voisins suite (Grid.supprime_mur g (i,j) v)
          in loopj (j+1) (connecte_voisins voisins g)
        in
        if i = n then g
        else let r = loopj 0 g in 
          loopi (i+1) r
    in {depart = s ; arrive = e ; position = s ; grille = (loopi 0 g) }
    


let se_deplacer laby d = 
  let position = laby.position in
  let next = position +* Grid.get_dir d in
  let n = get_length laby.grille in 
  let m = get_width laby.grille in
  if not (Grid.coords_correctes next  n m) then failwith "Déplacement impossible : Coordonnées d'arrivée hors labyrinthe"
  else 
    if not (Node.sont_connecte (get_nodes laby.grille).(fst position).(snd position) (get_nodes laby.grille).(fst next).(snd next)) ||
      not ((Node.sont_connecte (get_nodes laby.grille).(fst next).(snd next)) (get_nodes laby.grille).(fst position).(snd position) ) then failwith "Deplacement impossible: Il y a un mur entre les deux cases"
  else
    {depart = s ; arrive = s ; position = next ; grille = laby.grille }


let est_resolu laby = laby.position = laby.arrive

(*Getters*)
let get_depart laby = laby.depart
let get_arrive laby = laby.arrive
let get_position laby = laby.position
let get_grille laby = laby.grille

(*Setters*)
let set_depart laby id =
    if not (Grid.coords_correctes id (get_length (laby.grille)) (get_width (laby.grille))) then failwith "Coordonnées pour la case de départ incorrectes."
    else
        {depart = id ; arrive=laby.arrive ; position = depart ; grille = laby.grille}

let set_arrive laby id =
    if not (Grid.coords_correctes id (get_length (laby.grille)) (get_width (laby.grille))) then failwith "Coordonnées pour la case d'arrivé incorrectes."
    else
        {depart = laby.depart ; arrive= id ; position = laby.position ; grille = laby.grille}



let print_laby laby =
  let n = Grid.get_length laby.grille in
  let m = Grid.get_width laby.grille in
  let nodes = Grid.get_nodes laby.grille in

  Printf.printf "Labyrinth (n = %d, m = %d)\n" n m;
  
  Array.iteri (fun i row ->
    Array.iteri (fun j node ->
      Printf.printf "Node: (%d, %d)\n---------\n" i j;
      Node.print_noeud node
    ) row
  ) nodes;

  Printf.printf "Depart: (%d, %d)\n" (fst laby.depart) (snd laby.depart);
  Printf.printf "Arrive: (%d, %d)\n" (fst laby.arrive) (snd laby.arrive);
  Printf.printf "Position: (%d, %d)\n\n" (fst laby.position) (snd laby.position)
;;

(* Example usage *)
let () =
  let laby = cree_laby_plein 3 3 (0, 0) (2, 2) in
  print_laby laby;
;;