with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, operateurs;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, operateurs;


package body intermediaire is

    --package Liste_Variables is new P_List_Double(pointeur => T_List_Variable);
    --use Liste_Variables;
    --package Liste_Instructions is new P_List_Double(pointeur => T_List_Instruction);
    --use Liste_Instructions;

    procedure traiterProgramme(fileName : in string; choice : in Integer) is

        variables : T_List_Variable;
        instructions : T_List_Instruction;
        l_instructions : T_List_Instruction;
    
    begin
    
        parseFile(fileName, variables, instructions);

        pointerEnTeteInstructions(instructions);

        l_instructions := instructions;

        afficher_liste(instructions);

        while(l_instructions /= null) loop
            if(choice = 1 and l_instructions.next /= null) then
                Put("Numéro de l'instruction en cours : ");
                Put(l_instructions.all.ptrIns.all.numInstruction, 1);
                new_line;
                --afficher_liste(variables);
            end if;
            interpreterCommande(l_instructions);
        end loop;

        --afficher_liste(instructions);
        --Put_Line("Etat des variables en terminaison du programme");
        afficher_liste(variables);

    end traiterProgramme;

    function ligneCommenceParMotReserve (ligne : in Unbounded_string; enum : in string) return boolean is
        i : integer;
        longueurEnum : integer;
        currentChar : Character;
    begin
        i := 1;

        longueurEnum := length(To_Unbounded_String(enum));

        while (i <= length(ligne) and i <= longueurEnum) loop -- On parcourt toute l'énumération et la ligne

            if (i > 1) then -- Les caractères à comparer doivent être une lettre miniscule
                currentChar := To_Lower(enum(i));
            else
                currentChar := enum(i); -- Le premier caractère de l'énumération doit être une lettre majuscule
            end if;

            if (not (element(ligne, i) = currentChar)) then
                return false;
            end if;
            i := i+1;
        end loop;

        return true; -- Si on a parcouru toute l'énumération sans rencontrer de caractère différent, on retourne vrai

    end ligneCommenceParMotReserve;

    function renvoyerLigneSansEspace (ligne : in Unbounded_string) return Unbounded_string is
        
        j : integer;
        trimLigne : Unbounded_string;
    
    begin

        j := 1;
        for i in 1..length(ligne) loop -- Parcours de la ligne
            if (not (element(ligne, i) = ' ')) then -- Si le caractère n'est pas un espace
                append(trimLigne, element(ligne, i)); -- On ajoute le caractère à la chaîne de caractère temporaire
                j := j+1;
            end if;
        end loop;
    
        return trimLigne;
    
    end renvoyerLigneSansEspace;

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

    function estLigneUtile (ligne : in Unbounded_String) return boolean is
    
    begin

        return not(length(ligne) = 0 or (length(ligne) >= 2 and then slice(ligne, 1, 2) = "--"));

    end estLigneUtile;

    procedure creerEtAjouterVariable(variables : in out T_List_Variable; typeVariable : in Unbounded_String; nomVariable : in Unbounded_String) is

        ptrVariable : T_Ptr_Variable;

    begin

        begin
        if(variables /= null and then rechercherVariable(variables, nomVariable) /= null) then
            raise Variable_Deja_Definie;
        end if;
            exception
                when Variable_Non_Trouvee => null; -- Si elle n'est pas trouvée, on ne fait rien
                when Variable_Deja_Definie => put_line("La variable à insérer est déjà définie");
        end;
        ptrVariable := new T_Variable'(0, typeVariable, nomVariable, false);
        ajouter(variables, ptrVariable);

    end creerEtAjouterVariable;

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
        recupererNomVariable(typeVariable, ligne, i, 2);
        if (isArray) then
            i := i+1;
            recupererNomVariable(nbElementsTableau, ligne, i, 1);
        end if;
        i := 1;
        while(i <= length(ligne) and element(ligne, i) /= ':') loop
            -- Parcourir la ligne pour trouver le nom de la variable
            if (element(ligne, i) /= ',') then
                recupererNomVariable(nomVariable, ligne, i, 3);
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

    procedure recupererNomVariable(nomVariable : out Unbounded_String; ligne : in Unbounded_String; i : in out integer; condition : in integer) is

        conditionVerifiee : boolean;

    begin

        -- 1 : numerique
        -- 2 : alphebetique
        -- 3 : alphanumerique

        conditionVerifiee := true;
        while (i <= length(ligne) and conditionVerifiee) loop
            if (((condition = 1 or condition = 3) and then Character'POS(element(ligne, i)) in 48..57) or ((condition = 2 or condition = 3) and then ((Character'POS(element(ligne, i)) in 65..90) or (Character'POS(element(ligne, i)) in 97..122)))) then
                append(nomVariable, element(ligne, i));
                i := i+1;
            else
                conditionVerifiee := false;
            end if;
        end loop;

    end recupererNomVariable;

     procedure recupererNomVariable(nomVariable : out Unbounded_String; ligne : in Unbounded_String; i : in out integer; condition : in integer; chaineReservee : in Unbounded_String) is

        conditionVerifiee : boolean;

    begin

        -- 1 : numerique
        -- 2 : alphebetique
        -- 3 : alphanumerique

        conditionVerifiee := true;
        while (i <= length(ligne) and conditionVerifiee) loop
            if ((((condition = 1 or condition = 3) and then Character'POS(element(ligne, i)) in 48..57) or ((condition = 2 or condition = 3) and then ((Character'POS(element(ligne, i)) in 65..90) or (Character'POS(element(ligne, i)) in 97..122)))) and then not(i <= i+length(chaineReservee)-1 and then slice(ligne, i, i+length(chaineReservee)-1) = chaineReservee)) then
                append(nomVariable, element(ligne, i));
                i := i+1;
            else
                conditionVerifiee := false;
            end if;
        end loop;

    end recupererNomVariable;

    procedure creer_variables_tableau (ligne : in Unbounded_String; i : in out integer; nomVariable : in out Unbounded_String; variables : in T_List_Variable; ptrVariable : out T_Ptr_Variable) is

        nomIndice : Unbounded_String;
        valeurVariableY : integer;

    begin

        append(nomVariable, "[1]");
        i := i+1;
        recupererNomVariable(nomIndice, ligne, i, 3);
        valeurVariableY := rechercherVariable(variables, nomIndice).all.ptrVar.all.valeurVariable;
        if (element(ligne, i) /= ']') then
            append(nomIndice, element(ligne, i) & element(ligne, i+1));
            valeurVariableY := operationArithmetique(element(nomIndice, length(nomIndice)-1), valeurVariableY, Integer'Value((1 => element(nomIndice, length(nomIndice)))));
            i := i+2;
        end if;
        i := i+1;
        ptrVariable := new T_Variable'(valeurVariableY, To_Unbounded_String("Indice Tableau"), nomIndice, false);

    end creer_variables_tableau;

    procedure ifOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is
    
        nomVariableX : Unbounded_String;
        nomVariableY : Unbounded_String;
        nomVariableZ : Unbounded_String;
        nomIndice : Unbounded_String;
    
    begin
    
        operation := To_Unbounded_String("IF");
        i := i+2;
        recupererNomVariable(nomVariableX, ligne, i, 3, To_Unbounded_String("GOTO"));
        if (element(ligne, i) = '[') then
            creer_variables_tableau(ligne, i, nomVariableX, variables, ptrInstruction.all.operandes.y);
        end if;
        ptrInstruction.all.operandes.x := rechercherVariable(variables, nomVariableX).all.ptrVar;
        i := i+4;
        recupererNomVariable(nomVariableZ, ligne, i, 1);
        ptrInstruction.all.operandes.z := new T_Variable'(Integer'Value(To_String(nomVariableZ)), To_Unbounded_String("Entier"), To_Unbounded_String("numeroLigneGOTO"), false);

    end ifOperation;

    procedure gotoOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is
    
        nomVariableZ : Unbounded_String;

    begin

        operation := To_Unbounded_String("GOTO");
        i := i+4;
        recupererNomVariable(nomVariableZ, ligne, i, 1);
        ptrInstruction.all.operandes.z := new T_Variable'(Integer'Value(To_String(nomVariableZ)), To_Unbounded_String("Entier"), To_Unbounded_String("numeroLigneGOTO"), false);

    end gotoOperation;

    procedure nullOperation (operation : out Unbounded_String) is

    begin

        operation := To_Unbounded_String("NULL");

    end nullOperation;

    function creer_variable(variables : in T_List_Variable; nomVariable : in Unbounded_String) return T_Ptr_Variable is

    begin
        Put_Line(nomVariable);
        if (isANumber(nomVariable)) then
            return creer_variable_tmp(nomVariable);
        else
            return rechercherVariable(variables, nomVariable).all.ptrVar;
        end if;

    end creer_variable;

    procedure affectationOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is

        nomVariableX : Unbounded_String;
        nomVariableY : Unbounded_String;
        nomVariableZ : Unbounded_String;
        isArray : boolean;
        nomIndice : Unbounded_String;
        operateurLogiqueTrouve : boolean;
        isCaractere : boolean := false;

    begin

        recupererNomVariable(nomVariableZ, ligne, i, 3);
        isArray := element(ligne, i) = '[';
        if (isArray) then
            creer_variables_tableau(ligne, i, nomVariableZ, variables, ptrInstruction.all.operandes.x);
        end if;
        ptrInstruction.all.operandes.z := rechercherVariable(variables, nomVariableZ).all.ptrVar;
        i := i+2;

        if(element(ligne,i) = ''') then
            isCaractere := true;
            i:=i+1;
        end if;

        if (isArray) then
            recupererNomVariable(nomVariableY, ligne, i, 3);
            ptrInstruction.all.operandes.y := creer_variable(variables, nomVariableY);
        else
            operateurLogiqueTrouve := false;
            while (i <= length(ligne) and then (Character'POS(element(ligne, i)) in 65..90 or Character'POS(element(ligne, i)) in 97..122 or Character'POS(element(ligne, i)) in 48..57) and then not operateurLogiqueTrouve) loop
                if ((i <= length(ligne)-1 and then slice(ligne, i, i+1) = "OR") or (i <= length(ligne)-2 and then slice(ligne, i, i+2) = "AND")) then
                    operateurLogiqueTrouve := true;
                else
                    append(nomVariableX, element(ligne, i));
                    i := i+1;
                end if;
            end loop;
            if (i<= length(ligne) and then element(ligne, i) = '[') then
                isArray := true;
                creer_variables_tableau(ligne, i, nomVariableX, variables, ptrInstruction.all.operandes.y);
                ptrInstruction.all.operandes.x := rechercherVariable(variables, nomVariableX).all.ptrVar;
            else
                if(not(isCaractere)) then
                    ptrInstruction.all.operandes.x := creer_variable(variables, nomVariableX);
                else
                    i:=i+1;
                    ptrInstruction.all.operandes.x := new T_Variable'(Character'Pos(element(nomVariableX,1)), To_Unbounded_String("Charactere"), To_Unbounded_String("Tmp"), false);
                end if;
            end if;
        end if;

        --if(isCaractere) then
           -- i:=i+1;
          --  --ptrVariable := new T_Variable'(Character'Pos(element(nomVariableX,1)), To_Unbounded_String("Charactere"), To_Unbounded_String("Tmp"), false);
           -- ptrInstruction.all.operandes.x := new T_Variable'(Character'Pos(element(nomVariableX,1)), To_Unbounded_String("Charactere"), To_Unbounded_String("Tmp"), false);
        --end if;
        if (i <= length(ligne)) then
            if (isArray) then
                raise Element_Tableau_Deja_Utilise;
            else
                if (i <= length(ligne)-2 and then slice(ligne, i, i+2) = "AND") then
                    operation := To_Unbounded_String("AND");
                    i := i+3; 
                elsif (i <= length(ligne)-1 and then slice(ligne, i, i+1) = "OR") then
                    operation := To_Unbounded_String("OR");
                    i := i+2; 
                else
                    append(operation, element(ligne, i));
                    i := i+1; 
                end if;

                recupererNomVariable(nomVariableY, ligne, i, 3);
                ptrInstruction.all.operandes.y := creer_variable(variables, nomVariableY);
            end if;
        else
            operation := To_Unbounded_String("AFFECTATION");
        end if;

        Exception
            when Element_Tableau_Deja_Utilise => put_line("Impossible d'utiliser deux éléments d'un tableau dans la même instruction");

    end affectationOperation;

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

        elsif (i <= length(ligne)-5 and then Slice(ligne, i, i+5) = "ECRIRE") then
            operation := To_Unbounded_String("ECRIRE");
            --i := i+1;
            --put(i);
            put(element(ligne,i+7));
            put_line(ligne);

        elsif (i <= length(ligne)-3 and then Slice(ligne, i, i+3) = "LIRE") then

            operation := To_Unbounded_String("LIRE");

        else

            affectationOperation(ligne, i, ptrInstruction, operation, variables);

        end if;

        ptrInstruction.all.operation := operation;
        ajouter(instructions, ptrInstruction);

        

    end recupererInstructions;

    function isANumber (nomVariable : in Unbounded_String) return boolean is
        j : integer;
    begin
        Put_Line(nomVariable);
        if (length(nomVariable) = 0) then
            return false;
        else
            j := 1;
            while(j <= length(nomVariable)) loop
                if (not(Character'POS(element(nomVariable, j)) in 48..57)) then
                    return false;
                end if;
                j := j+1;
            end loop;
        end if;
        return true;
    end isANumber;

    function creer_variable_tmp (nomVariable : in Unbounded_String) return T_Ptr_Variable is
        
        valeurVariableTmp : integer;
        nomVariableTmp : Unbounded_String;
        typeVariableTmp : Unbounded_String;
    
    begin
        valeurVariableTmp := Integer'Value(To_String(nomVariable));
        nomVariableTmp := To_Unbounded_String("Tmp");
        typeVariableTmp := To_Unbounded_String("Entier");

        return new T_Variable'(valeurVariableTmp, typeVariableTmp, nomVariableTmp, false);

    end creer_variable_tmp;

    procedure pointerEnTeteInstructions (ptrInstruction : in out T_List_Instruction) is

    begin

        while(ptrInstruction /= null and then ptrInstruction.all.prev /= null) loop
            ptrInstruction := ptrInstruction.all.prev;
        end loop;

    end pointerEnTeteInstructions;


    procedure ajouter(f_l : in out T_List_Variable; f_nouveau : in T_Ptr_Variable) is
    begin
        if (f_l = null) then
            f_l := new T_Cell_Variable'(f_nouveau, null, null);
        else
            while f_l.all.next /= null loop -- Parcours de la liste jusqu'à la queue
                f_l := f_l.all.next;
            end loop;
            f_l.all.next := new T_Cell_Variable'(f_nouveau, null, null);
            f_l.all.next.all.prev := f_l;  
            f_l := f_l.all.next;
        end if;
    end ajouter;

    procedure ajouter(f_l : in out T_List_Instruction; f_nouveau : in T_Ptr_Instruction) is
    begin
        if (f_l = null) then
            f_l := new T_Cell_Instruction'(f_nouveau, null, null);
        else
            while f_l.all.next /= null loop -- Parcours de la liste jusqu'à la queue
                f_l := f_l.all.next;
            end loop;
            f_l.all.next := new T_Cell_Instruction'(f_nouveau, null, null);
            f_l.all.next.all.prev := f_l;  
            f_l := f_l.all.next;
        end if;
    end ajouter;

    procedure afficher_liste(f_l : in T_List_Variable) is
        l : T_List_Variable;
    begin
        l := f_l;
        while(l.all.prev /= null) loop
            l := l.all.prev;
        end loop;
        while (l /= null) loop
            put_line(l.all.ptrVar.all.nomVariable);
            put_line(l.all.ptrVar.all.typeVariable);
            if(l.all.ptrVar.all.typeVariable /= "Charactere") then
                put(l.all.ptrVar.all.valeurVariable, 1);
            else
                put(l.all.ptrVar.all.valeurVariable);
                put(':');
                put("'");
                put(Character'Val(l.all.ptrVar.all.valeurVariable));
                put("'");
            end if;
            new_line;
            l := l.all.next;
        end loop;
    end afficher_liste;

    procedure afficher_liste(f_l : in T_List_Instruction) is
        l : T_List_Instruction;
    begin
        l := f_l;
        pointerEnTeteInstructions(l);
        while (l /= null) loop
            afficherLigneInstruction(l.all.ptrIns);
            l := l.all.next;
        end loop;
    end afficher_liste;

    procedure afficherLigneInstruction (ptrInstruction : T_Ptr_Instruction) is

    begin
        
        put("numero de ligne : ");
        put(ptrInstruction.all.numInstruction, 1);
        new_line;
        put("       operation   : ");
        put_line(ptrInstruction.all.operation);

        put("       parametre z :");
        afficherParametreLigneInstruction(ptrInstruction.all.operandes.z);

        put("       parametre x :");
        afficherParametreLigneInstruction(ptrInstruction.all.operandes.x);

        put("       parametre y :");
        afficherParametreLigneInstruction(ptrInstruction.all.operandes.y);

        new_line;

    end afficherLigneInstruction;

    procedure afficherParametreLigneInstruction (ptrVariable : T_Ptr_Variable) is
    begin

        if (ptrVariable /= null) then
            new_line;
            put("                type    : ");
            put_line(ptrVariable.all.typeVariable);
            put("                nom     : ");
            put_line(ptrVariable.all.nomVariable);
            put("                valeur  : ");
            put(ptrVariable.all.valeurVariable, 1);
        else
            put(" /");
        end if;
        new_line;

    end afficherParametreLigneInstruction;

    function rechercherVariable (variables : in T_List_Variable; nomVariable : in Unbounded_String) return T_List_Variable is
    
        copy : T_List_Variable;
    
    begin
        
        copy := variables;

        while copy.all.prev /= null loop -- Retour au début de la liste
            copy := copy.all.prev;
        end loop;
        while copy /= null and then copy.all.ptrVar /= null and then copy.all.ptrVar.all.nomVariable /= nomVariable loop
            copy := copy.all.next;
        end loop;
        if copy = null then
            raise Variable_Non_Trouvee;
        else 
            return copy;
        end if;
    end rechercherVariable;

    function creer_liste_vide return T_List_Variable is
    p : T_List_Variable;
    begin
        p := null;
        return p;
    end creer_liste_vide;

    function est_vide(p : in T_List_Variable) return boolean is
    begin
        return p = null;
    end est_vide;

    function creer_liste_vide return T_List_Instruction is
    p : T_List_Instruction;
    begin
        p := null;
        return p;
    end creer_liste_vide;

    function est_vide(p : in T_List_Instruction) return boolean is
    begin
        return p = null;
    end est_vide;


    procedure interpreterCommande (ptrInstruction : in out T_List_Instruction) is
        
        nomOperation : Unbounded_String;
    
    begin
        
        nomOperation := ptrInstruction.all.ptrIns.all.operation;
        if(nomOperation = "NULL") then
            ptrInstruction := ptrInstruction.all.next;
        elsif(nomOperation = "GOTO") then
            branchementBasic(ptrInstruction.all.ptrIns.all.operandes.z.all.valeurVariable,ptrInstruction);
        elsif(nomOperation = "IF") then
            branchementConditionel(ptrInstruction);
       --elsif(nomOperation = "PRINT") then
        else
            if (ptrInstruction.all.ptrIns.all.operandes.y = null) then
                ptrInstruction.all.ptrIns.all.operandes.z.all.valeurVariable := ptrInstruction.all.ptrIns.all.operandes.x.all.valeurVariable;
            else
                if (element(ptrInstruction.all.ptrIns.all.operation, 1) = '+' or element(ptrInstruction.all.ptrIns.all.operation, 1) = '*' or element(ptrInstruction.all.ptrIns.all.operation, 1) = '/' or element(ptrInstruction.all.ptrIns.all.operation, 1) = '-') then
                    ptrInstruction.all.ptrIns.all.operandes.z.valeurVariable := operationArithmetique(element(ptrInstruction.all.ptrIns.all.operation, 1), ptrInstruction.all.ptrIns.all.operandes.x.valeurVariable, ptrInstruction.all.ptrIns.all.operandes.y.valeurVariable);
                else
                    ptrInstruction.all.ptrIns.all.operandes.z.valeurVariable := operationLogique(ptrInstruction.all.ptrIns.all.operation, ptrInstruction.all.ptrIns.all.operandes.x.valeurVariable, ptrInstruction.all.ptrIns.all.operandes.y.valeurVariable);
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