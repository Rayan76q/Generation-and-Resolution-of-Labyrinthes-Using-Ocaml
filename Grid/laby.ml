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
    


let set_visite_case laby id1 =
      if Grid.coords_correctes id1 (Grid.get_length laby.grille) (Grid.get_width laby.grille) then
        let nodez = Grid.get_nodes laby.grille in
        let updated_node = Node.set_visite nodez.(fst id1).(snd id1) (not (Node.est_visite nodez.(fst id1).(snd id1))) in
        nodez.(fst id1).(snd id1) <- updated_node;
        {depart = laby.depart; arrive = laby.arrive ; position= laby.position; grille = laby.grille}
      else
        failwith "Coordonnées Invalides"
;;

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


(*auxiliere pour la generation*)
Random.init 10

let print_matrix m n1 n2 = 
  let rec loopi i = 
        let rec loopj j=
          if j < n2 then
            begin Printf.printf "%d " (m.(i).(j)) ;
            loopj (j+1)
          end
        in
    if i <  n1 then 
      begin
        loopj 0 ; 
        Printf.printf "\n";
        loopi (i+1)
      end
    in 
    loopi 0 ; 
    Printf.printf "\n"


let generate_edges n m = 
  let rec loopi i acc=
    if i = n then acc
    else 
      let ligne = List.map (fun x -> (i,x)) (List.init m (fun x->x)) in 
      loopi (i+1) (List.fold_left (fun a id-> (List.map (fun voisin-> (id,voisin))(Grid.get_voisins n m id))@a) acc ligne)
  in  loopi 0 []

let shuffle_edges edges = 
  let taged = List.map (fun x -> (Random.bits (), x)) edges in
  let randomized = List.sort compare taged in
  List.map snd randomized

let delete_wall laby edge =  {depart = laby.depart ; arrive =  laby.arrive ; position = laby.position ; grille = Grid.supprime_mur laby.grille (fst edge) (snd edge) }

let rec flip tags g start v =
  tags.(fst start).(snd start) <- v;
  let current_node = (Grid.get_nodes g).(fst start).(snd start) in
    let rec loop l =
      match l with 
      [] -> ()
      | voisin::suite -> let pos_voisin = (Node.get_id voisin)in
        if tags.(fst pos_voisin).(snd pos_voisin)<>v then 
        begin
        flip tags g (Node.get_id voisin) v ;
        loop suite
        end
        else
          loop suite
    in loop (Node.get_connexions current_node)


      
    let generate_random_laby_fusion n m s e = 
      let laby = cree_laby_plein n m s e in 
      let random_walls = shuffle_edges (generate_edges n m) in
      let tags = Array.init n (fun i -> Array.init m (fun j -> (i*5)+j) )in 
      let rec loop walls wallnum matrix_tag accLaby = 
        if wallnum = n*m then accLaby  (*we done*)
        else 
          match walls with 
          [] -> failwith "ERROR"
          | ((x1,y1), (x2,y2))::rest ->
            if  matrix_tag.(x1).(y1) = matrix_tag.(x2).(y2) then
              loop rest wallnum matrix_tag accLaby
            else
              let f = if matrix_tag.(x1).(y1) < matrix_tag.(x2).(y2) 
                then flip matrix_tag accLaby.grille (x2,y2) matrix_tag.(x1).(y1)
              else 
                flip matrix_tag accLaby.grille (x1,y1) matrix_tag.(x2).(y2)
              in 
              f ;
              let nLaby = delete_wall accLaby ((x1,y1), (x2,y2)) in 
              loop rest (wallnum + 1) matrix_tag nLaby
      in
      loop random_walls 1 tags laby


(*Auxilière pour Génération par exploration*)


let choisie_voisin_random noeud =  
  let taged = List.map (fun x -> (Random.bits (), x)) noeud in
  let randomized = List.map snd (List.sort compare taged) in
  List.hd randomized

let  reset_visits laby =
  let rec loopi i laby= 
    let rec loopj j laby=
      if j < (Grid.get_width laby.grille) then
        if Node.est_visite (Grid.get_nodes laby.grille).(i).(j) then 
          loopj (j+1) (set_visite_case laby (i,j))
        else
          loopj (j+1) laby
    in
if i < (Grid.get_length laby.grille) then 
  begin
    loopj 0 laby; 
    loopi (i+1) laby
  end
else 
  laby
in 
loopi 0 laby


let generate_random_laby_exploration n m s e =
  let laby = cree_laby_plein n m s e in 
  let current_position = (Random.int n , Random.int m) in
  let rec explore current_node visited accLaby =
    let updated_laby = if not (Node.est_visite current_node) then set_visite_case accLaby (Node.get_id current_node) else accLaby in
    let voisins_non_visite = List.filter (fun node -> not (Node.est_visite node)) (List.map (fun (x,y) -> (Grid.get_nodes updated_laby.grille).(x).(y)) (Grid.get_voisins (Grid.get_length updated_laby.grille) (Grid.get_width updated_laby.grille) (Node.get_id current_node) )) in
    if voisins_non_visite = [] then 
      match visited with
      [] -> updated_laby
      | (x,y) :: rest ->explore (Grid.get_nodes updated_laby.grille).(x).(y) rest updated_laby
    else
    let v = choisie_voisin_random voisins_non_visite in
    let updated_laby = {depart = updated_laby.depart; arrive = updated_laby.arrive ; position=updated_laby.position; grille = Grid.supprime_mur updated_laby.grille (Node.get_id current_node) (Node.get_id v) } in
    explore v ((Node.get_id current_node)::visited) updated_laby
  
  in reset_visits (explore (Grid.get_nodes laby.grille).(fst current_position).(snd current_position) [] laby)


let print_laby laby=
  let x = Grid.get_length laby.grille in
    let y = Grid.get_width laby.grille in
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

      

(*TESTS D'Affichages
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
*)


let random_laby = generate_random_laby_fusion 5 4 (0,0) (2,2)
let () = print_laby random_laby 


let random_laby = generate_random_laby_exploration 5 2 (0,0) (2,1)
let () = print_laby random_laby 

