
let generate_ids n m = 
  Array.init n (fun i -> Array.init m (fun j -> (i,j)) )


let () = Array.iter (fun ligne -> Array.iter (fun x -> Printf.printf "(%d, %d), "  (fst x) (snd x)) ligne ; Printf.printf "\n") (generate_ids 10 10)