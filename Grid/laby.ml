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
    {depart = g.depart ; arrive = g.arrive ; position = next ; grille = laby.grille }


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
;;
let set_arrive laby id =
    if not (Grid.coords_correctes id (get_length (laby.grille)) (get_width (laby.grille))) then failwith "Coordonnées pour la case d'arrivé incorrectes."
    else
        {depart = laby.depart ; arrive= id ; position = laby.position ; grille = laby.grille}
;;

let print_laby laby=
  let y = get_length laby.grille in
    let x = get_width laby.grille in
      let n = get_nodes laby.grille in
        let rec print_edge w=
          begin
            if w>=0 then
              Printf.printf "-+" ;
              print_edge w-1;
          end 
          in 
        let rec print_co_droit a1 xx yy i j str dep=
          let string_Node=
            match (i,j) with
              dep->"S"
              |arr->"E"
              |_->" "
          in
          if j<yy-1 then
            if i = xx-1 then 
                Printf.printf" | \n";
                Printf.printf "%s \n" str;
                Printf.printf "|"; 
              (print_co_droit a1 xx yy 0 j+1 "+")
            else begin
              if sont_connecte a1.(i).(j) a1.(i+1).(j) then 
                printf.Printf("%s ") string_Node
              else Printf.printf("%s|") string_Node
              if sont_connecte a1.(i).(j) a1.(i).(j+1) then
                let str = str^" +" in print_co_droit a1 xx yy (i+1) j str
              else let str = str^"-+" in print_co_droit a1 xx yy (i+1) j str
            end 
          else 
            if i = xx-1 then 
              Printf.printf" | \n";
              print_edge xx-1;
            else
              if sont_connecte a1.(i).(j) a1.(i+1).(j) then 
                printf.Printf("%s ") string_Node
              else Printf.printf("%s|") string_Node
              print_co_droit a1 xx yy (i+1) j str
        in
          (print_edge (x-1));
          Printf.printf "\n";
          Printf.printf "|";
          print_co_droit n x y 0 0 "+";
      ;;
