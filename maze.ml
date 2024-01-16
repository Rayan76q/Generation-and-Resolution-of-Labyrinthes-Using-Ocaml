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
      |"3" -> Laby.print_laby (fst (Laby.resolve_with_path laby)); choose_option ()
      |"4" ->  Printf.printf "Entrez la taille d'une case (en px): " ;
      let s = read_int () in
        let (solved , path) = Laby.resolve_with_path laby in 
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
      let laby = Laby.generate_random_laby_fusion (fst len_width) (snd len_width) (snd dep_arrive) (fst dep_arrive) in
      print_options ();
      action laby
  |"3" ->
      Printf.printf "Entrez les coordonnes de depart et arrive (e.g., 1 1 5 5):\n";
      let dep_arrive = ((read_int () , read_int ()) , (read_int (),read_int ())) in
      Printf.printf "Entrez les dimensions du labyrinthe (e.g., 6 6 )\n";
      let len_width =(read_int () , read_int ()) in
      let laby = Laby.generate_random_laby_exploration (fst len_width) (snd len_width) (snd dep_arrive) (fst dep_arrive) in
      print_options ();
      action laby
  |"4" -> Printf.printf "Exiting...\n"
  |_ -> choose_option ()


let grf n m seed = 
  Random.init seed ;
  Laby.generate_random_laby_fusion n m (Random.int m,Random.int n) (Random.int m,Random.int n)

let gre n m seed = 
    Random.init seed ;
    Laby.generate_random_laby_exploration n m (Random.int m,Random.int n) (Random.int m,Random.int n)


let display_help () = 
  Printf.printf {|Manuel d'aide: 
  -Les commandes sont de la forme: ./maze.exe <command> --(option cmd) --(option d'affichage) [liste de parametres obligatoire] 

  Si aucune commande n'est spécifié un menu interactif sera lancé.

  Dans ce qui suit, src désigne un chemin vers un fichier valide.

  Les commandes: 
      --help : Affiche le manuel.
      1)print : Affiche un labyrinthe à partir d'un fichier 

        syn: print --option src

        options (similaire à option2 pour les autres commandes): 
                  --simple : (par défault) affiche dans le terminale.
                  --html : affiche dans le terminale le doc html associé au fichier à rediriger avec > vers un fichier
      
      2)random : Générer un Labyrinthe random en utilisant l'algo spécifié dans option1 avec l'afichage d'option2.

        syn: random --option1 --option2 longueur largeur seed

          option1: --fusion: (Par défault) utilise l'algorithme fusion.
                   --exploration: utilise l'algorithme d'explroation.
          option2: --simple et --html  

      3)solve : resoud un labyrinthe contenu dans un fichier passé en parametres avec l'algorithme spécifié.

        syn: solve --option1 --option2 src

          option1: --exploration: (Par défault) utilise l'algorithme d'explroation.
                   --pledge (main droite): utilise l'algorithme.
          option2: --simple et --html  
          
          note: l'affichage html utilise l'algorthime d'exploration 
            la commande: solve --pledge --html est donc invalide.
  |}

let main ()=
    match Array.to_list Sys.argv with
    [_ ; "--help"] -> display_help ()
    | [_ ; "print" ; fichier]  | [_ ; "print" ;"--simple";fichier] -> Laby.print_laby (Laby.construct_laby fichier)
    | [_ ; "print" ; "--html" ; fichier] -> Printf.printf "%s" (Gui.generate_html (Laby.construct_laby fichier) [] 25)
    | [_ ; "random"; n ; m ; seed] | [_ ; "random"; "--fusion" ; n ; m ; seed] | [_ ; "random"; "--fusion" ; "simple"; n ; m ; seed] | [_ ; "random"; "--simple" ; n ; m ; seed]  ->  Laby.print_laby (grf (int_of_string(n)) (int_of_string(m)) (int_of_string(seed)))
    | [_ ; "random"; "--exploration" ;  n ; m ; seed] | [_ ; "random"; "--exploration" ;"--simple";  n ; m ; seed] -> Laby.print_laby (grf (int_of_string(n)) (int_of_string(m)) (int_of_string(seed)))
    | [_ ; "random"; "--html" ;n ; m ; seed] | [_ ; "random";"--fusion" ;"--html"; n ; m ; seed] ->  Printf.printf "%s" (Gui.generate_html (grf (int_of_string(n)) (int_of_string(m)) (int_of_string(seed))) [] 25)
    | [_ ; "random"; "--exploration" ; "--html"; n ; m ; seed] ->  Printf.printf "%s" (Gui.generate_html (gre (int_of_string(n)) (int_of_string(m)) (int_of_string(seed))) [] 25)
    | [_ ; "solve" ; fichier] | [_ ; "solve"; "--exploration" ; fichier] | [_ ; "solve"; "--exploration" ; "--simple"; fichier] -> Laby.print_laby (fst (Laby.resolve_with_path (Laby.construct_laby fichier)))
    | [_ ; "solve"; "--pledge" ; fichier] | [_ ; "solve"; "--pledge" ;"--simple"; fichier]-> Laby.print_laby (Laby.algo_main_droite (Laby.construct_laby fichier))
    | [_ ; "solve" ;"--html"; fichier] | [_ ; "solve"; "--exploration"; "--html"; fichier] -> let (laby,path) =(Laby.resolve_with_path (Laby.construct_laby fichier)) in
                                                                                      Printf.printf "%s" (Gui.generate_html laby path 25)
    | [_] -> choose_option()
    | _ -> Printf.printf "Commande non reconnu. Utiliser --help pour plus d'informations."


let () = main ()