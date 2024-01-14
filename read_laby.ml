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
      rev_and_count acc [] 0
  in
  read_lines []
;;
(* 
let construct_laby fileread =
  let big_M3 = read_file_names fileread in
  let lengthlab=length_laby (fst big_M3) in
  
;; 
*)
let str="test/maze_3x2.laby" in let big_M2 = read_file_lines str in
  List.iter (fun line -> print_endline line) (fst big_M2);
  Printf.printf "%d, %d" (snd big_M2) (length_read_laby (fst big_M2))

