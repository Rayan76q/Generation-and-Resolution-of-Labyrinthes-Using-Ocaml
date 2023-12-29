
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