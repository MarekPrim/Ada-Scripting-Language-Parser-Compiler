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
variables : ptrVariable;
variables_stub : ptrVariable;
search : ptrVariable;

begin
variables := new variable;
line := new ligne;
search := new variable;

   -- Test de la récupération des variables

    variables := recupererVariables(fileName); --{variables attendues : n,i,Sum}
    -- variables = tête de la liste
        if(variables.all.identificateur = "n") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(variables.all.type = "entier") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(variables.all.next.all.identificateur = "i") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(variables.all.next.all.next.all.identificateur = "Sum") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        begin
            variables_stub := rechercherVariable(fileNameMalForme);
            exception
                when Aucune_Variable_Definie => Put_Line("OK");
        end;

        begin
            variables_stub := rechercherVariable(fileNameSansType);
            exception
                when Type_Incorrect => Put_Line("OK");
        end;

        begin
            variables_stub := rechercherVariable(fileNameDeuxDeclarations);
            exception
                when Variable_Deja_Definie => Put_Line("OK");
        end;

        begin
            variables_stub := rechercherVariable("ce_fichier_n_existe_pas.med");
            exception
                when Fichier_Non_Trouve => Put_Line("OK");
        end;

    -- Test de la recherche d'une variable

        search := rechercherVariable(variables, "Sum");
        if(search /= null) then
            if(search.all.identificateur = "Sum") then
                Put_Line("OK");
            else
                Put_Line("KO");
            end if;
        else
            Put_Line("KO");
        end if;

        begin
            search := rechercherVariable(variables,"xyz");

            exception
                when Variable_Non_Trouvée => Put_Line("OK");
        end;

    -- Test de l'initialisation des instructions

        line := initialiserInstructions(fileName);
        if(line.all.text = "n <- 5") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        if(line.all.numLigne = 1) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        if(line.all.next.all.numLigne = 2) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        line := line.all.next;

        if(line.all.prev.all.text = "n <- 5") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
        if(line.all.prev.numLigne = 1) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        line := line.all.prev;

       

    -- Test de l'interprétation d'une commande/ligne d'instruction
        interpreterCommande(line, variables);

        if(rechercherVariable(variables,"n").all.valeur = 5) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(rechercherVariable(variables,"i").all.valeur = 1) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        if(rechercherVariable(variables,"Sum").all.valeur = 6) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        


    -- Test des fonctions utilitaires pour les listes
        pointerEnTeteVariables(variables);
        if(variables.all.identificateur = "n") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        pointerEnTeteLignes(line);
        if(line.all.text = "n <- 5") then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;
end test_intermediaire;