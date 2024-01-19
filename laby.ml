(*Directions*)
type grid = Grid.grid

let dir_tab = Array.of_list (List.map Grid.get_dir [Up; Right ; Down ; Left])
let ( +* ) t1 t2 = (fst t1 + fst t2,snd t1 + snd t2) 
let ( -* ) t1 t2 = (fst t1 - fst t2,snd t1 - snd t2) 



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
;;

let cree_laby n m s e grille=
  if not (Grid.coords_correctes s n m)  || not (Grid.coords_correctes e n m) then failwith "Coordonnées de départ ou d'arrivé incorrectes." 
  else
    {depart = s ; arrive = e ; position = s ; grille = grille}


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

(*auxiliere pour la resolution 1 de labys*)
let rec loop l f laby pile=
  match l with
  a::l1-> let x,y= f a in if fst x = false then loop l1 f laby y else (x,(a::y)@pile)
  |[]-> (false , laby), pile 
;;

let rec resolve_bis_cours labyy i j nnode pile=
  if (i,j) = labyy.arrive then 
    ((true , labyy ) , pile)
  else if (Node.est_visite(nnode.(i).(j))=false ) then 
    let node_remplacement = Node.set_visite nnode.(i).(j) true in
    nnode.(i).(j)<-node_remplacement;
    let conn = Node.get_connexions nnode.(i).(j) in
    let conn= List.map Node.get_id conn in 
    let fin = loop conn (fun (x,y)-> resolve_bis_cours labyy x y nnode pile) labyy pile in
  fin
  else ((false , labyy) , pile)
;;

let clean_path_laby laby lissst=
  let rec loopp labyy l=
    match l with
    a::l1-> loopp (set_visite_case labyy a) l1
    |[]->labyy
  in loopp laby lissst
;;

let resolve_with_path laby =
  let big_M=resolve_bis_cours laby (fst laby.depart) (snd laby.depart) (Grid.get_nodes laby.grille) [] in
  let lab = reset_visits (snd ( fst big_M)) in
  let clean_laby = clean_path_laby lab (snd big_M) in
  let clean_laby = set_visite_case clean_laby laby.depart in
  ( clean_laby, (laby.depart)::(snd big_M) )
;;

