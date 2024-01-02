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
  let n = Grid.get_length laby.grille in 
  let m = Grid.get_width laby.grille in
  if not (Grid.coords_correctes next  n m) then failwith "Déplacement impossible : Coordonnées d'arrivée hors labyrinthe"
  else 
    if not (Node.sont_connecte (Grid.get_nodes laby.grille).(fst position).(snd position) (Grid.get_nodes laby.grille).(fst next).(snd next)) ||
      not ((Node.sont_connecte (Grid.get_nodes laby.grille).(fst next).(snd next)) (Grid.get_nodes laby.grille).(fst position).(snd position) ) then failwith "Deplacement impossible: Il y a un mur entre les deux cases"
  else
    {depart = laby.depart ; arrive = laby.arrive ; position = next ; grille = laby.grille }


let est_resolu laby = laby.position = laby.arrive

(*Getters*)
let get_depart laby = laby.depart
let get_arrive laby = laby.arrive
let get_position laby = laby.position
let get_grille laby = laby.grille

(*Setters*)
let set_depart laby id =
    if not (Grid.coords_correctes id (Grid.get_length (laby.grille)) (Grid.get_width (laby.grille))) then failwith "Coordonnées pour la case de départ incorrectes."
    else
        {depart = id ; arrive=laby.arrive ; position = id ; grille = laby.grille}
;;
let set_arrive laby id =
    if not (Grid.coords_correctes id (Grid.get_length (laby.grille)) (Grid.get_width (laby.grille))) then failwith "Coordonnées pour la case d'arrivé incorrectes."
    else
        {depart = laby.depart ; arrive= id ; position = laby.position ; grille = laby.grille}
;;

let print_laby laby=
  let y = Grid.get_length laby.grille in
    let x = Grid.get_width laby.grille in
      let n = Grid.get_nodes laby.grille in
        let rec print_edge w=
            if w>=0 then
              begin
              Printf.printf "+-" ;
              print_edge (w-1);
              end
            else 
              Printf.printf "+\n"
          in 
        let rec print_co_droit a1 xx yy i j str =
          let string_Node=
            if compare (i,j) laby.depart = 0 then "S"
            else if compare (i,j) laby.arrive = 0 then "E"
            else if Node.est_visite a1.(i).(j) then "."
            else " "
          in
          if j<yy-1 then
            if i = xx-1 then 
              begin
                Printf.printf "%s|\n" string_Node;
                let pr = if Node.sont_connecte a1.(i).(j) a1.(i).(j+1) &&  Node.sont_connecte a1.(i).(j+1) a1.(i).(j)  then 
                  Printf.printf "%s +\n" str
                else 
                  Printf.printf "%s-+\n" str
                in 
                  pr ;
                  Printf.printf "|"; 
                  print_co_droit a1 xx yy 0 (j+1) "+"
              end
            else 
              begin
                let pr2 = if Node.sont_connecte a1.(i).(j) a1.(i+1).(j) && Node.sont_connecte a1.(i+1).(j) a1.(i).(j) then 
                  Printf.printf "%s " string_Node
                else 
                  Printf.printf "%s|" string_Node ;
                in pr2 ;
                  if Node.sont_connecte a1.(i).(j) a1.(i).(j+1) &&  Node.sont_connecte a1.(i).(j+1) a1.(i).(j)  then
                    let str = 
                    begin
                      if Node.est_visite a1.(i).(j) && Node.est_visite a1.(i).(j+1) then
                        str^".+"
                      else str^" +"
                    end in print_co_droit a1 xx yy (i+1) j str
                  else let str = str^"-+" in print_co_droit a1 xx yy (i+1) j str
              end 
          else 
            if i = xx-1 then 
              begin
              Printf.printf "%s|\n" string_Node;
              print_edge (xx-1)
              end
            else 
              let pr3 = if Node.sont_connecte a1.(i).(j) a1.(i+1).(j) && Node.sont_connecte a1.(i+1).(j) a1.(i).(j)  then 
                Printf.printf "%s " string_Node
              else 
                Printf.printf "%s|" string_Node ;
              in pr3;
                print_co_droit a1 xx yy (i+1) j str
        in
          (print_edge (x-1));
          Printf.printf "|";
          print_co_droit n x y 0 0 "+";
      ;;



(*TESTS D'Affichages*)
      let l = cree_laby_plein 10 10 (0,0) (5,5)
      let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.supprime_mur l.grille (0,0) (0,1)) }
      let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.supprime_mur l.grille (0,2) (0,1)) }
      let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.supprime_mur l.grille (0,0) (1,0)) }
      
      let () = print_laby l
      
      
      let l = cree_laby_vide 10 10 (0,0) (9,9)
      let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.ajoute_mur l.grille (0,0) (1,0)) }
      let l = {depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = (Grid.ajoute_mur l.grille (5,5) (6,5)) }
      let l={depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = Grid.visite_case l.grille (1,1)}
      let () = print_laby l

      let l={depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = Grid.visite_case l.grille (0,0)}
      let () = print_laby l

      let l={depart = l.depart ; arrive = l.arrive ; position = l.position ; grille = Grid.visite_case l.grille (1,0)}
      let () = print_laby l