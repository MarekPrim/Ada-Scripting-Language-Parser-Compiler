with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with intermediaire; use intermediaire;

procedure test_intermediaire is


fileName : constant string := "code_test.med";
fileNameSansVariable : constant string := "code_exception_no_variable.med";
fileNameSansType : constant string := "code_exception_no_type.med";
fileNameDeuxDeclarations : constant string := "code_exception_two_declaration.med";
line : ptrLigne;
variables : T_List_Variable;
variables_stub : T_List_Variable;
search : T_List_Variable;
instructions : T_List_Instruction; 

begin

instructions := creer_liste_vide;
search := new variable;
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

        if(variables.all.ptrVar.all.nomVariable.str = "entier") then
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

            loop
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
            end loop;

            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

            loop

                recupererVariables(variables_stub, ligne);
            
                ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

            exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
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
                when Variable_Non_Trouvée => Put_Line("OK");
        end;

    -- Test de l'initialisation des instructions

        if(line.all.ptrInst.all.operation = "<-") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        if(line.all.ptrIns.all.operandes[1] = "5") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        if(line.all.ptrIns.all.operandes[0] = "n") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(line.all.ptrIns.all.numInstruction = 1) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        
        if(line.all.next.all.ptrIns.all.numInstruction = 2) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        line := line.all.next;

        if(line.all.prev.all.ptrIns.all.operandes[1] = "5") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        if(line.all.prev.all.ptrIns.all.numInstruction = 1) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        line := line.all.prev;

       

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