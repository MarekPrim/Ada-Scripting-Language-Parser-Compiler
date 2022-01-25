with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, operateurs, operations, variables, operations_liste, manipulation_chaine;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, operateurs, operations, variables, operations_liste, manipulation_chaine;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.IO_EXCEPTIONS; use Ada.IO_EXCEPTIONS;

package body intermediaire is

    --package Liste_Variables is new P_List_Double(pointeur => T_List_Variable);
    --use Liste_Variables;
    --package Liste_Instructions is new P_List_Double(pointeur => T_List_Instruction);
    --use Liste_Instructions;

    procedure traiterProgramme is

        variables : T_List_Variable;
        instructions : T_List_Instruction;
        l_instructions : T_List_Instruction;
        choice : Integer;
        fileName : Unbounded_String;
    
    begin

        begin
            loop
                fileName := To_Unbounded_String(Argument(1));
            exit when (Argument_Count /= 0);
            end loop;

            exception
            when Constraint_Error => Put_Line("Vous n'avez pas renseigné le fichier à interpréter;");
            Put_Line("Utilisation du programme : ./main ./chemin_vers_fichier/fichier_souhaité");
            raise Program_Error;
        end;
        
        if(Argument_Count = 2) then
            choice := (if Argument(2) = "--DEBUG"
            then 1
            else 0);
        else
            choice := 0;
        end if;

        skip_line;

        begin
            parseFile(To_String(fileName), variables, instructions);

            exception
            when Ada.IO_EXCEPTIONS.DEVICE_ERROR => Put_Line("Fichier inexistant/invalide");
        end;

        pointerEnTeteInstructions(instructions);

        l_instructions := instructions;

        while(l_instructions /= null) loop
            if(choice = 1 and l_instructions.next /= null) then
                Put("Numéro de l'instruction en cours : ");
                Put(l_instructions.all.ptrIns.all.numInstruction, 1);
                new_line;
            end if;
            interpreterCommande(l_instructions, variables);
        end loop;

        afficher_liste(instructions);
        Put_Line("Etat des variables en terminaison du programme");
        afficher_liste(variables);

    end traiterProgramme;

    -- private
    -- Les sous-programmes suivant ne sont pas déclarés private afin de pouvoir toujours réaliser des tests unitaires
    -- Dans une situation de mise en production, les autres sous-programmes devraient être déclarés private

    procedure parseFile (fileName : in string; variables : in out T_List_Variable; instructions : in out T_List_Instruction) is
        F         : File_Type;
        ligne : Unbounded_string;
    begin
    
        variables := creer_liste_vide;

        instructions := creer_liste_vide;

        Open (F, In_File, fileName);    -- Ouverture du fichier en lecture

        loop
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));     -- Lecture de la ligne courante sans espace
        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));  -- Tant que la ligne ne commence par un mot réservé
        end loop;

        loop
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f)); -- Lecture de la ligne courante sans espace
        exit when estLigneUtile(ligne);
        end loop;

        if (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut))) then -- Si la ligne commence par un mot réservé
            raise Aucune_Variable_Definie;  -- On lève une exception car cela indique qu'il n'y a pas de variable
        end if;

        loop
            if (estLigneUtile(ligne)) then  -- Si la ligne est utile (ie. pas un commentaire )
                recupererVariables(variables, ligne);   -- Récupération des variables
            end if;
        
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f)); -- Lecture de la ligne courante sans espace

        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut))); -- Jusqu'à arriver à 'Debut'
        end loop;

        ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        loop
            if (estLigneUtile(ligne)) then
                recupererInstructions(instructions, variables, ligne);  -- Récupération des instructions
            end if;

            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Fin)));    -- Jusqu'à arriver à 'Fin'
        end loop;

        Close(F);

    end parseFile;

    procedure recupererVariables(variables : in out T_List_Variable; ligne : in Unbounded_string) is
        
        i : integer; 
        typeVariable : Unbounded_String;
        nomVariable : Unbounded_String;
        nomVariableTableau : Unbounded_String;
        isArray : boolean;
        nbElementsTableau : Unbounded_String;

    begin

        i := 1;
        -- Parcourir la ligne jusqu'à trouver la déclaration de type
        while(element(ligne, i) /= ':') loop
            i := i+1;
        end loop;
        i := i+1;
        -- Récupérer le type de la variable
        isArray := element(ligne, i) = '[';
        if (isArray) then
            i := i+1;
        end if;
        recupererChaine(typeVariable, ligne, i, 2);
        if (isArray) then
            i := i+1;
            recupererChaine(nbElementsTableau, ligne, i, 1);
        end if;
        i := 1;
        while(i <= length(ligne) and element(ligne, i) /= ':') loop
            -- Parcourir la ligne pour trouver le nom de la variable
            if (element(ligne, i) /= ',') then
                recupererChaine(nomVariable, ligne, i, 3);
                if (isArray) then
                    for i in 1..Integer'value(to_string(nbElementsTableau)) loop
                        nomVariableTableau := nomVariable;
                        append(nomVariableTableau,'[' & Integer'Image(i)(2..Integer'Image(i)'length) &']');
                        creerEtAjouterVariable(variables, typeVariable, nomVariableTableau);
                    end loop;
                else
                    creerEtAjouterVariable(variables, typeVariable, nomVariable);
                end if;
                nomVariable := To_Unbounded_String("");
            else
                i := i+1;
            end if;
        end loop;

    end recupererVariables;
    

    function recupererNumeroInstructionLigne (index : in out integer; ligne : in Unbounded_String) return integer is
        numInstruction : Unbounded_String;
    begin

        while (Character'POS(element(ligne, index)) in 48..57) loop
            append(numInstruction, element(ligne, index));
            index := index+1;
        end loop;

        return Integer'Value(To_String(numInstruction));

    end recupererNumeroInstructionLigne;

    procedure recupererInstructions(instructions : in out T_List_Instruction; variables : in out T_List_Variable; ligne : in Unbounded_string) is
     
        i : integer;
        nomVariableZ : Unbounded_String;
        nomVariableX : Unbounded_String;
        typeVariableZ : Unbounded_String;
        nomVariableY : Unbounded_String;
        operation : Unbounded_String;
        ptrInstruction : T_Ptr_Instruction; 
        isCaractere : boolean := false;

    begin

        ptrInstruction := new T_Instruction;

        -- recuperation du numero de l'instruction
        i := 1;
        ptrInstruction.all.numInstruction := recupererNumeroInstructionLigne(i,ligne);

        if (i <= length(ligne)-1 and then Slice(ligne, i, i+1) = "IF") then

            ifOperation(ligne, i, ptrInstruction, operation, variables);

        elsif (i <= length(ligne)-3 and then Slice(ligne, i, i+3) = "GOTO") then

            gotoOperation(ligne, i, ptrInstruction, operation, variables);

        elsif (i <= length(ligne)-3 and then Slice(ligne, i, i+3) = "NULL") then
            
            nullOperation(operation);

        elsif (i <= length(ligne)-5 and then Slice(ligne, i, i+5) = "Ecrire") then
            
            ecrireOperation(ligne, i, ptrInstruction, operation, variables);

        elsif (i <= length(ligne)-3 and then Slice(ligne, i, i+3) = "Lire") then

            lireOperation(ligne, i, ptrInstruction, operation, variables);

        else

            affectationOperation(ligne, i, ptrInstruction, operation, variables);

        end if;

        ptrInstruction.all.operation := operation;
        ajouter(instructions, ptrInstruction);

    end recupererInstructions;


    procedure interpreterCommande (ptrInstruction : in out T_List_Instruction; variables : in T_List_Variable) is
        
        nomOperation : Unbounded_String;

        nomVariable : Unbounded_String;
        nomIndice : Unbounded_String;
        nomIndiceReel : Unbounded_String;
        valeurIndice : Integer;
        op : character;
        op2 : integer;
        indiceDebutRecherche : integer;
        chaineLue : Unbounded_String;
        Variable : T_Ptr_Variable;
    
    begin

        nomOperation := ptrInstruction.all.ptrIns.all.operation;

        if(nomOperation = "NULL") then
            ptrInstruction := ptrInstruction.all.next;
        elsif(nomOperation = "GOTO") then
            branchementBasic(ptrInstruction.all.ptrIns.all.operandes.z.all.valeurVariable,ptrInstruction);
        elsif(nomOperation = "IF") then
            branchementConditionel(ptrInstruction, variables);
        elsif(nomOperation = "ECRIRE") then
            ecrire(ptrInstruction, variables);
        elsif(nomOperation = "LIRE") then
            lire(ptrInstruction, variables);
            ptrInstruction := ptrInstruction.all.next;
        else
            if (ptrInstruction.all.ptrIns.all.operandes.y = null) then
                ptrInstruction.all.ptrIns.all.operandes.z.all.valeurVariable := ptrInstruction.all.ptrIns.all.operandes.x.all.valeurVariable;
            else

                if (ptrInstruction.all.ptrIns.all.operandes.x.all.typeVariable = "Indice Tableau") then
                    
                    indiceDebutRecherche := 1;

                    nomIndice := ptrInstruction.all.ptrIns.all.operandes.x.all.nomVariable;
                    recupererChaine(nomIndiceReel, nomIndice, indiceDebutRecherche, 3);
                    valeurIndice := rechercherVariable(variables, nomIndiceReel).all.ptrVar.all.valeurVariable;

                    if (nomIndice /= nomIndiceReel) then
                        op := element(nomIndice, length(nomIndice)-1);
                        op2 := Integer'Value((1 => element(nomIndice, length(nomIndice))));
                        valeurIndice := operationArithmetique(op, valeurIndice, op2);
                    end if;

                    indiceDebutRecherche := 1;

                    recupererChaine(nomVariable, ptrInstruction.all.ptrIns.all.operandes.z.all.nomVariable, indiceDebutRecherche, 3);

                    append(nomVariable, "[" & Integer'Image(valeurIndice)(2..Integer'Image(valeurIndice)'length) & "]");

                    variable := rechercherVariable(variables, nomVariable).all.ptrVar;

                    variable.all.valeurVariable := ptrInstruction.all.ptrIns.all.operandes.y.all.valeurVariable;

                else

                    if (ptrInstruction.all.ptrIns.all.operandes.y.all.typeVariable = "Indice Tableau") then

                        indiceDebutRecherche := 1;

                        nomIndice := ptrInstruction.all.ptrIns.all.operandes.y.all.nomVariable;
                        recupererChaine(nomIndiceReel, nomIndice, indiceDebutRecherche, 3);
                        valeurIndice := rechercherVariable(variables, nomIndiceReel).all.ptrVar.all.valeurVariable;
                        if (nomIndice /= nomIndiceReel) then
                            op := element(nomIndice, length(nomIndice)-1);
                            op2 := Integer'Value((1 => element(nomIndice, length(nomIndice))));
                            valeurIndice := operationArithmetique(op, valeurIndice, op2);
                        end if;

                        indiceDebutRecherche := 1;


                        recupererChaine(nomVariable, ptrInstruction.all.ptrIns.all.operandes.x.all.nomVariable, indiceDebutRecherche, 3);

                        append(nomVariable, "[" & Integer'Image(valeurIndice)(2..Integer'Image(valeurIndice)'length) & "]");

                        variable := rechercherVariable(variables, nomVariable).all.ptrVar;

                        ptrInstruction.all.ptrIns.all.operandes.z.all.valeurVariable := variable.all.valeurVariable;
                    else
                        
                        if (element(ptrInstruction.all.ptrIns.all.operation, 1) = '+' or element(ptrInstruction.all.ptrIns.all.operation, 1) = '*' or element(ptrInstruction.all.ptrIns.all.operation, 1) = '/' or element(ptrInstruction.all.ptrIns.all.operation, 1) = '-') then
                            ptrInstruction.all.ptrIns.all.operandes.z.valeurVariable := operationArithmetique(element(ptrInstruction.all.ptrIns.all.operation, 1), ptrInstruction.all.ptrIns.all.operandes.x.valeurVariable, ptrInstruction.all.ptrIns.all.operandes.y.valeurVariable);
                        else
                            ptrInstruction.all.ptrIns.all.operandes.z.valeurVariable := operationLogique(ptrInstruction.all.ptrIns.all.operation, ptrInstruction.all.ptrIns.all.operandes.x.valeurVariable, ptrInstruction.all.ptrIns.all.operandes.y.valeurVariable);
                        end if;
                    end if;

                end if;

            end if;
            ptrInstruction := ptrInstruction.all.next;
        end if;

    end interpreterCommande;

    procedure changerInstructionParNumero(ptrInstruction : in out T_List_Instruction; numInstruction : in integer) is
        instuction_not_found: Exception;
    begin
        if (ptrInstruction = null) then
            raise instuction_not_found;
        elsif (ptrInstruction.all.ptrIns.all.numInstruction < numInstruction) then
            ptrInstruction := ptrInstruction.all.next;
            changerInstructionParNumero(ptrInstruction, numInstruction);
        elsif (ptrInstruction.all.ptrIns.all.numInstruction > numInstruction) then
            ptrInstruction := ptrInstruction.all.prev;
            changerInstructionParNumero(ptrInstruction, numInstruction);
        else
            null;
        end if;

        exception
            when instuction_not_found => 
                put("GOTO : la ligne précisée n'existe pas dans le fichier");

    end changerInstructionParNumero;

end intermediaire;