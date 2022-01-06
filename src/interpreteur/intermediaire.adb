package body intermediaire is

    function recupererVariables(fileName : in string) return ptrvariable is
        F         : File_Type;
        pointeur : ptrVariable;
        str : currentLine;
        i : integer;
    begin
        pointeur := creer_liste_vide;
    
        Open (F, In_File, fileName);

        while (Get_Line((F)1..9) /= Reserved_Langage_Word'Image(Programme)) loop

        end loop;

        while (Get_Line(F)(1..5) /= Reserved_Langage_Word'Image(Debut)) loop
            i := 1;
            while (Get_Line(i) /= ':') loop
                i := i+1;
            end loop;
            i := i+1;
            while (get_line(F)(i) /= null) then
                -- recuperer le type des variables
            end loop;
            -- ensuite recuperer le nom des variables

        end loop;

        Close(F);

    end recupererVariables;


      function recuperationVariables(lines : in record_lignes) return variable is
        vars : variables;   
        i : integer;
        j : integer;
        k := integer;
        typeVariable : string(1..100);
        indextypeVariable : integer;
        nomVariable : string(1..100);
        indexNomVariable : integer
    begin
        i := 2;
        j := 1;


        -- R0 : recuperer les variables

        -- R1 : comment recuperer les variables

        -- parcourir les lignes juqu'au trouver "Début"

        while (lines.tab_lignes(i)(1..5) /= Reserved_Langage_Word'Image(Début)) loop
            
            -- recuperer le type de données de la ligne courante
            k := 1;
            while (lines.tab_lignes(i)(k) /= ":") loop
                k := k+1;
            end loop;
            
            indexType := 1;
            while (lines.tab_lignes(i)(k)) /= " ")
                typeVariable(indexTypeVariable) := lines.tab_lignes(i)(k);
                indexTypeVariable := indexTypeVariable+1;
                k := k+1;
            end loop;

            -- recuperer les noms des variables
            k := 1;
            while (lines.tab_lignes(i)(k) /= ":") loop
                indexNomVariable := 1;
                while (Character'POS(lines.tab_lignes(i)(k)) in 65..122 or Character'POS(lines.tab_lignes(i)(k)) in 48..57) then
                    nomVariable(indexNomVariable) := 1;
                    indexNomVariable := indexNomVariable + 1;
                    k := k+1;
                end if;

                -- stocker noms et types des variables dans le tableau

                vars(j).type := typeVariable(1..indexTypeVariable-1);
                vars(j).identificateur := nomVariable(1..indexNomVariable-1);
                
                j := j+1;

            end loop;

            i := i+1;
        end loop;1

    end recuperationVariables;
    
    
    function initialiserInstructions(fileName : in String) return ligne is
        F         : File_Type;
        lines : record_lignes;
        str : currentLine;
        i : integer;
    begin
        Open (F, In_File, file_name);
        lines.nb_lignes := 0;
        i := 1;
        while not End_Of_File (F) loop
            str := Get_Line(F);
            if (str(0..1) /= "--") then
                lines.tab_lignes(i) := str;
                lines.nb_lignes := line.nb_lignes + 1;
                i := i+1;
            end if;
        end loop;
        Close (F);
    end initialiserInstructions;

  


    procedure interpreterCommande (lines : in record_lignes; vars : in out variables; cp : in out integer) is
        i : integer;
        k : integer;
        begin : boolean;
        operation : string(1..2);
        nomVariable : string(1..100);
    begin
        begin := false;
        while (i < lines.nb_lignes) loop
            while (lines.tab_lignes(i)(1..5) /= Reserved_Langage_Word'Image(Début)) loop
                i := i+1;
            end loop;

            k := 1;





            case(lines.tab_lignes(i)(k..k+1)) is
                --TODO
            end case;

            i := i+1;
        end loop;
    end interpreterCommande;

    function rechercherVariable (variables:in ptrVariable; nomVariable : in string) return ptrVariable is

    begin

        //TODO

        return null;

    end rechercherVariable;

    procedure traiterProgramme (fileName : in string) is
        lines : record_lignes;
        variables : record_variables;
    begin

        lines := initialiserInstructions(fileName);
        variables := recuperationVariables(lines);


    end traiterProgramme;

end intermediaire;
