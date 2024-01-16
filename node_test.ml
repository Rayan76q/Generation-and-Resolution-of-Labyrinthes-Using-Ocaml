type node =  Node.node

(*Random testings *)
let n = Node.cree_noeud (1,1) []
let () = Node.print_noeud n
let n = fst (Node.ajoute_connexion n (Node.cree_noeud (1,2) []))
let () = Node.print_noeud n

let m = Node.cree_noeud (1,2) [(Node.cree_noeud (2,2) []); (Node.cree_noeud (1,3) [])]
let () = Node.print_noeud m



(*
Erreur, supprime_connexion
let m = Node.supprime_connexion m (1,3)
let () = Node.print_noeud m
let n = Node.supprime_connexion n (1,2) 
*)
let ()=Printf.printf "--------------------------------\n"
let m = Node.cree_noeud (1,2) [(Node.cree_noeud (1,3) [])]
let n = Node.cree_noeud (1,1) []

let () = Node.print_noeud n
let () = Node.print_noeud m
let (n , m ) = Node.ajoute_connexion n m 
let () = Node.print_noeud n
let () = Node.print_noeud m

let () = Printf.printf "%b %b\n" (Node.sont_connecte n m) (Node.sont_connecte m n)
let (n , m ) = Node.ajoute_connexion n m 

let () = Node.print_noeud n
let () = Node.print_noeud m

let () =
  let(n, m)=Node.supprime_connexion n m in
  Node.print_noeud n; Node.print_noeud m
;;


let ()=Printf.printf "--------------------------------\n"

let()= 
  let n= Node.set_visite n true in
  let m=Node.set_visite m true in
  Node.print_noeud n; Node.print_noeud m;
;;

let()= 
  let n= Node.set_visite n false in
  let mm=Node.set_visite m true in
  Node.print_noeud n; Node.print_noeud mm
;;

let()=
  let fon_fail_node x y w z=
    let m = Node.cree_noeud (x,y) [] in
    let n = Node.cree_noeud (w,z) [] in
    try 
      let (n , m ) = Node.ajoute_connexion n m in
      Node.print_noeud n; Node.print_noeud m;
    with
    | Failure msg -> Printf.printf "fail: %s\n" msg; Printf.printf "-----------------------\n"
  in
  fon_fail_node 1 1 2 2;
  fon_fail_node 1 1 2 1;
  fon_fail_node 2 2 3 3;
  fon_fail_node 1 0 0 1;
  fon_fail_node 1 0 1 0 (*fail si meme node evidemment*)
;;