with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, ADA.IO_EXCEPTIONS;
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
            begin 
            recupererVariables(variables, ligne);

            exception
                when ADA.STRINGS.INDEX_ERROR => raise Aucune_Variable_Definie;
            end;
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
        end loop;

        ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        loop

            recupererInstructions(instructions, ligne);
        
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Fin)));
        end loop;

        Close(F);

        exception
            when ADA.IO_EXCEPTIONS.NAME_ERROR => raise Fichier_Non_Trouve;

    end parseFile;


    procedure recupererVariables(variables : in out T_List_Variable; ligne : in Unbounded_string) is
        find : boolean;
        i : integer; 
        j : integer; 
        k : integer;
        typeVariable : chaine;
        nomVariable : chaine;
        ptrVariable : T_Ptr_Variable;
        record_ajout : T_List_Variable;
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

    procedure recupererInstructions(instructions : in out T_List_Instruction; ligne : in Unbounded_string) is
        i : integer;
        numInstruction : chaine;
        operation : chaine; 
    begin

        i := 1;
        while (Character'POS(element(ligne, i)) in 48..57) loop
            numInstruction.str(i) := element(ligne, i);
            i := i+1;
        end loop;

        numInstruction.nbCharsEffectif := i-1;

        if (Slice(ligne, i, i+1) = "IF") then
            operation.str(1..2) := "IF";
            operation.nbCharsEffectif := 2;
        end if;

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
            put(l.all.ptrVar.all.valeurVariable);
            l := l.all.next;
        end loop;
    end afficher_liste;


    function rechercherVariable (variables : in T_List_Variable; nomVariable : in string) return T_List_Variable is
        copy : T_List_Variable;
    begin
        copy := variables;
        while copy.all.prev /= null loop -- Retour au début de la liste
            --Put_Line(copy.all.ptrVar.all.nameVariable.str);
            copy := copy.all.prev;
        end loop;
        while copy /= null and then copy.all.ptrVar /= null and then copy.all.ptrVar.all.nomVariable.str(1..copy.all.ptrVar.all.nomVariable.nbCharsEffectif) /= nomVariable loop
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
