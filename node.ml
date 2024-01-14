
type node =  {id : int*int ; connexions : node list ; visite : bool}

(*Getters*)
let get_id n = n.id
let get_connexions n = n.connexions 
let est_visite n = n.visite 


(*Setters*)
let set_id n id = {id = id ; connexions = n.connexions ; visite = n.visite}
let set_connexions n connec= {id = n.id ; connexions = n.connexions; visite = n.visite}
let set_visite n b = {id = n.id ; connexions = n.connexions ; visite = b}

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
    (*Fait du bidirectionel*)
    if List.length n.connexions = 4 ||  List.length m.connexions = 4 then (n , m) (*pas de voisins à ajouter*)
    else
        if not (sont_adjacent n.id m.id) then failwith "Les deux noeuds ne sont pas adjacents"
        else 
            if not (sont_connecte n m) then 
                let n2 = {id = n.id ; connexions = m::n.connexions ; visite = n.visite} in 
                if not (sont_connecte m n) then 
                    let m2 = {id = m.id ; connexions = n::m.connexions ; visite = m.visite} in 
                    (n2 , m2)
                else
                    (n2,m)
            else
                if not (sont_connecte m n) then 
                    let m2 = {id = m.id ; connexions = n::m.connexions ; visite = m.visite} in 
                    (n , m2)
                else
                    (n,m)

let supprime_connexion n m = 
    (*Fait du bidirectionel*)
    let bis n ident =
    (* Ne fait rien si m n'est pas connecté à n *)
    if not (sont_adjacent n.id ident) then failwith "Les deux noeuds ne sont pas adjacents"
    else
        let rec loop l m = 
        match l with 
        [] -> []
        |p::s -> if p.id = m then s else p::(loop s m)
        in {id = n.id ; connexions = (loop n.connexions ident); visite = n.visite}
    in 
    (bis n m.id , bis m n.id)


let cree_noeud i list_co = 
    let n = {id = i ; connexions = [] ; visite = false} in 
    let rec loop l n =
        match l with
        []-> n
        |p::s -> try loop s (fst (ajoute_connexion n p)) 
                with 
                _ -> loop s n
    in loop list_co n 

let print_noeud n = 
    Printf.printf "Noeud: (%d , %d)"  (fst n.id) (snd n.id);
    let suite_print = 
        Printf.printf"\n------------\nConnexions: ";
        if List.length n.connexions >0 then List.iter (fun x -> Printf.printf "(%d , %d)" (fst x.id) (snd x.id) ) n.connexions
        else  Printf.printf " / " ;
        Printf.printf "\n"
    in
    if n.visite then 
        begin
        Printf.printf "-Visite.\n\n" ;
        suite_print 
        end
    else 
        Printf.printf "-Pas visite.\n\n";
        suite_print





