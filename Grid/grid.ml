type node = Node.node

type grid = {length: int; width:int;nodes : node array array ; edges : ((int * int) * (int * int)) list}


let generate_nodes n m = 
  Array.init n (fun i -> Array.init m (fun j -> (Node.cree_noeud (i,j) []) ) )

let cree_grid n m arretes = 
  let g = {length = n ; width = m ; nodes = generate_nodes n m ; edges = arretes } in
  let rec loop nodes edges acc =
  match edges with 
  [] -> acc
  | (id1 , id2)::suite -> if Node.sont_adjacent id1 id2 
    then  let (m1 ,m2)= Node.ajoute_connexion nodes.(fst id1).(snd id1) nodes.(fst id2).(snd id2) in 
          nodes.(fst id1).(snd id1) <- m1 ;
          nodes.(fst id2).(snd id2) <- m2 ;
          loop nodes suite ((id1 , id2)::acc)
    else
      loop nodes suite acc
    in 
    {length = n ; width = m ;edges = loop g.nodes g.edges []; nodes = g.nodes } 






let g = cree_grid 5 5 [((1,2),(1,1));  ((1,1),(0,1)) ]
let () = Node.print_noeud g.nodes.(0).(1)
let () = Node.print_noeud g.nodes.(1).(1)
let () = Node.print_noeud g.nodes.(1).(2)
let () = Node.print_noeud g.nodes.(0).(0)