(*fonctions d'affichage*)
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
                  if Node.est_visite a1.(i).(j) && Node.est_visite a1.(i).(j+1) then
                    Printf.printf "%s.+\n" str
                  else
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

(*******************algo_main_droite*********************)
let algo_main_droite laby =
  let laby =set_visite_case laby laby.depart in
  let nnode = Grid.get_nodes laby.grille in
  let x = (Grid.get_length laby.grille)-1 in
  let y= (Grid.get_width laby.grille)-1 in
  let move_dir dir=
    match dir with
    0-> (1,0) (*droite*)
    |1-> (0,-1) (*haut*)
    |2->(-1,0) (*gauche*)
    |3->(0,1) (*bas*)
    |_-> failwith "direction diverged"
  in
    let check_no_wall dire (i,j)=
      match dire with
      0->i!=x && Node.sont_connecte nnode.(i+1).(j) nnode.(i).(j) &&  Node.sont_connecte nnode.(i).(j) nnode.(i+1).(j)
      |1->j!=0 && Node.sont_connecte nnode.(i).(j) nnode.(i).(j-1) &&  Node.sont_connecte nnode.(i).(j-1) nnode.(i).(j)
      |2->i!=0 && Node.sont_connecte nnode.(i-1).(j) nnode.(i).(j) &&  Node.sont_connecte nnode.(i).(j) nnode.(i-1).(j)
      |3->j!=y && Node.sont_connecte nnode.(i).(j+1) nnode.(i).(j) &&  Node.sont_connecte nnode.(i).(j) nnode.(i).(j+1)
      |_-> failwith "direction diverged"
    in
    let factorise_visits position1 position2 labs=
      if Node.est_visite nnode.(fst position2).(snd position2) then
        let labs = set_visite_case labs position1 in
          {depart = labs.depart; arrive = labs.arrive; position=(position2); grille=labs.grille}
      else
        let labs = set_visite_case labs (position2) in
          {depart = labs.depart; arrive = labs.arrive; position=(position2); grille=labs.grille}
      in
      let rec helper dir labs=
        if labs.position = labs.arrive then labs
        else
          if check_no_wall ((dir+3) mod 4) labs.position then
            let pos2 =(labs.position +* (move_dir ((dir+3) mod 4))) in
            let labs = factorise_visits labs.position pos2 labs in
                  helper ((dir+3) mod 4) labs;
          else if check_no_wall (dir) labs.position then 
            let pos2 = (labs.position +* (move_dir dir)) in
              let labs=factorise_visits labs.position pos2 labs in
                helper (dir) labs;
          else 
            helper ((dir+1) mod 4) labs;
      in
    let voisin = 
      let connexions = Node.get_connexions (nnode.(fst laby.depart).(snd laby.depart)) in
        match connexions with 
        a:: rest ->a
        | [] -> failwith "Laby non résoluble.";
      in
      let t =(Node.get_id nnode.(fst (Node.get_id voisin)).((snd (Node.get_id voisin)))) -* laby.depart 
  in
    match t with
      (0,1) -> helper 3 laby
      | (0,-1) ->helper 1 laby
      | (-1,0) -> helper 2 laby
      | (1,0) ->helper 0 laby
      |_ -> failwith "pas besoin de ce cas mais on l'ajoute pour que le compilateur ne se plaint pas."; 
;;

(****************************************Lecture****************************************)
let rec rev_and_count l acc_rev acc_length=
  match l with
  []->acc_rev,(acc_length-1)/2
  |a::l1->rev_and_count l1 (a::acc_rev) (acc_length + 1)
;;

let length_read_laby l=
  match l with
  []->0
  |a::_->((String.length a)-1)/2
;;

let read_file_lines filename =
  let in_channel = open_in filename in
  let rec read_lines acc =
    try
      let line = input_line in_channel in
      read_lines (line :: acc)
    with End_of_file ->
      close_in in_channel;
      List.rev acc
  in
  Array.of_list( read_lines [])
;;

let check_line i current_char lines s e =
  let width = String.length lines.(0) in
    let rec loop j c edge start_pos end_pos=
      if j<width-1 then
        if i=0 || i=(Array.length lines)-1 then 
          match c with
          '+'-> if j mod 2=0 then loop (j+1) lines.(i).[j+1] edge start_pos end_pos else failwith "laby non integre"
          |'-'-> if j mod 2 =1 then loop (j+1) lines.(i).[j+1] edge start_pos end_pos else failwith "laby non integre"
          |_->failwith "laby non integre"
        else
          if i mod 2 = 0 then
            match c with
            '+'-> if j mod 2=0 then loop (j+1) lines.(i).[j+1] edge start_pos end_pos  else failwith "laby non integre"
            |'-'|' '-> if j mod 2 =1 then loop (j+1) lines.(i).[j+1] edge start_pos end_pos else failwith "laby non integre"
            |_->failwith "laby non integre"
          else 
          match c with
          '|'-> if j mod 2=0 then loop (j+1) lines.(i).[j+1]  edge start_pos end_pos else failwith "laby non integre"
          |' '->
              if j mod 2 = 1 then
                if lines.(i).[j+1] = ' ' then
                  if lines.(i+1).[j] = ' ' then 
                    loop (j+1) lines.(i).[j+1] (((j,i),(j,i+2))::((j,i),(j+2,i))::edge) start_pos end_pos
                  else loop (j+1) lines.(i).[j+1] (((j,i),(j+2,i))::edge) start_pos end_pos
                else 
                  if lines.(i+1).[j] = ' ' then 
                    loop (j+1) lines.(i).[j+1]  (((j,i),(j,i+2))::edge) start_pos end_pos 
                  else 
                    loop (j+1) lines.(i).[j+1]  edge start_pos end_pos
              else 
                loop (j+1) lines.(i).[j+1]  edge start_pos end_pos
          |'S'-> if j mod 2=1 && start_pos=(-1,-1) then 
            if lines.(i).[j+1] = ' ' then
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (((j,i),(j,i+2))::((j,i),(j+2,i))::edge) (j,i) end_pos
              else loop (j+1) lines.(i).[j+1] (((j,i),(j+2,i))::edge) (j,i) end_pos
            else 
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (((j,i),(j,i+2))::edge) (j,i) end_pos
              else
                loop (j+1) lines.(i).[j+1] edge (j,i) end_pos
            else failwith "laby non integre"
          |'E'->if j mod 2 = 1 && end_pos=(-1,-1) then 
            if lines.(i).[j+1] = ' ' then
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (((j,i),(j,i+2))::((j,i),(j+2,i))::edge) start_pos (j,i)
              else loop (j+1) lines.(i).[j+1] (((j,i),(j+2,i))::edge) start_pos (j,i)
            else 
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (((j,i),(j,i+2))::edge)  start_pos (j,i)
              else 
                loop (j+1) lines.(i).[j+1] edge start_pos (j,i)
            else failwith "laby non integre"
          |_->failwith "laby non integre"
      else 
        (edge, (start_pos, end_pos)) 
    in
    if String.length lines.(i) != width then failwith "laby non integre"
    else
      if i!=(Array.length lines)-1 && i mod 2 = 1 && lines.(i+1).[width-2] = ' ' then
          loop 0 current_char  (((width-1,i),(width-2,i+2))::[]) s e
      else
      loop 0 current_char  [] s e
;;

let check_laby string_array=
  let rec check_laby_h edge i start en=
    if i<(Array.length string_array)-1 then
      let (edgi , (si ,ei)) = check_line i string_array.(i).[0] string_array start en in
      check_laby_h (edgi@edge) (i+1) si ei
    else 
      (edge , (start, en))
    in
    let (edg , (st, en)) = check_laby_h [] 0 (-1,-1) (-1,-1) in
    let normalise = (fun ((x,y),(w,z))->((x-1)/2,(y-1)/2),((w-1)/2,(z-1)/2)) in
    ((List.map normalise edg) , normalise (st , en) )
;;


let construct_laby f =
  let lines= read_file_lines f in
  let (edges , (s ,e)) = check_laby lines in
  let m = ((Array.length lines - 1)/2 ) in
  let n = (((String.length lines.(0))- 1)/2) in
  if s = (-1,-1) || e = (-1,-1) then failwith "Départ ou arrivé non assigné."
  else
  cree_laby n m s e (Grid.cree_grid n m edges)

;;
(***********STATISTIQUES*************)
let create_2d_array m n =
  Array.init m (fun i ->Array.init n (fun j -> (i, j)))
;;

let flatten_2d_array array =
  let m = Array.length array in
  let rec loopi i acc= 
    if i = m then acc
    else
    loopi (i+1) (acc@(Array.to_list array.(i)))
  in loopi 0 []
;;
let liste_co l=
  let rec liste_coord liste acc= 
    match liste with
    []->acc
    |first::l1->liste_coord l1 (List.fold_left (fun a x -> (x,first)::a ) acc l1 ) 
  in liste_coord l []
;;

let genere_tout_points m n= liste_co(flatten_2d_array (create_2d_array m n))
;;

let complexite_du_laby lab=
  let l = (snd (resolve_with_path lab)) in
  match l with 
  []-> failwith "ayo"
  |(0,0)::[]->failwith "laby non resoluble"
  |_->
    let n= Grid.get_width lab.grille in
      let m = Grid.get_length lab.grille in
        let l = genere_tout_points m n in
        let num =List.fold_left (fun acc ((x,y),(w,z)) -> 
          let laby = { depart= (x,y) ; arrive =(w,z) ;position = lab.position ;grille = lab.grille} in 
            let labyy= reset_visits laby in ((float_of_int ( (List.length ( snd (resolve_with_path labyy)))-1)) /. ( float_of_int( (abs (x-w))+(abs(y-z)) )) ) +. acc
        ) (0.) l in (num) /. (float_of_int (List.length l))
;;