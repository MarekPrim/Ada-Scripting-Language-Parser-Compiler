with intermediaire; use intermediaire; --Permet de partager les types définis dans intermediaire.ads
with operateurs; use operateurs;
with operations_liste; use operations_liste;
with manipulation_chaine; use manipulation_chaine;
with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, ADA.IO_EXCEPTIONS;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;


package body variables is

    procedure recuperer_variables(variables : in out T_List_Variable; ligne : in Unbounded_string) is
        
        i : integer; 
        typeVariable : Unbounded_String;
        nomVariable : Unbounded_String;
        nomVariableTableau : Unbounded_String;
        is_array : boolean;
        nbElementsTableau : Unbounded_String;

    begin

        i := 1;
        -- Parcourir la ligne jusqu'à trouver la déclaration de type
        while(element(ligne, i) /= ':') loop
            i := i+1;
        end loop;
        i := i+1;
        -- Récupérer le type de la variable
        is_array := element(ligne, i) = '[';
        if (is_array) then
            i := i+1;
        end if;
        recuperer_chaine(typeVariable, ligne, i, 2);
        if (is_array) then
            i := i+1;
            recuperer_chaine(nbElementsTableau, ligne, i, 1);
        end if;
        i := 1;
        while(i <= length(ligne) and element(ligne, i) /= ':') loop
            -- Parcourir la ligne pour trouver le nom de la variable
            if (element(ligne, i) /= ',') then
                recuperer_chaine(nomVariable, ligne, i, 3);
                if (is_array) then
                    -- création des variables ayant pour noms nomDuTableau[1], ..., nomDuTableau[nbElementsTableau]
                    for i in 1..Integer'value(to_string(nbElementsTableau)) loop
                        nomVariableTableau := nomVariable;
                        append(nomVariableTableau,'[' & Integer'Image(i)(2..Integer'Image(i)'length) &']');
                        creer_et_ajouter_variable(variables, typeVariable, nomVariableTableau);
                    end loop;
                else
                    creer_et_ajouter_variable(variables, typeVariable, nomVariable);
                end if;
                nomVariable := To_Unbounded_String("");
            else
                i := i+1;
            end if;
        end loop;

    end recuperer_variables;

    function creer_variable(variables : in T_List_Variable; nomVariable : in Unbounded_String; isCaractere : in boolean) return T_Ptr_Variable is

    begin

        if (isCaractere or is_a_number(nomVariable)) then
            return creer_variable_tmp(nomVariable, isCaractere);
        else
            return rechercher_variable(variables, nomVariable).all.ptrVar;
        end if;

    end creer_variable;

    procedure creer_variable_tableau (ligne : in Unbounded_String; i : in out integer; nomTableau : in out Unbounded_String; variables : in T_List_Variable; ptrVariable : out T_Ptr_Variable) is

        nomVariableTableau : Unbounded_String;
        typeTableau : Unbounded_String;

    begin

        nomVariableTableau := nomTableau;
        append(nomTableau, "[1]");
        append(nomVariableTableau, "[");

        typeTableau := rechercher_variable(variables, nomTableau).all.ptrVar.all.typeVariable;
        i := i+1;

        while (i < length(ligne) and then element(ligne, i) /= ']') loop
            append(nomVariableTableau, element(ligne, i));
            i := i+1;
        end loop;

        append(nomVariableTableau, "]");

        i := i+1;

        ptrVariable := new T_Variable'(0, typeTableau, nomVariableTableau, false);

    end creer_variable_tableau;

    

    function creer_variable_tmp (nomVariable : in Unbounded_String; isCaractere : in boolean) return T_Ptr_Variable is
        
        valeurVariableTmp : integer;
        nomVariableTmp : Unbounded_String;
        typeVariableTmp : Unbounded_String;
    
    begin

        if (isCaractere) then 
            valeurVariableTmp := Character'Pos(element(nomVariable,1));
            typeVariableTmp := To_Unbounded_String("Caractere");
        else
            valeurVariableTmp := Integer'Value(To_String(nomVariable));
            typeVariableTmp := To_Unbounded_String("Entier");
        end if;

        nomVariableTmp := To_Unbounded_String("Tmp");

        return new T_Variable'(valeurVariableTmp, typeVariableTmp, nomVariableTmp, false);

    end creer_variable_tmp;

    procedure creer_et_ajouter_variable(variables : in out T_List_Variable; typeVariable : in Unbounded_String; nomVariable : in Unbounded_String) is

        ptrVariable : T_Ptr_Variable;

    begin

        begin
        if(variables /= null and then rechercher_variable(variables, nomVariable) /= null) then
            raise Variable_Deja_Definie;
        end if;
            exception
                when Variable_Non_Trouvee => null; -- Si elle n'est pas trouvée, on ne fait rien
                when Variable_Deja_Definie => put_line("La variable à insérer est déjà définie");
        end;
        ptrVariable := new T_Variable'(0, typeVariable, nomVariable, false);
        ajouter(variables, ptrVariable);

    end creer_et_ajouter_variable;


    function recuperer_element_tableau(nomVariableTableau : in Unbounded_String; variables : in T_List_Variable) return T_Ptr_Variable is

        nomTableau : Unbounded_String;
        nomIndice : Unbounded_String;
        elementTableau : Unbounded_String;
        i : integer;
        valeurIndice : integer;

    begin

        i := 1;

        recuperer_chaine(nomTableau, nomVariableTableau, i, 3);
        elementTableau := nomTableau;
        append(elementTableau, "[");
        i := i+1;
        recuperer_chaine(nomIndice, nomVariableTableau, i, 3);

        if (is_a_number(nomIndice)) then
            valeurIndice := Integer'Value(to_string(nomIndice));
        else
            valeurIndice := rechercher_variable(variables, nomIndice).all.ptrVar.all.valeurVariable;
            if (element(nomVariableTableau,i) /= ']') then
                valeurIndice := operation_arithmetique(element(nomVariableTableau, i), Integer'Value(( 1 => element(nomVariableTableau, i+1) )), valeurIndice);
            end if;
        end if;

        append(elementTableau, Integer'Image(valeurIndice)(2..Integer'Image(valeurIndice)'length) & "]");
        
        return rechercher_variable(variables, elementTableau).all.ptrVar;

    end recuperer_element_tableau;

    function is_array (nomVariable : in Unbounded_String) return boolean is

        i : integer;

    begin

        i := 1;
        while (i <= length(nomVariable)) loop
            if (element(nomVariable, i) = '[') then
                return true;
            end if;
            i := i+1;
        end loop;

        return false;

    end is_array;


    function rechercher_variable (variables : in T_List_Variable; nomVariable : in Unbounded_String) return T_List_Variable is
    
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

    end rechercher_variable;

end variables;