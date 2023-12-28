type node =  Node.node

(*Random testings *)
let n = Node.cree_noeud (1,1) []
let () = Node.print_noeud n
let n = fst (Node.ajoute_connexion n (Node.cree_noeud (1,2) []))
let () = Node.print_noeud n

let m = Node.cree_noeud (1,2) [(Node.cree_noeud (1,2) []); (Node.cree_noeud (1,3) [])]
let () = Node.print_noeud m

let m = Node.supprime_connexion m (1,2)
let () = Node.print_noeud m


let m = Node.supprime_connexion m (1,3)
let () = Node.print_noeud m
let n= Node.supprime_connexion n (1,2)
let ()=Printf.printf "--------------------------\n"
let () = Node.print_noeud n
let () = Node.print_noeud m
let (n , m ) = Node.ajoute_connexion n m 
let () = Node.print_noeud n
let () = Node.print_noeud m

let () = Printf.printf "%b %b\n" (Node.sont_connecte n m) (Node.sont_connecte m n)
let (n , m ) = Node.ajoute_connexion n m 

let () = Node.print_noeud n
let () = Node.print_noeud m
