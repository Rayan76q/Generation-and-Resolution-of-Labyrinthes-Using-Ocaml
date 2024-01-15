type laby=Laby.laby
type grid=Grid.grid
type node=Node.node

let rec rev_and_count l acc_rev acc_length=
  match l with
  []->acc_rev,(acc_length-1)/2
  |a::l1->rev_and_count l1 (a::acc_rev) (acc_length + 1)
;;

let length_read_laby l=
  match l with
  []->0
  |a::_->((String.length a)-1)/2
;;

let read_file_lines filename =
  let in_channel = open_in filename in
  let rec read_lines acc =
    try
      let line = input_line in_channel in
      read_lines (line :: acc)
    with End_of_file ->
      close_in in_channel;
      List.rev acc
  in
  Array.of_list( read_lines [])
;;

let check_line i current_char lines s e =
  let width = String.length lines.(0) in
    let rec loop j c f edge start_pos end_pos=
      if j<width-1 then
        if i=0 || i=(Array.length lines)-1 then 
          match c with
          '+'-> if j mod 2=0 then loop (j+1) lines.(i).[j+1] f edge start_pos end_pos else failwith "laby non integre"
          |'-'-> if j mod 2 =1 then loop (j+1) lines.(i).[j+1] f edge start_pos end_pos else failwith "laby non integre"
          |_->failwith "laby non integre"
        else
          if i mod 2 = 0 then
            match c with
            '+'-> if j mod 2=0 then loop (j+1) lines.(i).[j+1] f edge start_pos end_pos  else failwith "laby non integre"
            |'-'|' '-> if j mod 2 =1 then loop (j+1) lines.(i).[j+1] f edge start_pos end_pos else failwith "laby non integre"
            |_->failwith "laby non integre"
          else 
          match c with
          '|'-> if j mod 2=0 then loop (j+1) lines.(i).[j+1] f edge start_pos end_pos else failwith "laby non integre"
          |' '->
              if j mod 2 = 1 then
                if lines.(i).[j+1] = ' ' then
                  if lines.(i+1).[j] = ' ' then 
                    loop (j+1) lines.(i).[j+1] f (((j,i),(j,i+2))::((j,i),(j+2,i))::edge) start_pos end_pos
                  else loop (j+1) lines.(i).[j+1] f (((j,i),(j+2,i))::edge) start_pos end_pos
                else 
                  if lines.(i+1).[j] = ' ' then 
                    loop (j+1) lines.(i).[j+1] f (((j,i),(j,i+2))::edge) start_pos end_pos 
                  else 
                    loop (j+1) lines.(i).[j+1] f edge start_pos end_pos
              else 
                loop (j+1) lines.(i).[j+1] f edge start_pos end_pos
          |'S'-> if j mod 2=1 && (fst f) = false then 
            if lines.(i).[j+1] = ' ' then
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (true, snd f) (((j,i),(j,i+2))::((j,i),(j+2,i))::edge) (j,i) end_pos
              else loop (j+1) lines.(i).[j+1] (true, snd f) (((j,i),(j+2,i))::edge) (j,i) end_pos
            else 
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (true, snd f) (((j,i),(j,i+2))::edge) (j,i) end_pos
              else 
                loop (j+1) lines.(i).[j+1] (true, snd f) edge (j,i) end_pos
            else failwith "laby non integre"
          |'E'->if j mod 2 = 1 && (snd f) = false then 
            if lines.(i).[j+1] = ' ' then
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (fst f, true) (((j,i),(j,i+2))::((j,i),(j+2,i))::edge) start_pos (j,i)
              else loop (j+1) lines.(i).[j+1] (fst f, true) (((j,i),(j+2,i))::edge) start_pos (j,i)
            else 
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (fst f, true) (((j,i),(j,i+2))::edge)  start_pos (j,i)
              else 
                loop (j+1) lines.(i).[j+1] (fst f, true) edge start_pos (j,i)
            else failwith "laby non integre"
          |_->failwith "laby non integre"
      else 
        (edge, (start_pos, end_pos)) 
    in  
      if i!=(Array.length lines)-1 && i mod 2 = 1 && lines.(i+1).[width-2] = ' ' then
          loop 0 current_char (false,false) (((width-1,i),(width-2,i+2))::[]) s e
      else
      loop 0 current_char (false,false) [] s e
;;

let check_laby string_array=
  let rec check_laby_h edge i start en=
    if i<(Array.length string_array)-1 then
      let (edgi , (si ,ei)) = check_line i string_array.(i).[0] string_array start en in
      check_laby_h (edgi@edge) (i+1) si ei
    else 
      (edge , (start, en))
    in
    let (edg , (st, en)) = check_laby_h [] 0 (-1,-1) (-1,-1) in
    let normalise = (fun ((x,y),(w,z))->((x-1)/2,(y-1)/2),((w-1)/2,(z-1)/2)) in
    ((List.map normalise edg) , normalise (st , en) )
;;


let construct_laby f =
  let lines= read_file_lines f in
  let (edges , (s ,e)) = check_laby lines in
  let n = ((Array.length lines - 1)/2 ) in
  let m = (((String.length lines.(0))- 1)/2) in
  if s = (-1,-1) || e = (-1,-1) then failwith "Départ ou arrivé non assigné."
  else
  Laby.cree_laby n m s e (Grid.cree_grid n m edges)

;; 

let ()=
  let str="test/maze_100x100.laby" in
  let l = construct_laby str in
  Laby.print_laby l
