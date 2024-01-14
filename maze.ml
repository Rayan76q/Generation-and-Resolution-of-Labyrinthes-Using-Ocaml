
let rec choose_option () =
  Printf.printf "Choose an option:\n";
  Printf.printf "1: Read a laby file\n";
  Printf.printf "2: Generate a random laby (fusion)\n";
  Printf.printf "3: Generate a random laby (exploration)\n";
  Printf.printf "4: Quit\n";
  Printf.printf "> ";
  let option = read_int () in
  match option with
  |1 ->
    Printf.printf "Options for the reading the laby's:\n";
    Printf.printf "1: maze_2x1\n";
    Printf.printf "2: maze_3x2\n";
    Printf.printf "3: maze_4x8\n";
    Printf.printf "4: maze_6x6 \n";
    Printf.printf "5: maze_100x100 \n";
    Printf.printf "> ";
    let laby_option = read_int () in
    match string_option with
    |1 -> "test/maze_2x1.laby"
    |2 -> "test/maze_3x2.laby"
    |3 -> "test/maze_4x8.laby"
    |4 -> "test/maze_6x6.laby"
    |5 -> "test/maze_100x100.laby"
    |_ -> choose_option()
    let laby, lines = Read_laby.read_laby_file string_option in
    Printf.printf "Options for the laby:\n";
    Printf.printf "1: Print laby\n";
    Printf.printf "2: Solve and print laby\n";
    Printf.printf "3: Back to main menu\n";
    Printf.printf "> ";
    let laby_option = read_int () in
    match laby_option with
    |1 -> Laby.print_laby laby; choose_option ()
    |2 -> Laby.resolve_cours laby; Laby.print_laby laby; choose_option ()
    |_ -> choose_option ()
  |2 ->
    Printf.printf "Enter depart and arrive coordinates (e.g., 1 1 5 5): ";
    let dep_arrive = Scanf.scanf "%d %d %d %d" (fun d1 d2 a1 a2 -> (d1, d2),( a1, a2)) in
    Printf.printf "Enter length and width coordinates (e.g., 2 3)";
    let len_width =Scanf.scanf "%d %d" (fun l w-> (l, w)) in
    let laby = Laby.generate_random_laby_fusion (fst len_width) (snd len_width) (fst dep_arrive) (snd dep_arrive) in
    Printf.printf "Options for the laby:\n";
    Printf.printf "1: Print laby\n";
    Printf.printf "2: Solve and print laby\n";
    Printf.printf "3: Back to main menu\n";
    Printf.printf "> ";
    let laby_option = read_int () in
    match laby_option with
    |1 -> Laby.print_laby laby; choose_option ()
    |2 -> Laby.resolve_cours laby; Laby.print_laby laby; choose_option ()
    |_ -> choose_option ()
  |3 ->
    Printf.printf "Enter depart and arrive coordinates (e.g., 1 1 5 5): ";
    let dep_arrive = Scanf.scanf "%d %d %d %d" (fun d1 d2 a1 a2 -> (d1, d2),( a1, a2)) in
    Printf.printf "Enter length and width coordinates (e.g., 2 3)";
    let len_width =Scanf.scanf "%d %d" (fun l w-> (l, w)) in
    let laby = Laby.generate_random_laby_exploration (fst len_width) (snd len_width) (fst dep_arrive) (snd dep_arrive)
    Printf.printf "Options for the laby:\n";
    Printf.printf "1: Print laby\n";
    Printf.printf "2: Solve and print laby\n";
    Printf.printf "3: Back to main menu\n";
    Printf.printf "> ";
    let laby_option = read_int () in
    match laby_option with
    |1 -> Laby.print_laby laby; choose_option ()
    |2 -> Laby.resolve_cours laby; Laby.print_laby laby; choose_option ()
    |_ -> choose_option ()
  |4 -> Printf.printf "Exiting...\n"
  |_ -> choose_option ()

let () = choose_option ()