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
instructions_stub : T_List_Instruction; -- Liste des instructions temporaire
F : File_Type; -- Fichier
Fe : File_Type; -- Fichier

chne : Chaine;
begin

instructions := creer_liste_vide;
search := creer_liste_vide;
variables := creer_liste_vide;
    parseFile(fileName, variables, instructions, false);
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
            instructions_stub := creer_liste_vide;
            parseFile(fileNameSansVariable, variables_stub, instructions_stub,   false);
            exception
                when Aucune_Variable_Definie => Put_Line("OK exception Pas de variable définie");
                when ADA.STRINGS.INDEX_ERROR => Put_Line("Levée d'exception prévisible");
                when others => Put_Line("KO");
        end;
        
        
        begin
            variables_stub := creer_liste_vide;
            instructions_stub := creer_liste_vide;
            parseFile(fileNameSansType, variables_stub, instructions_stub ,  false);
            exception
                when Variable_Deja_Definie => 
                    Put_Line("OK exception deux fois même déclaration");
                    
                when ADA.STRINGS.INDEX_ERROR => Put_Line("Levée d'exception prévisible");
                when others => Put_Line("KO");
        end;
        
        begin
            begin
            variables_stub := creer_liste_vide;
            instructions_stub := creer_liste_vide;
            parseFile("ce_fichier_n_existe_pas.med", variables_stub, instructions_stub ,   false);
            exception
                when ADA.STRINGS.INDEX_ERROR => Put_Line("Levée d'exception prévisible");
                when ADA.IO_EXCEPTIONS.NAME_ERROR => raise Fichier_Non_Trouve;
            end;
            exception
                when Fichier_Non_Trouve => Put_Line("OK exception fichier non trouve");
                --when others => Put_Line("KOee");
        end;
        
    -- Test de la recherche d'une variable
        chne.nbCharsEffectif := 3;
        chne.str(1..3) := "Sum";
        search := rechercherVariable(variables, chne);
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
            chne.nbCharsEffectif := 3;
            chne.str(1..3) := "xyz";
            search := rechercherVariable(variables,chne);

            exception
                when Variable_Non_Trouvee => Put_Line("OK exception variable non trouvee");
        end;

    -- Test de l'initialisation des instructions

        while(instructions.prev /= null) loop
            instructions := instructions.prev;
        end loop;
        afficher_liste(instructions);
        if(instructions.all.ptrIns.all.operation.str(1..instructions.all.ptrIns.all.operation.nbCharsEffectif) = "AFFECTATION") then
            Put_Line("OK initialisation instructions");
        else
            Put_Line("KO initialisation instructions");
        end if;
        if(instructions.all.ptrIns.all.operandes.z.all.nomVariable.str(1) = 'n') then
            Put_Line("OK valeur variable");
        else
            Put_Line("KO valeur variable");
        end if;

        if(instructions.all.ptrIns.all.numInstruction = 1) then
            Put_Line("OK numero instruction");
        else
            Put_Line("KO numero instruction");
        end if;
        
        --afficher_liste(instructions);
        if(instructions.all.next.all.ptrIns.all.numInstruction = 2) then
            Put_Line("OK numero instruction");
        else
            Put_Line("KO numero instruction");
        end if;

        instructions := instructions.all.next;

        if(instructions.all.prev.all.ptrIns.all.numInstruction = 1) then
            Put_Line("OK numero instruction");
        else
            Put_Line("KO numero instruction");
        end if;

        instructions := instructions.all.prev;

       

    -- Test de l'interprétation d'une commande/ligne d'instruction
        interpreterCommande(instructions, variables);
        chne.nbCharsEffectif := 1;
        chne.str(1) := 'n';
        if(rechercherVariable(variables,chne).all.ptrVar.all.valeurVariable = 5) then
            Put_Line("OK interpreterCommande");
        else
            Put_Line("KO interpreterCommande");
        end if;

        chne.str(1) := 'i';
        if(rechercherVariable(variables,chne).all.ptrVar.all.valeurVariable = 1) then
            Put_Line("OK interpreterCommande");
        else
            Put_Line("KO interpreterCommande");
        end if;

        chne.nbCharsEffectif := 3;
        chne.str(1..3) := "Sum";
        if(rechercherVariable(variables,chne).all.ptrVar.all.valeurVariable = 6) then
            Put_Line("OK interpreterCommande");
        else
            Put_Line("KO interpreterCommande");
        end if;

        


    

end test_intermediaire;