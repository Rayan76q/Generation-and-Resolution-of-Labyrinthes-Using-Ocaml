let ( +* ) t1 t2 = (fst t1 + fst t2,snd t1 + snd t2) 
let ( -* ) t1 t2 = (fst t1 - fst t2,snd t1 - snd t2) 
let dir_tab = Array.of_list (List.map Grid.get_dir [Up; Right ; Down ; Left])




let html_header laby chemin size = let s= {|<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta
      name="viewport"
      content="width=
    , initial-scale=1.0"
    />
    <title>Labyrinthe</title>
    <link rel="stylesheet" href="main.css" />

    <style> 
      *{
        --s:|} ^ (string_of_int size) ^ 
        {|px;
        --nb_rows:|} ^ (string_of_int (Grid.get_width (Laby.get_grille laby))) ^
        {|;
        --nb_columns:|} ^ (string_of_int (Grid.get_length (Laby.get_grille laby))) ^
        {|;
      }
    |}
in
  let delay = 200 in
  let rec loop list d acc= 
    match list with
    []->acc
    | (x,y) :: rest -> let s = string_of_int (x*(Grid.get_width (Laby.get_grille laby))+y) in
      loop rest (d+100) (acc ^ "#c" ^ s ^{|{
        animation: changeColor 1s ease forwards |} ^ (string_of_int d) ^ {|ms;
        }
        |}
    ) 
in 
  (loop chemin delay s) ^ {|
  @keyframes changeColor {
    0% {
        background-color: #3498db;
    }
    50% {
        background-color: #ff9248;
    }
    100% {
        background-color: #ff9248;
    }
}
  </style> 
</head> |}



let html_body laby = 

  let s =  {|<div id="window">
  <h1>Labyrinthe</h1>
  <div id="grid">|} in

  let get_walls node = 
    let voisins_potentiels = List.map (fun v -> v -* (Node.get_id node)) (Grid.get_voisins  (Grid.get_length (Laby.get_grille laby))  (Grid.get_width (Laby.get_grille laby))  (Node.get_id node)) in
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
in
  
let tdir_to_string d = 
  if d = (0,1) then "down"
  else 
    if d = (1,0) then "right"
    else 
      if d = (0,-1) then "up"
      else if d = (-1,0) then "left"
      else failwith "Tuple de directions incorrectes"
in
  

  (*Suite du body*)
  let rec loopi i s= 
    let rec loopj j s= 
      if j < Grid.get_length(Laby.get_grille laby) then 
        let s = s ^ {|
      <div class="case|} in
        let swalls = List.map tdir_to_string (get_walls (Grid.get_nodes (Laby.get_grille laby)).(j).(i)) in
        let s = (List.fold_left (fun a x -> a ^" " ^x^"Wall") s swalls) in
        let s = if (Laby.get_depart laby) = Node.get_id (Grid.get_nodes (Laby.get_grille laby)).(j).(i) then s ^ {| start"><div class="text">S</div></div>|}
                else if (Laby.get_arrive laby) = Node.get_id (Grid.get_nodes (Laby.get_grille laby)).(j).(i) then s ^ {| end"><div class="text">E</div></div>|}
                else if Node.est_visite (Grid.get_nodes (Laby.get_grille laby)).(j).(i) then s ^ {| " id="c|} ^ (string_of_int (j*Grid.get_width (Laby.get_grille laby)+i))^{|"></div>|}
                else s ^ {|"></div>|}
          in loopj (j+1) s
      else
        s 
    in
    if i < Grid.get_width (Laby.get_grille laby) then 
      begin
      let s = loopj 0 s in
      loopi (i+1) s
      end
    else
      s
  in
  let s = loopi 0 s in 
  s ^ {|
  </body>
  </html>|}

let generate_html laby path size = (html_header laby path size) ^ (html_body laby)
