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

let check_line i current_char lines=
  let width = String.length lines.(0) in
    let rec loop j c f edge=
      if j<width-1 then
        if i=0 || i=(Array.length lines)-1 then 
          match c with
          '+'-> if j mod 2=0 then loop (j+1) lines.(i).[j+1] f edge else failwith "laby non integre"
          |'-'-> if j mod 2 =1 then loop (j+1) lines.(i).[j+1] f edge else failwith "laby non integre"
          |_->failwith "laby non integre"
        else
          if i mod 2 = 0 then
            match c with
            '+'-> if j mod 2=0 then loop (j+1) lines.(i).[j+1] f edge else failwith "laby non integre"
            |'-'|' '-> if j mod 2 =1 then loop (j+1) lines.(i).[j+1] f edge else failwith "laby non integre"
            |_->failwith "laby non integre"
          else 
          match c with
          '|'-> if j mod 2=0 then loop (j+1) lines.(i).[j+1] f edge else failwith "laby non integre"
          |' '->
              if j mod 2 = 1 then
                if lines.(i).[j+1] = ' ' then
                  if lines.(i+1).[j] = ' ' then 
                    loop (j+1) lines.(i).[j+1] f (((i,j),(i+2,j))::((i,j),(i,j+2))::edge)
                  else loop (j+1) lines.(i).[j+1] f (((i,j),(i,j+2))::edge)
                else 
                  if lines.(i+1).[j] = ' ' then 
                    loop (j+1) lines.(i).[j+1] f (((i,j),(i+2,j))::edge) 
                  else 
                    loop (j+1) lines.(i).[j+1] f edge
              else 
                loop (j+1) lines.(i).[j+1] f edge
          |'S'->if j mod 2=1 && (fst f) = false then 
            if lines.(i).[j+1] = ' ' then
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (true, snd f) (((i,j),(i+2,j))::((i,j),(i,j+2))::edge)
              else loop (j+1) lines.(i).[j+1] (true, snd f) (((i,j),(i,j+2))::edge)
            else 
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (true, snd f) (((i,j),(i+2,j))::edge) 
              else 
                loop (j+1) lines.(i).[j+1] (true, snd f) edge
            else failwith "laby non integre"
          |'E'->if j mod 2 = 1 && (snd f) = false then 
            if lines.(i).[j+1] = ' ' then
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (fst f, true) (((i,j),(i+2,j))::((i,j),(i,j+2))::edge)
              else loop (j+1) lines.(i).[j+1] (fst f, true) (((i,j),(i,j+2))::edge)
            else 
              if lines.(i+1).[j] = ' ' then 
                loop (j+1) lines.(i).[j+1] (fst f, true) (((i,j),(i+2,j))::edge) 
              else 
                loop (j+1) lines.(i).[j+1] (fst f, true) edge
            else failwith "laby non integre"
          |_->failwith "laby non integre"
      else edge 
    in  
      if i!=(Array.length lines)-1 && i mod 2 = 1 && lines.(i+1).[width-2] = ' ' then
          loop 0 current_char (false,false) (((i,width-1),(i+2,width-2))::[])
      else
      loop 0 current_char (false,false) []
;;

let check_laby string_array=
  let rec check_laby_h edge i=
    if i<(Array.length string_array)-1 then
      let edge1 = check_line i string_array.(i).[0] string_array in
      check_laby_h (edge1@edge) (i+1)
    else 
      edge
    in
    List.map (fun ((x,y),(w,z))->((x-1)/2,(y-1)/2),((w-1)/2,(z-1)/2)) (check_laby_h [] 0)
;;

(* 
let construct_laby fileread =
  let big_M3 = read_file_names fileread in
  let lengthlab=length_laby (fst big_M3) in

;; 
*)
let ()=
  let str="test/maze_6x6.laby" in
  let big_M2 = read_file_lines str in
  let mm= check_laby big_M2 in 
  List.iter (fun (x,y)->Printf.printf "(%d,%d),(%d,%d) \n" (fst x) (snd x) (fst y) (snd y)) mm;
  Array.iter (fun line -> print_endline line; Printf.printf "\n") (big_M2);
