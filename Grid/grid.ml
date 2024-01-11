type node = Node.node

type grid = {length: int; width:int;nodes : node array array ; edges : ((int * int) * (int * int)) list}



(* Directions *)
type directions = Up | Down | Left | Right
let get_dir d = 
  match d with 
  Up -> (0,1)
  | Down -> (0,-1)
  | Left -> (-1,0)
  | Right -> (1,0)
let dir_tab = Array.of_list (List.map get_dir [Up; Right ; Down ; Left])
let ( +* ) t1 t2 = (fst t1 + fst t2,snd t1 + snd t2) 

(*Fonctions de Grid*)
let generate_nodes n m = 
  (*Génere une matrice m.n de noeuds avec 0 connexions*)
  Array.init n (fun i -> Array.init m (fun j -> (Node.cree_noeud (i,j) []) ) )

let coords_correctes coords n m =
  (fst coords) >=0 && (fst coords) <n && (snd coords) >=0 && (snd coords) <m

let cree_grid n m arretes = 
  if n <= 0 || m <=0 then failwith "Dimensions Incorrectes"
  else

  (*Créer une grille de taille m*n et ajoute les connexions valides*)
  let g = {length = n ; width = m ; nodes = generate_nodes n m ; edges = arretes } in
  let rec loop nodes edges acc =
  match edges with 
  [] -> acc
  | (id1 , id2)::suite -> if Node.sont_adjacent id1 id2 && coords_correctes id1 n m && coords_correctes id2 n m
    then  let (m1 ,m2)= Node.ajoute_connexion nodes.(fst id1).(snd id1) nodes.(fst id2).(snd id2) in 
          nodes.(fst id1).(snd id1) <- m1 ;
          nodes.(fst id2).(snd id2) <- m2 ;
          loop nodes suite ((id1 , id2)::acc)
    else
      loop nodes suite acc
    in 
    {length = n ; width = m ;edges = loop g.nodes g.edges []; nodes = g.nodes } 



let ajoute_mur g id1 id2 =
  (*Suprrime la connexion entre les cases de positions id1 et id2*)
  if (not (coords_correctes id1 g.length g.width) || not (coords_correctes id2 g.length g.width))  && Node.sont_adjacent id1 id2 then failwith "Coordonnées Invalides"
  else
    let n1 = g.nodes.(fst id1).(snd id1)in
    let n2 = g.nodes.(fst id2).(snd id2) in
    let (m1 ,m2) = Node.supprime_connexion n1 n2  in
    g.nodes.(fst id1).(snd id1) <- m1 ;
    g.nodes.(fst id2).(snd id2) <- m2 ;

    let rec loop edges = 
      match edges with 
      [] -> []
      | (e1 , e2)::suite -> if e1=id1 && e2 = id2 || e1=id2 && e2=id1 then loop suite
      else (e1,e2)::(loop suite)
    
    in {length = g.length ; width = g.width ; nodes = g.nodes ; edges = loop g.edges} 


let supprime_mur g id1 id2 =
    (*Ajoute une connexion entre les cases de positions id1 et id2*)
    if not (coords_correctes id1 g.length g.width) || not (coords_correctes id2 g.length g.width) && Node.sont_adjacent id1 id2 then failwith "Coordonnées Invalides"
    else
      let n1 = g.nodes.(fst id1).(snd id1)in
      let n2 = g.nodes.(fst id2).(snd id2) in
      let (m1 ,m2) = Node.ajoute_connexion n1 n2  in
      g.nodes.(fst id1).(snd id1) <- m1 ;
      g.nodes.(fst id2).(snd id2) <- m2 ;
      {length = g.length ; width = g.width ; nodes = g.nodes ; edges = (id1 , id2)::g.edges} 
;;


let get_voisins n m id1 = 
  (*Renvoie la liste des identifiants des voisins du noeud, connecté ou pas*)
  if coords_correctes id1 n m then 
  let voisins_potentiels = Array.map (fun x -> id1+*x) dir_tab in
  List.filter (fun v-> coords_correctes v n m) (Array.to_list voisins_potentiels)
  else
    failwith "Coordonnées Invalides"


let sont_egaux g1 g2 = 
  if compare (g1.length , g1.width) (g2.length , g2.width) <> 0 || not (List.equal (fun (a1, a2) (b1, b2) -> compare a1 b1 = 0 && compare a2 b2 = 0  || compare a1 b2 = 0 && compare a2 b1 = 0 ) g1.edges g2.edges) then false
  else
    let rec loopi i = 
      let rec loopj j = 
        if j = g1.width then true
        else
          if compare (Node.get_connexions g1.nodes.(i).(j)) (Node.get_connexions g2.nodes.(i).(j)) <> 0 then false
          else loopj (j+1)
      in
      if i = g1.length then true
      else
        if loopj 0 then loopi (i+1)
        else false
    in loopi 0
  ;;

(*getters et setters*)

let get_length g = g.length
let get_width g = g.width
let get_nodes g = g.nodes
let get_edges g = g.edges

(*effectue des resize de la grille*)
let set_length g n = cree_grid n g.width g.edges
let set_width g m = cree_grid g.length m g.edges
