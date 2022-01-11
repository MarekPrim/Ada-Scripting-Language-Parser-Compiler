with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
with intermediaire; use intermediaire;

procedure test_intermediaire is


fileName : constant string := "code_test.med"; -- Fichier de test correctement formé
fileNameSansVariable : constant string := "code_exception_no_variable.med"; -- Fichier de test sans variable
fileNameSansType : constant string := "code_exception_no_type.med"; -- Fichier de test sans type
fileNameDeuxDeclarations : constant string := "code_exception_two_declaration.med"; -- Fichier de test avec deux declarations de la meme variable
ligne : Unbounded_string; -- Variable temporaire pour récupération des lignes du fichier
variables : T_List_Variable;    -- Liste des variables
variables_stub : T_List_Variable;   -- Liste des variables temporaire
search : T_List_Variable;  -- Liste permettant de stocker les retours de la recherche de variable
instructions : T_List_Instruction; -- Liste des instructions
F : File_Type; -- Fichier
begin

instructions := creer_liste_vide;
search := creer_liste_vide;
variables := creer_liste_vide;
        Open (F, In_File, fileName);
        loop
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
        end loop;
        ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
        loop
            recupererVariables(variables, ligne);
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
        end loop;
        loop

            recupererInstructions(instructions, ligne);
        
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Fin)));
        end loop;

        Close(F);

    -- variables = tête de la liste
        if(variables.all.ptrVar.all.nomVariable.str = "n") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;


        if(variables.all.ptrVar.all.typeVariable.str = "entier") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(variables.all.next.all.ptrVar.all.nomVariable.str = "i") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(variables.all.next.all.next.all.ptrVar.all.nomVariable.str = "Sum") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        begin
            variables_stub := creer_liste_vide;

            Open (F, In_File, fileNameSansVariable);

            loop
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
            end loop;

            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

            loop

                recupererVariables(variables_stub, ligne);
            
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
            end loop;
            Close(F);
            exception
                when Aucune_Variable_Definie => Put_Line("OK");
        end;

        begin
            variables_stub := creer_liste_vide;
            Open (F, In_File, fileNameSansType);

            loop
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
            end loop;

            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

            loop

                recupererVariables(variables_stub, ligne);
            
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
            end loop;
            Close(F);
            
            exception
                when Type_Incorrect => Put_Line("OK");
        end;

        begin
            variables_stub := creer_liste_vide;
            Open (F, In_File, fileNameDeuxDeclarations);

            loop
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
            end loop;

            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

            loop

                recupererVariables(variables_stub, ligne);
            
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
            end loop;
            Close(F);
            exception
                when Variable_Deja_Definie => Put_Line("OK");
        end;

        begin
            variables_stub := creer_liste_vide;
            Open (F, In_File, "ce_fichier_n_existe_pas.med");

            loop
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
            end loop;


                loop
                    ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
                exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
                end loop;

                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

                loop

                    recupererVariables(variables_stub, ligne);
                
                    ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

                exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
                end loop;
            
            Close(F);
            exception
                when Fichier_Non_Trouve => Put_Line("OK");
        end;

    -- Test de la recherche d'une variable

        search := rechercherVariable(variables, "Sum");
        if(search /= null) then
            if(search.all.ptrVar.all.nomVariable.str = "Sum") then
                Put_Line("OK");
            else
                Put_Line("KO");
            end if;
        else
            Put_Line("KO");
        end if;

        begin -- Recherche d'une variable inexistante
            search := rechercherVariable(variables,"xyz");

            exception
                when Variable_Non_Trouvee => Put_Line("OK");
        end;

    -- Test de l'initialisation des instructions

        if(instructions.all.ptrIns.all.operation.str(1..2) = "<-") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        if(instructions.all.ptrIns.all.operandes.x.all.valeurVariable = 5) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        if(instructions.all.ptrIns.all.operandes.y.all.nomVariable.str(1) = 'n') then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(instructions.all.ptrIns.all.numInstruction = 1) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        
        if(instructions.all.next.all.ptrIns.all.numInstruction = 2) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        instructions := instructions.all.next;

        if(instructions.all.prev.all.ptrIns.all.operandes.x.all.valeurVariable = 5) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        if(instructions.all.prev.all.ptrIns.all.numInstruction = 1) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        instructions := instructions.all.prev;

       

    -- Test de l'interprétation d'une commande/ligne d'instruction
        interpreterCommande(instructions, variables);

        if(rechercherVariable(variables,"n").all.ptrVar.all.valeurVariable = 5) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(rechercherVariable(variables,"i").all.ptrVar.all.valeurVariable = 1) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(rechercherVariable(variables,"Sum").all.ptrVar.all.valeurVariable = 6) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        


    

end test_intermediaire;