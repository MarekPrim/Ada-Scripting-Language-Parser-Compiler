with intermediaire; use intermediaire; --Permet de partager les types définis dans intermediaire.ads
with operateurs; use operateurs;
with operations_liste; use operations_liste;
with manipulation_chaine; use manipulation_chaine;
with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, ADA.IO_EXCEPTIONS;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;


package body variables is

    function creer_variable(variables : in T_List_Variable; nomVariable : in Unbounded_String; isCaractere : in boolean) return T_Ptr_Variable is

    begin

        if (isCaractere or isANumber(nomVariable)) then
            return creer_variable_tmp(nomVariable, isCaractere);
        else
            return rechercherVariable(variables, nomVariable).all.ptrVar;
        end if;

    end creer_variable;

    procedure creer_variables_tableau (ligne : in Unbounded_String; i : in out integer; nomVariable : in out Unbounded_String; variables : in T_List_Variable; ptrVariable : out T_Ptr_Variable) is

        nomIndice : Unbounded_String;

    begin

        append(nomVariable, "[1]");
        i := i+1;

        while (i < length(ligne) and then element(ligne, i) /= ']') loop
            append(nomIndice, element(ligne, i));
            i := i+1;
        end loop;

        i := i+1;

        if (isANumber(nomIndice)) then
            nomIndice := To_Unbounded_String("Tmp");
        end if;

        ptrVariable := new T_Variable'(0, To_Unbounded_String("Indice Tableau"), nomIndice, false);

    end creer_variables_tableau;

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

end variables;