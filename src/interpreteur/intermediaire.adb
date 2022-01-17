with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, operateurs;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, operateurs;


package body intermediaire is

    --package Liste_Variables is new P_List_Double(pointeur => T_List_Variable);
    --use Liste_Variables;
    --package Liste_Instructions is new P_List_Double(pointeur => T_List_Instruction);
    --use Liste_Instructions;

    procedure traiterProgramme(fileName : in string) is
        variables : T_List_Variable;
        instructions : T_List_Instruction;
        l_instructions : T_List_Instruction;
    begin
        parseFile(fileName, variables, instructions);


        pointerEnTeteInstructions(instructions);

        l_instructions := instructions;

        while(l_instructions /= null) loop
            interpreterCommande(l_instructions);
        end loop;
        afficher_liste(instructions);

        afficher_liste(variables);

    end traiterProgramme;

    function ligneCommenceParMotReserve (ligne : in Unbounded_string; enum : in string) return boolean is
        i : integer;
        longueurEnum : integer;
        currentChar : Character;
    begin
        i := 1;

        longueurEnum := length(To_Unbounded_String(enum));

        while (i <= length(ligne) and i <= longueurEnum) loop

            if (i > 1) then
                currentChar := To_Lower(enum(i));
            else
                currentChar := enum(i);
            end if;

            if (not (element(ligne, i) = currentChar)) then
                return false;
            end if;
            i := i+1;
        end loop;

        return true;

    end ligneCommenceParMotReserve;

    function renvoyerLigneSansEspace (ligne : in Unbounded_string) return Unbounded_string is
        j : integer;
        trimLigne : Unbounded_string;
    begin
        j := 1;
        for i in 1..length(ligne) loop
            if (not (element(ligne, i) = ' ')) then
                append(trimLigne, element(ligne, i));
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

        Open (F, In_File, fileName);


        loop
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
        end loop;


        ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        if (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut))) then
            raise Aucune_Variable_Definie;
        end if;

        loop

            if (estLigneUtile(ligne)) then
                recupererVariables(variables, ligne);
            end if;
        
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
        end loop;

        afficher_liste(variables);

        ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        loop
            if (estLigneUtile(ligne)) then
                recupererInstructions(instructions, variables, ligne);
            end if;
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Fin)));
        end loop;

        Close(F);

    end parseFile;

    function estLigneUtile (ligne : in Unbounded_String) return boolean is
    begin
        if (length(ligne) = 0) then
            return false;
        else
            if (length(ligne) >= 2 and then slice(ligne, 1, 2) = "--") then
                return false;
            end if;
        end if;
        return true;
    end estLigneUtile;


    procedure recupererVariables(variables : in out T_List_Variable; ligne : in Unbounded_string) is
        find : boolean;
        i : integer; 
        typeVariable : Unbounded_String;
        nomVariable : Unbounded_String;
        ptrVariable : T_Ptr_Variable;
    begin
    
        i := 1;
        -- Parcourir la ligne jusqu'à trouver la déclaration de type
        while(element(ligne, i) /= ':') loop
            i := i+1;
        end loop;

        i := i+1;

        -- Récupérer le type de la variable
        while(i <= length(ligne)) loop
            append(typeVariable, element(ligne, i));
            i := i+1;
        end loop;

        i := 1;
        -- Parcourir la ligne pour trouver le nom de la variable
        while(i <= length(ligne) and element(ligne, i) /= ':') loop

            find := false;
            while (Character'POS(element(ligne, i)) in 65..122 or Character'POS(element(ligne, i)) in 48..57) loop
                find := true;
                append(nomVariable, element(ligne, i));
                i := i+1;
            end loop;

            if (find) then
                ptrVariable := new T_Variable'(0, typeVariable, nomVariable, false);
                begin
                if(variables /= null and then rechercherVariable(variables, nomVariable) /= null) then
                    raise Variable_Deja_Definie;
                end if;
                    exception
                        when Variable_Non_Trouvee => null; -- Si elle n'est pas trouvée, on ne fait rien
                end;
                ajouter(variables, ptrVariable);
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
        valeurVariableZ : integer;
        nomVariableY : Unbounded_String;
        numInstruction : integer;
        operation : Unbounded_String;
        ptrInstruction : T_Ptr_Instruction; 
        ptrVariable : T_Ptr_Variable;
        tlistVariable : T_List_Variable;
        operateurLogiqueTrouve : boolean;

    begin

        ptrInstruction := new T_Instruction;

        -- recuperation du numero de l'instruction
        i := 1;

        numInstruction := recupererNumeroInstructionLigne(i,ligne);
        
        ptrInstruction.all.numInstruction := numInstruction;

        if (Slice(ligne, i, i+1) = "IF") then

            operation := To_Unbounded_String("IF");
            
            i := i+2;

            while ((Character'POS(element(ligne, i)) in 65..122 or Character'POS(element(ligne, i)) in 48..57) and then slice(ligne, i, i+3) /= "GOTO") loop
                append(nomVariableX, element(ligne, i));
                i := i+1;
            end loop;
            


            tlistVariable := rechercherVariable(variables, nomVariableX);
            ptrInstruction.all.operandes.x := tlistVariable.all.ptrVar;

            i := i+4;

            while (i <= length(ligne) and then (Character'POS(element(ligne, i)) in 48..57)) loop
                append(nomVariableZ, element(ligne, i));
                i := i+1;
            end loop;

            valeurVariableZ := Integer'Value(To_String(nomVariableZ));
            nomVariableZ  := To_Unbounded_String("numeroLigneGOTO");
            typeVariableZ := To_Unbounded_String("Entier");
            ptrVariable := new T_Variable'(valeurVariableZ, typeVariableZ, nomVariableZ, false);
            ptrInstruction.all.operandes.z := ptrVariable;

        elsif (Slice(ligne, i, i+3) = "GOTO") then

            while (Character'POS(element(ligne, i)) in 65..122) loop
                append(operation, element(ligne, i));
                i := i+1;
            end loop;

            while (i <= length(ligne) and then (Character'POS(element(ligne, i)) in 48..57)) loop
                append(nomVariableZ, element(ligne, i));
                i := i+1;
            end loop;

            valeurVariableZ := Integer'Value(To_String(nomVariableZ));
            nomVariableZ := To_Unbounded_String("numeroLigneGOTO");
            typeVariableZ := To_Unbounded_String("Entier");
            ptrVariable := new T_Variable'(valeurVariableZ, typeVariableZ, nomVariableZ, false);
            ptrInstruction.all.operandes.z := ptrVariable;

        elsif (Slice(ligne, i, i+3) = "NULL") then
            
            operation := To_Unbounded_String("NULL");

        else

            while (slice(ligne, i, i+1) /= "<-") loop
                append(nomVariableZ, element(ligne, i));
                i := i+1;
            end loop;

            tlistVariable := rechercherVariable(variables, nomVariableZ);
            ptrInstruction.all.operandes.z := tlistVariable.all.ptrVar;
            
            i := i+2;

            operateurLogiqueTrouve := false;
            while (i <= length(ligne) and then (Character'POS(element(ligne, i)) in 65..122 or Character'POS(element(ligne, i)) in 48..57) and then not operateurLogiqueTrouve) loop
                if ((i <= length(ligne)-1 and then slice(ligne, i, i+1) = "OR") or (i <= length(ligne)-2 and then slice(ligne, i, i+2) = "AND")) then
                    operateurLogiqueTrouve := true;
                else
                    append(nomVariableX, element(ligne, i));
                    i := i+1;
                end if;
            end loop;

            if (isANumber(nomVariableX)) then
                ptrInstruction.all.operandes.x := creer_variable_tmp(nomVariableX);
            else
                tlistVariable := rechercherVariable(variables, nomVariableX);
                ptrInstruction.all.operandes.x := tlistVariable.all.ptrVar;
            end if;

            if (i <= length(ligne)) then

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

                while (i <= length(ligne) and then (Character'POS(element(ligne, i)) in 65..122 or Character'POS(element(ligne, i)) in 48..57)) loop
                    append(nomVariableY, element(ligne, i));
                    i := i+1;
                end loop;

                if (isANumber(nomVariableY) = true) then
                    ptrInstruction.all.operandes.y := creer_variable_tmp(nomVariableY);
                else
                    tlistVariable := rechercherVariable(variables, nomVariableY);
                    ptrInstruction.all.operandes.y := tlistVariable.all.ptrVar;
                end if;
            else
                operation := To_Unbounded_String("AFFECTATION");
            end if;
        end if;

        ptrInstruction.all.operation := operation;
        ajouter(instructions, ptrInstruction);

    end recupererInstructions;

    function isANumber (nomVariable : in Unbounded_String) return boolean is
        j : integer;
    begin
        j := 1;
        while(j <= length(nomVariable)) loop
            if (Character'POS(element(nomVariable, j)) in 65..122) then
                return false;
            end if;
            j := j+1;
        end loop;
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
            put(l.all.ptrVar.all.valeurVariable, 1);
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
            branchementBasic(ptrInstruction.all.ptrIns.all.numInstruction+1,ptrInstruction);
        elsif(nomOperation = "GOTO") then
            branchementBasic(ptrInstruction.all.ptrIns.all.operandes.z.all.valeurVariable,ptrInstruction);
        elsif(nomOperation = "IF") then
            branchementConditionel(ptrInstruction);
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