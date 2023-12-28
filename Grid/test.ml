
type node =  {id : int*int ; connexions : node list}

(*Getters*)
let get_id n = n.id
let get_connexions n = n.connexions 

(*Setters*)
let set_id n id = {id = id ; connexions = n.connexions}
let set_connexions n connec= {id = n.id ; connexions = n.connexions}

(*Utilitaries*)

let sont_adjacent id1 id2 = 
    let (x1, y1) = id1 in
    let (x2, y2) = id2 in 
    let dx = abs (x1-x2) in 
    let dy = abs (y1-y2) in
    dx = 0 && dy = 1 || dx = 1 && dy = 0

let sont_connecte n1 n2 = 
    (*unidirectionelle*)
    let rec loop l = 
    match l with 
    [] -> false
    | p::suite -> if compare p.id n2.id = 0 then true else loop suite
    in loop n1.connexions

let ajoute_connexion n m =
    (*Fait du bidirectionelle*)
    if List.length n.connexions = 4 ||  List.length m.connexions = 4 then (n , m) (*pas de voisins à ajouter*)
    else
        if not (sont_adjacent n.id m.id) then failwith "Les deux noeuds ne sont pas adjacents"
        else 
            if not (sont_connecte n m) then 
                let n2 = {id = n.id ; connexions = m::n.connexions} in 
                if not (sont_connecte m n) then 
                    let m2 = {id = m.id ; connexions = n::m.connexions} in 
                    (n2 , m2)
                else
                    (n2,m)
            else
                if not (sont_connecte m n) then 
                    let m2 = {id = m.id ; connexions = n::m.connexions} in 
                    (n , m2)
                else
                    (n,m)


let supprime_connexion n ident =
    (* Ne fait rien si m n'est pas connecté à n *)
    if not (sont_adjacent n.id ident) then failwith "Les deux noeuds ne sont pas adjacents"
    else
    let rec loop l m = 
        match l with 
        [] -> []
        |p::s -> if p.id = m then s else p::(loop s m)
    in {id = n.id ; connexions = (loop n.connexions ident)}


let cree_noeud i list_co = 
    let n = {id = i ; connexions = []} in 
    let rec loop l n =
        match l with
        []-> n
        |p::s -> try loop s (fst (ajoute_connexion n p)) 
                with 
                _ -> loop s n
    in loop list_co n 

let print_noeud n = 
    Printf.printf "Noeud: (%d , %d)\n---------\nConnexions: " (fst n.id) (snd n.id);
    if List.length n.connexions >0 then List.iter (fun x -> Printf.printf "(%d , %d)" (fst x.id) (snd x.id) ) n.connexions
    else  Printf.printf " / " ;
    Printf.printf "\n\n"





type directions = Up | Down | Left | Right

let get_dir d = 
  match d with 
  Up -> (0,1)
  | Down -> (0,-1)
  | Left -> (-1,0)
  | Right -> (1,0)
  let ( + ) t1 t2 = (fst t1 + fst t2,snd t1 + snd t2) 

  let dir_tab = Array.of_list (List.map get_dir [Up; Right ; Down ; Left])

  let coords_correctes coords n m =
    (fst coords) >=0 && (fst coords) <n && (snd coords) >=0 && (snd coords) <m
  
  let get_voisins n m id1 = 
    (*Renvoie une liste des voisins du noeud, connecté ou pas*)
    if coords_correctes id1 n m then 
    let voisins_potentiels = Array.map (fun x -> id1+x) dir_tab in
    List.filter (fun v-> coords_correctes v n m) (Array.to_list voisins_potentiels)
    else
      failwith "Coordonnées Invalides"



let generate_nodes n m = 
  (*Génere une matrice m.n de noeuds avec 0 connexions*)
  Array.init n (fun i -> Array.init m (fun j -> (cree_noeud (i,j) []) ) )

let l = Array.to_list (Array.to_list (generate_nodes 5 5))

let ()  = List.iter (fun (x,y) -> Printf.printf "(%d %d) " x y) l