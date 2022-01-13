with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;


package body intermediaire is

    --package Liste_Variables is new P_List_Double(pointeur => T_List_Variable);
    --use Liste_Variables;
    --package Liste_Instructions is new P_List_Double(pointeur => T_List_Instruction);
    --use Liste_Instructions;

    procedure traiterProgramme(fileName : in string) is
        variables : T_List_Variable;
        instructions : T_List_Instruction; 
    begin
        parseFile(fileName, variables, instructions);
        afficher_liste(instructions);
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

            recupererVariables(variables, ligne);
        
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
        end loop;

        ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        loop

            recupererInstructions(instructions, variables, ligne);
        
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Fin)));
        end loop;

        Close(F);

    end parseFile;


    procedure recupererVariables(variables : in out T_List_Variable; ligne : in Unbounded_string) is
        find : boolean;
        i : integer; 
        j : integer; 
        k : integer;
        typeVariable : chaine;
        nomVariable : chaine;
        ptrVariable : T_Ptr_Variable;
    begin
    
        i := 1;
        -- Parcourir la ligne jusqu'à trouver la déclaration de type
        while(element(ligne, i) /= ':') loop
            i := i+1;
        end loop;

        i := i+1;

        j := 0;
        -- Récupérer le type de la variable
        while(i <= length(ligne)) loop
            j := j+1;
            typeVariable.str(j) := element(ligne, i);
            i := i+1;
        end loop;

        typeVariable.nbCharsEffectif := j;

        i := 1;
        -- Parcourir la ligne pour trouver le nom de la variable
        while(i <= length(ligne) and element(ligne, i) /= ':') loop

            k := 0;

            find := false;
            while (Character'POS(element(ligne, i)) in 65..122 or Character'POS(element(ligne, i)) in 48..57) loop
                k := k+1;
                find := true;
                nomVariable.str(k) := element(ligne, i);
                i := i+1;
            end loop;

            if (find) then
                nomVariable.nbCharsEffectif := k;
                ptrVariable := new T_Variable'(0, typeVariable, nomVariable, false);
                ajouter(variables, ptrVariable);
            else
                i := i+1;
            end if;


        end loop;

    end recupererVariables;

    procedure recupererInstructions(instructions : in out T_List_Instruction; variables : in out T_List_Variable; ligne : in Unbounded_string) is
     
        i : integer;
        j : integer;
        nomVariableZ : chaine;
        nomVariableX : chaine;
        typeVariableZ : chaine;
        typeVariableX : chaine;
        valeurVariableZ : integer;
        valeurVariableX : integer;
        nomVariableY : chaine;
        typeVariableY : chaine;
        valeurVariableY : integer;
        numInstruction : chaine;
        numInstructionEntier : integer;
        operation : chaine;
        ptrInstruction : T_Ptr_Instruction; 
        isANumber : boolean;
        ptrVariable : T_Ptr_Variable;
        tlistVariable : T_List_Variable;
        operateurLogiqueTrouve : boolean;

    begin

        ptrInstruction := new T_Instruction;

        i := 1;
        while (Character'POS(element(ligne, i)) in 48..57) loop
            numInstruction.str(i) := element(ligne, i);
            i := i+1;
        end loop;

        numInstruction.nbCharsEffectif := i-1;
        numInstructionEntier := Integer'Value(numInstruction.str(1..numInstruction.nbCharsEffectif));
        ptrInstruction.all.numInstruction := numInstructionEntier;

        if (Slice(ligne, i, i+1) = "IF") then

            operation.str(1..2) := "IF";
            operation.nbCharsEffectif := 2;
            
            i := i+2;

            j := 0;
            while ((Character'POS(element(ligne, i)) in 65..122 or Character'POS(element(ligne, i)) in 48..57) and then slice(ligne, i, i+3) /= "GOTO") loop
                j := j+1;
                nomVariableX.str(j) := element(ligne, i);
                i := i+1;
            end loop;
            nomVariableX.nbCharsEffectif := j;
            tlistVariable := rechercherVariable(variables, nomVariableX);
            ptrInstruction.all.operandes.x := tlistVariable.all.ptrVar;

            i := i+4;

            j := 0;
            while (i <= length(ligne) and then (Character'POS(element(ligne, i)) in 48..57)) loop
                j := j+1;
                nomVariableZ.str(j) := element(ligne, i);
                i := i+1;
            end loop;
            nomVariableZ.nbCharsEffectif := j;
            valeurVariableZ := Integer'Value(nomVariableZ.str(1..nomVariableZ.nbCharsEffectif));
            nomVariableZ.nbCharsEffectif := 15;
            nomVariableZ.str(1..nomVariableZ.nbCharsEffectif) := "numeroLigneGOTO";
            typeVariableZ.nbCharsEffectif := 6;
            typeVariableZ.str(1..typeVariableZ.nbCharsEffectif) := "Entier";
            ptrVariable := new T_Variable'(valeurVariableZ, typeVariableZ, nomVariableZ, false);
            ptrInstruction.all.operandes.z := ptrVariable;

        elsif (Slice(ligne, i, i+3) = "GOTO") then

            j := 0;
            while (Character'POS(element(ligne, i)) in 65..122) loop
                j := j+1;
                operation.str(j) := element(ligne, i);
                i := i+1;
            end loop;
            operation.nbCharsEffectif := j;

            j := 0;
            while (i <= length(ligne) and then (Character'POS(element(ligne, i)) in 48..57)) loop
                j := j+1;
                nomVariableZ.str(j) := element(ligne, i);
                i := i+1;
            end loop;
            nomVariableZ.nbCharsEffectif := j;
            valeurVariableZ := Integer'Value(nomVariableZ.str(1..nomVariableZ.nbCharsEffectif));
            nomVariableZ.nbCharsEffectif := 15;
            nomVariableZ.str(1..nomVariableZ.nbCharsEffectif) := "numeroLigneGOTO";
            typeVariableZ.nbCharsEffectif := 6;
            typeVariableZ.str(1..typeVariableZ.nbCharsEffectif) := "Entier";
            ptrVariable := new T_Variable'(valeurVariableZ, typeVariableZ, nomVariableZ, false);
            ptrInstruction.all.operandes.z := ptrVariable;

        elsif (Slice(ligne, i, i+3) = "NULL") then
            
            operation.str(1..4) := "NULL";
            operation.nbCharsEffectif := 4;

        else

            j := 0;
            while (slice(ligne, i, i+1) /= "<-") loop
                j := j+1;
                nomVariableZ.str(j) := element(ligne, i);
                i := i+1;
            end loop;
            nomVariableZ.nbCharsEffectif := j;
            tlistVariable := rechercherVariable(variables, nomVariableZ);
            ptrInstruction.all.operandes.z := tlistVariable.all.ptrVar;
            
            i := i+2;

            operateurLogiqueTrouve := false;
            j := 0;
            while (i <= length(ligne) and then (Character'POS(element(ligne, i)) in 65..122 or Character'POS(element(ligne, i)) in 48..57) and then not operateurLogiqueTrouve) loop
                if ((i <= length(ligne)-1 and then slice(ligne, i, i+1) = "OR") or (i <= length(ligne)-2 and then slice(ligne, i, i+2) = "AND")) then
                    operateurLogiqueTrouve := true;
                else
                    j := j+1;
                    nomVariableX.str(j) := element(ligne, i);
                    i := i+1;
                end if;
            end loop;

            nomVariableX.nbCharsEffectif := j;

            isANumber := true;
            j := 0;
            loop
                j := j+1;
                if (Character'POS(nomVariableX.str(j)) in 65..122) then
                    isANumber := false;
                end if;
            exit when (j = nomVariableX.nbCharsEffectif or not isANumber);
            end loop;

            if (isANumber) then
                valeurVariableX := Integer'Value(nomVariableX.str(1..nomVariableX.nbCharsEffectif));
                nomVariableX.nbCharsEffectif := 3;
                nomVariableX.str(1..nomVariableX.nbCharsEffectif) := "Tmp";
                typeVariableX.nbCharsEffectif := 6;
                typeVariableX.str(1..typeVariableX.nbCharsEffectif) := "Entier";
                ptrVariable := new T_Variable'(valeurVariableX, nomVariableX, typeVariableX, false);
            else
                tlistVariable := rechercherVariable(variables, nomVariableX);
                ptrInstruction.all.operandes.x := tlistVariable.all.ptrVar;
            end if;

            if (i <= length(ligne)) then

                if (i <= length(ligne)-2 and then slice(ligne, i, i+2) = "AND") then
                    operation.nbCharsEffectif := 3;
                    operation.str(1..3) := "AND";
                    i := i+3; 
                elsif (i <= length(ligne)-1 and then slice(ligne, i, i+1) = "OR") then
                    operation.nbCharsEffectif := 2;
                    operation.str(1..2) := "OR";
                    i := i+2; 
                else
                    operation.nbCharsEffectif := 1;
                    operation.str(1) := element(ligne, i);
                    i := i+1; 
                end if;

                j := 0;
                while (i <= length(ligne) and then (Character'POS(element(ligne, i)) in 65..122 or Character'POS(element(ligne, i)) in 48..57)) loop
                    j := j+1;
                    nomVariableY.str(j) := element(ligne, i);
                    i := i+1;
                end loop;
                nomVariableY.nbCharsEffectif := j;

                isANumber := true;
                j := 0;
                loop
                    j := j+1;
                    if (Character'POS(nomVariableY.str(j)) in 65..122) then
                        isANumber := false;
                    end if;
                exit when (j = nomVariableY.nbCharsEffectif or not isANumber);
                end loop;

                if (isANumber) then
                    valeurVariableY := Integer'Value(nomVariableY.str(1..nomVariableY.nbCharsEffectif));
                    nomVariableY.nbCharsEffectif := 3;
                    nomVariableY.str(1..nomVariableY.nbCharsEffectif) := "Tmp";
                    typeVariableY.nbCharsEffectif := 6;
                    typeVariableY.str(1..typeVariableY.nbCharsEffectif) := "Entier";
                    ptrVariable := new T_Variable'(valeurVariableY, nomVariableY, typeVariableY, false);
                else
                    tlistVariable := rechercherVariable(variables, nomVariableY);
                    ptrInstruction.all.operandes.y := tlistVariable.all.ptrVar;
                end if;
            else
                operation.str(1..11) := "AFFECTATION";
                operation.nbCharsEffectif := 11;
            end if;
        end if;

        ptrInstruction.all.operation := operation;
        ajouter(instructions, ptrInstruction);

    end recupererInstructions;

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
            put(l.all.ptrVar.all.nomVariable.str(1..l.all.ptrVar.all.nomVariable.nbCharsEffectif));
            put(l.all.ptrVar.all.typeVariable.str(1..l.all.ptrVar.all.typeVariable.nbCharsEffectif));
            if (l.all.next /= null) then
                put(" -> ");
            end if;
            l := l.all.next;
        end loop;
    end afficher_liste;

    procedure afficher_liste(f_l : in T_List_Instruction) is
        l : T_List_Instruction;
    begin
        l := f_l;
        while(l.all.prev /= null) loop
            l := l.all.prev;
        end loop;
        while (l /= null) loop
            put("numero de ligne : ");
            put(l.all.ptrIns.all.numInstruction, 1);
            new_line;
            put("       ");
            put("operation   : ");
            put(l.all.ptrIns.all.operation.str(1..l.all.ptrIns.all.operation.nbCharsEffectif));
            new_line;
            put("       parametre z :");
            if (l.all.ptrIns.all.operandes.z /= null) then
                new_line;
                put("                type    : ");
                put(l.all.ptrIns.all.operandes.z.all.typeVariable.str(1..l.all.ptrIns.all.operandes.z.all.typeVariable.nbCharsEffectif));
                new_line;
                put("                nom     : ");
                put(l.all.ptrIns.all.operandes.z.all.nomVariable.str(1..l.all.ptrIns.all.operandes.z.all.nomVariable.nbCharsEffectif));
                new_line;
                put("                valeur  : ");
                put(l.all.ptrIns.all.operandes.z.all.valeurVariable, 1);
            else
                put(" /");
            end if;
            new_line;

            put("       parametre x :");
            if (l.all.ptrIns.all.operandes.x /= null) then
                new_line;
                put("                type    : ");
                put(l.all.ptrIns.all.operandes.x.all.typeVariable.str(1..l.all.ptrIns.all.operandes.x.all.typeVariable.nbCharsEffectif));
                new_line;
                put("                nom     : ");
                put(l.all.ptrIns.all.operandes.x.all.nomVariable.str(1..l.all.ptrIns.all.operandes.x.all.nomVariable.nbCharsEffectif));
                new_line;
                put("                valeur  : ");
                put(l.all.ptrIns.all.operandes.x.all.valeurVariable, 1);
            else
                put(" /");
            end if;
            new_line;

            put("       parametre y :");
            if (l.all.ptrIns.all.operandes.y /= null) then
                new_line;
                put("                type    : ");
                put(l.all.ptrIns.all.operandes.y.all.typeVariable.str(1..l.all.ptrIns.all.operandes.y.all.typeVariable.nbCharsEffectif));
                new_line;
                put("                nom     : ");
                put(l.all.ptrIns.all.operandes.y.all.nomVariable.str(1..l.all.ptrIns.all.operandes.y.all.nomVariable.nbCharsEffectif));
                new_line;
                put("                valeur  : ");
                put(l.all.ptrIns.all.operandes.y.all.valeurVariable, 1);
            else
                put(" /");
            end if;
            new_line;

            l := l.all.next;
        end loop;
    end afficher_liste;

    function rechercherVariable (variables : in T_List_Variable; nomVariable : in chaine) return T_List_Variable is
        copy : T_List_Variable;
    begin
        copy := variables;
        while copy.all.prev /= null loop -- Retour au début de la liste
            copy := copy.all.prev;
        end loop;
        while copy /= null and then copy.all.ptrVar /= null and then copy.all.ptrVar.all.nomVariable.str(1..copy.all.ptrVar.all.nomVariable.nbCharsEffectif) /= nomVariable.str(1..nomVariable.nbCharsEffectif) loop
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


    procedure interpreterCommande (ptrLine : in T_List_Instruction; ptrVar : in out T_List_Variable) is
    begin
        null;
    end interpreterCommande;


end intermediaire;