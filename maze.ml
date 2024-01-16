let rec choose_option () =
  Printf.printf "Choose an option:\n";
  Printf.printf "1: Read a laby file\n";
  Printf.printf "2: Generate un Laby random (fusion)\n";
  Printf.printf "3: Generate un Laby random (exploration)\n";
  Printf.printf "4: Exit\n";
  Printf.printf "> ";

    let print_options () = 
      Printf.printf "Options for the laby:\n";
      Printf.printf "1: Print laby (simple)\n";
      Printf.printf "2: Print laby (html)\n";
      Printf.printf "3: Solve et print laby (simple)\n";
      Printf.printf "4: Solve et print laby (html)\n";
      Printf.printf "Any: Back to main menu\n";
      Printf.printf "> "
    in

    let action laby=
      let laby_option = read_line () in
      let ac = 
      match laby_option with
      "1" -> Laby.print_laby laby; choose_option ()
      |"2" -> Printf.printf "Entrez la taille d'une case (en px): " ;
      let s = read_int () in
        let oc = open_out "random_laby.html" in
              Printf.fprintf oc "%s" (Gui.generate_html laby [] s);
              close_out oc;
              let status = Sys.command "firefox random_laby.html" in if status = 1 then 
                begin Printf.printf "Erreur lors de l'execution du navigateur.\n" ; choose_option () end else choose_option ()
      |"3" -> Laby.print_laby (fst (Laby.resolve_cours laby)); choose_option ()
      |"4" ->  Printf.printf "Entrez la taille d'une case (en px): " ;
      let s = read_int () in
        let (solved , path) = Laby.resolve_cours laby in 
        let oc = open_out "random_laby.html" in
              Printf.fprintf oc "%s" (Gui.generate_html solved path s);
              close_out oc;
              let status = Sys.command "firefox random_laby.html" in if status = 1 then 
                begin Printf.printf "Erreur lors de l'execution du navigateur.\n" ; choose_option () end else choose_option ()
      |_ -> choose_option ()
      in ac
    in

  
  let option = read_line () in
  match option with
  "1" ->
      Printf.printf "Write path to the file:\n";
      Printf.printf "> ";
      let file_name = read_line () in
      let laby = Laby.construct_laby file_name in
      print_options ();
      action laby
  |"2" ->
      Printf.printf "Entrez les coordonnes de depart et arrive (e.g., 1 1 5 5): \n";
      let dep_arrive = ((read_int () , read_int ()) , (read_int (),read_int ())) in
      Printf.printf "Entrez les dimensions du labyrinthe (e.g., 6 6 )\n";
      let len_width =(read_int () , read_int ()) in
      let laby = Laby.generate_random_laby_fusion (fst len_width) (snd len_width) (fst dep_arrive) (snd dep_arrive) in
      print_options ();
      action laby
  |"3" ->
      Printf.printf "Entrez les coordonnes de depart et arrive (e.g., 1 1 5 5):\n";
      let dep_arrive = ((read_int () , read_int ()) , (read_int (),read_int ())) in
      Printf.printf "Entrez les dimensions du labyrinthe (e.g., 6 6 )\n";
      let len_width =(read_int () , read_int ()) in
      let laby = Laby.generate_random_laby_exploration (fst len_width) (snd len_width) (fst dep_arrive) (snd dep_arrive) in
      print_options ();
      action laby
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
