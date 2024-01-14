Random.init 42

let ( +* ) t1 t2 = (fst t1 + fst t2,snd t1 + snd t2) 
let ( -* ) t1 t2 = (fst t1 - fst t2,snd t1 - snd t2) 
let dir_tab = Array.of_list (List.map Grid.get_dir [Up; Right ; Down ; Left])




let print_ids l = 
    Printf.printf "[ ";
    List.iter (fun (x,y) -> Printf.printf "(%d,%d) " x y) l ;
    Printf.printf "]\n"


    let print_edges l = 
        Printf.printf "[ ";
        List.iter (fun ((x,y),(v,w)) -> Printf.printf "((%d,%d) , (%d,%d)) " x y v w) l ;
        Printf.printf "]\n"
    
let genere_arretes n m = 
    let rec loopi i acc=
      if i = n then acc
      else 
        let ligne = List.map (fun x -> (i,x)) (List.init m (fun x->x)) in 
        loopi (i+1) (List.fold_left (fun a id-> (List.map (fun voisin-> (id,voisin))(Grid.get_voisins n m id))@a) acc ligne)
    in  loopi 0 []

let () = print_edges (genere_arretes 5 5)
let tags = Array.init 5 (fun i -> Array.init 5 (fun j -> (i*5)+j) ) 
let () = Printf.printf "%d\n" tags.(0).(0)
let () = Printf.printf "%d\n" tags.(0).(1)
let () = Printf.printf "%d\n" tags.(1).(0)
let () = Printf.printf "%d\n" tags.(1).(1)
let () = Printf.printf "%d\n" tags.(1).(4)
let () = Printf.printf "%d\n" tags.(4).(4)



let cree_laby_vide n m s e = 
    if not (Grid.coords_correctes s n m)  || not (Grid.coords_correctes e n m) then failwith "Coordonnées de départ ou d'arrivé incorrectes." 
    else
      let g = Grid.cree_grid n m [] in
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
      in loopi 0 g

let g = cree_laby_vide 5 5 (0,0) (0,0)
      let () = Node.print_noeud (Grid.get_nodes (g)).(0).(1)
      let () = Node.print_noeud (Grid.get_nodes (g)).(1).(1)
      let () = Node.print_noeud (Grid.get_nodes (g)).(1).(2)
      let () = Node.print_noeud (Grid.get_nodes (g)).(4).(4)

      let () = Node.print_noeud (Grid.get_nodes (g)).(4).(1)




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
    loopi 0


let () = (print_matrix tags 5 5)




let shuffle_edges edges = 
  let taged = List.map (fun x -> (Random.bits (), x)) edges in
  let randomized = List.sort compare taged in
  List.map snd randomized

let () = print_edges (genere_arretes 3 3)


let get_walls node = 
  let voisins_potentiels = List.map (fun v -> v -* (Node.get_id node)) (Grid.get_voisins 5 5 (Node.get_id node)) in
  let voisins_connexes = List.map (fun v -> (Node.get_id v) -* (Node.get_id node)) (Node.get_connexions node) in
  
  let rec find l v =
    match l with 
    [] -> false
    | p :: s -> if p=v then true else find s v
  in
  let rec walls directions connexions acc = 
    match directions with 
    [] -> acc
    | d :: rest -> if find connexions d then walls rest connexions acc
                  else walls rest connexions (d::acc)
in walls voisins_potentiels voisins_connexes []



let () = print_ids (get_walls (Node.cree_noeud (1,2) [Node.cree_noeud (2,2) []; Node.cree_noeud (1,3) []]  ) )