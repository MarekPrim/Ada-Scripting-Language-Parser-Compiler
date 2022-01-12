with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling,ADA.IO_EXCEPTIONS;
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
Fe : File_Type; -- Fichier
begin

instructions := creer_liste_vide;
search := creer_liste_vide;
variables := creer_liste_vide;
        --Put_Line("Entrée dans le test");
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
    Put_Line(variables.all.ptrVar.all.nomVariable.str(1..3));
    -- variables = tête de la liste
        if(variables.all.ptrVar.all.nomVariable.str(1..3) = "Sum") then
            Put_Line("OK recuperationVariables");
        else
            Put_Line("KO recuperationVariables");
        end if;


        if(variables.all.ptrVar.all.typeVariable.str(1..6) = "Entier") then
            Put_Line("OK recuperationType");
        else
            Put_Line("KO recuperationType");
        end if;

        if(variables.all.prev.all.ptrVar.all.nomVariable.str(1) = 'i') then
            Put_Line("OK recuperationNom");
        else
            Put_Line("KO recuperationNom");
        end if;

        if(variables.all.prev.all.prev.all.ptrVar.all.nomVariable.str(1) = 'n') then
            Put_Line("OK recuperationNom");
        else
            Put_Line("KO recuperationNom");
        end if;

        begin
            variables_stub := creer_liste_vide;
                Open (F, In_File, fileNameSansVariable);
            loop
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
                
            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
            end loop;

            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
            if (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut))) then
                    raise Aucune_Variable_Definie;
            end if;
            loop
                recupererVariables(variables_stub, ligne);
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
            end loop;
            --loop
                
                --recupererInstructions(instructions, ligne);
            
            --    ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

            --exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Fin)));
            --end loop;
            
            Close(F);
            exception
                when Aucune_Variable_Definie => Put_Line("OK exception Pas de variable définie");
                when ADA.STRINGS.INDEX_ERROR => Put_Line("Levée d'exception prévisible");
                when others => Put_Line("KO");
        end;
        Close(F);
        
        
        begin
            variables_stub := creer_liste_vide;
            Open(Fe, In_File, fileNameDeuxDeclarations);
            loop
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(fe));
            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
            end loop;

            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(fe));

            loop

                recupererVariables(variables_stub, ligne);
            
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(fe));

            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
            end loop;
            Close(Fe);
            exception
                when Variable_Deja_Definie => 
                    Put_Line("OK exception deux fois même déclaration");
                    
                when ADA.STRINGS.INDEX_ERROR => Put_Line("Levée d'exception prévisible");
                when others => Put_Line("KO");
        end;
        
        begin
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
                when ADA.STRINGS.INDEX_ERROR => Put_Line("Levée d'exception prévisible");
                when ADA.IO_EXCEPTIONS.NAME_ERROR => raise Fichier_Non_Trouve;
            end;
            exception
                when Fichier_Non_Trouve => Put_Line("OK exception fichier non trouve");
                --when others => Put_Line("KOee");
        end;
        
    -- Test de la recherche d'une variable
        search := rechercherVariable(variables, "Sum");
        if(search /= null) then
            if(search.all.ptrVar.all.nomVariable.str(1..3) = "Sum") then
                Put_Line("OK rechercheVariable");
            else
                Put_Line("KO rechercheVariable");
            end if;
        else
            Put_Line("KO rechercheVariable pas trouvé");
        end if;

        begin -- Recherche d'une variable inexistante
            search := rechercherVariable(variables,"xyz");

            exception
                when Variable_Non_Trouvee => Put_Line("OK exception variable non trouvee");
        end;

    -- Test de l'initialisation des instructions
        if(instructions.all.ptrIns.all.operation.str(1..2) = "<-") then
            Put_Line("OK initialisation instructions");
        else
            Put_Line("KO initialisation instructions");
        end if;
        if(instructions.all.ptrIns.all.operandes.x.all.valeurVariable = 5) then
            Put_Line("OK initialisation instructions");
        else
            Put_Line("KO initialisation instructions");
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