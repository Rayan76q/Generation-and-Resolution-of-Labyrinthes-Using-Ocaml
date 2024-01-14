

let rec choose_option () =
  Printf.printf "Choose an option:\n";
  Printf.printf "1: Read a laby file\n";
  Printf.printf "2: Generate un Laby random (fusion)\n";
  Printf.printf "3: Generate un Laby random (exploration)\n";
  Printf.printf "4: Exit\n";
  Printf.printf "> ";
  let option = read_line () in
  match option with
  (*  //NEEDS READ_LABY
  |1 ->
      Printf.printf "Options for the reading the laby's:\n";
      Printf.printf "1: maze_2x1\n";
      Printf.printf "2: maze_3x2\n";
      Printf.printf "3: maze_4x8\n";
      Printf.printf "4: maze_6x6 \n";
      Printf.printf "5: maze_100x100 \n";
      Printf.printf "> ";
      let laby_option = read_int () in
      let string_option = 
      match laby_option with
      |1 -> "test/maze_2x1.laby"
      |2 -> "test/maze_3x2.laby"
      |3 -> "test/maze_4x8.laby"
      |4 -> "test/maze_6x6.laby"
      |5 -> "test/maze_100x100.laby"
      |_ -> choose_option()
      in
      let (laby, lines) = Read_laby.read_laby_file string_option in
      Printf.printf "Options for the laby:\n";
      Printf.printf "1: Print laby\n";
      Printf.printf "2: Solve and print laby\n";
      Printf.printf "3: Back to main menu\n";
      Printf.printf "> ";
      let laby_option = read_int () in
      match laby_option with
      |1 -> Laby.print_laby laby; choose_option ()
      |2 -> Laby.print_laby (Laby.resolve_cours laby); choose_option ()
      |_ -> choose_option ()
  *)
  "2" ->
      Printf.printf "Entrez les coordonnes de depart et arrive (e.g., 1 1 5 5): \n";
      let dep_arrive = ((read_int () , read_int ()) , (read_int (),read_int ())) in
      Printf.printf "Entrez les dimensions du labyrinthe (e.g., 6 6 )\n";
      let len_width =(read_int () , read_int ()) in
      let laby = Laby.generate_random_laby_fusion (fst len_width) (snd len_width) (fst dep_arrive) (snd dep_arrive) in
      Printf.printf "Options:\n";
      Printf.printf "1: Print laby\n";
      Printf.printf "2: Solve et print laby (simple)\n";
      Printf.printf "3: Solve et print laby (html)\n";
      Printf.printf "Any: Back \n";
      Printf.printf "> ";
      let laby_option = read_line () in
        let action = match laby_option with
        |"1" -> Laby.print_laby laby; choose_option ()
        |"2" -> Laby.print_laby (Laby.resolve_cours laby); choose_option ()
        |"3" ->  Printf.printf "Entrez la taille d'une case (en px): " ;
        let s = read_int () in
          let oc = open_out "random_laby.html" in
                Printf.fprintf oc "%s" (Gui.generate_html laby s);
                close_out oc;
                let status = Sys.command "firefox random_laby.html" in if status = 1 then 
                  begin Printf.printf "Erreur lors de l'execution du navigateur.\n" ; choose_option () end else choose_option ()
        |_ -> choose_option ()
      in action
  |"3" ->
      Printf.printf "Entrez les coordonnes de depart et arrive (e.g., 1 1 5 5):\n";
      let dep_arrive = ((read_int () , read_int ()) , (read_int (),read_int ())) in
      Printf.printf "Entrez les dimensions du labyrinthe (e.g., 6 6 )\n";
      let len_width =(read_int () , read_int ()) in
      let laby = Laby.generate_random_laby_exploration (fst len_width) (snd len_width) (fst dep_arrive) (snd dep_arrive) in
      Printf.printf "Options:\n";
      Printf.printf "1: Print laby\n";
      Printf.printf "2: Solve et print laby\n";
      Printf.printf "3: Solve et print laby (html)\n";
      Printf.printf "Any: Back \n";
      Printf.printf "> ";
      let laby_option = read_line () in
      let action = match laby_option with
      |"1" -> Laby.print_laby laby; choose_option ()
      |"2" -> Laby.print_laby (Laby.resolve_cours laby); choose_option ()
      |"3" ->   Printf.printf "Entrez la taille d'une case (en px): " ;
        let s = read_int () in
        let oc = open_out "random_laby.html" in
                Printf.fprintf oc "%s" (Gui.generate_html laby s);
                close_out oc;
                let status = Sys.command "firefox random_laby.html" in if status = 1 then 
                  begin Printf.printf "Erreur lors de l'execution du navigateur.\n" ; choose_option () end else choose_option ()
      |_ -> choose_option ()
      in action
  |"4" -> Printf.printf "Exiting...\n"
  |_ -> choose_option ()

(*
  let main =
    match Array.to_list Sys.argv with
    [_ ; -"--help"] -> display_help ()
    | [_ ; "print" ; fichier] | | [_ ; "print" ;"--simple";fichier] -> 
    | [_ ; "print" ; "--html" ; fichier] -> 
    | [_ ; "random"; n ; m ; seed] | [_ ; "random"; "--fusion" ; n ; m ; seed] -> 
    | [_ ; "random"; "--exploration" ;  n ; m ; seed] ->   
    | [_ ; "solve" ; fichier] | [_ ; "solve"; "--exploration" ; fichier] ->
    | [_ ; "solve"; "--pledge" ; fichier] ->
    | [_] -> choose_option()
    | _ -> Printf.printf "Command not recognized."
*)


let () = choose_option ()
