with intermediaire; use intermediaire; --Permet de partager les types définis dans intermediaire.ads
with variables; use variables;
with manipulation_chaine; use manipulation_chaine;
with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, ADA.IO_EXCEPTIONS;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;

package body operations is

    procedure if_operation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is
    
        nomVariableX : Unbounded_String;
        nomVariableY : Unbounded_String;
        nomVariableZ : Unbounded_String;
        nomIndice : Unbounded_String;
        chainesReservees : T_Chaines_Reservees;
    
    begin
    
        operation := To_Unbounded_String("IF");
        i := i+2;

        chainesReservees.chaines(1) := To_Unbounded_String("GOTO");
        chainesReservees.nbElements := 1;
        
        recuperer_chaine(nomVariableX, ligne, i, 3, chainesReservees);

        if (element(ligne, i) = '[') then
            creer_variables_tableau(ligne, i, nomVariableX, variables, ptrInstruction.all.operandes.y);
        end if;
        ptrInstruction.all.operandes.x := rechercher_variable(variables, nomVariableX).all.ptrVar;
        i := i+4;
        recuperer_chaine(nomVariableZ, ligne, i, 1);
        ptrInstruction.all.operandes.z := new T_Variable'(Integer'Value(To_String(nomVariableZ)), To_Unbounded_String("Entier"), To_Unbounded_String("numeroLigneGOTO"), false);

    end if_operation;

    procedure ecrire_operation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is
    
        nomVariableZ : Unbounded_String;
        nomVariableX : Unbounded_String;
        isCaractere : boolean;

    begin

        operation := To_Unbounded_String("ECRIRE");
        i := i+7;

        isCaractere := element(ligne,i) = ''';
        if (isCaractere) then
            i := i+1;
        end if;
        
        recuperer_chaine(nomVariableZ, ligne, i, 3);

        if (element(ligne, i) = '[') then
            creer_variables_tableau(ligne, i, nomVariableZ, variables, ptrInstruction.all.operandes.x);
        end if;

        ptrInstruction.all.operandes.z := creer_variable(variables, nomVariableZ, isCaractere);

    end ecrire_operation;

    procedure lire_operation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is
    
        nomVariableZ : Unbounded_String;
        nomVariableX : Unbounded_String;

    begin

        operation := To_Unbounded_String("LIRE");
        i := i+5;
        recuperer_chaine(nomVariableZ, ligne, i, 3);

        if (element(ligne, i) = '[') then
            creer_variables_tableau(ligne, i, nomVariableZ, variables, ptrInstruction.all.operandes.x);
        end if;

        ptrInstruction.all.operandes.z := creer_variable(variables, nomVariableZ, false);

    end lire_operation;

    procedure goto_operation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is
    
        nomVariableZ : Unbounded_String;

    begin

        operation := To_Unbounded_String("GOTO");
        i := i+4;
        recuperer_chaine(nomVariableZ, ligne, i, 1);
        ptrInstruction.all.operandes.z := new T_Variable'(Integer'Value(To_String(nomVariableZ)), To_Unbounded_String("Entier"), To_Unbounded_String("numeroLigneGOTO"), false);

    end goto_operation;

    procedure null_operation (operation : out Unbounded_String) is

    begin

        operation := To_Unbounded_String("NULL");

    end null_operation;

    procedure affectation_operation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is

        nomVariableX : Unbounded_String;
        nomVariableY : Unbounded_String;
        nomVariableZ : Unbounded_String;
        isArray : boolean;
        nomIndice : Unbounded_String;
        chainesReservees : T_Chaines_Reservees;
        isCaractere : boolean;

    begin

        recuperer_chaine(nomVariableZ, ligne, i, 3);

        isArray := element(ligne, i) = '[';
        if (isArray) then
            creer_variables_tableau(ligne, i, nomVariableZ, variables, ptrInstruction.all.operandes.x);
        end if;
        ptrInstruction.all.operandes.z := rechercher_variable(variables, nomVariableZ).all.ptrVar;

        i := i+2;

        if (isArray) then
            isCaractere := element(ligne,i) = ''';
            if (isCaractere) then
                i := i+1;
            end if;
            recuperer_chaine(nomVariableY, ligne, i, 3);
            ptrInstruction.all.operandes.y := creer_variable(variables, nomVariableY, isCaractere);
        else
            chainesReservees.chaines(1..2) := (To_Unbounded_String("OR"), To_Unbounded_String("AND"));
            chainesReservees.nbElements := 2;

            isCaractere := element(ligne,i) = ''';
            if (isCaractere) then
                i := i+1;
            end if;

            recuperer_chaine(nomVariableX, ligne, i, 3, chainesReservees);

            if (i<= length(ligne) and then element(ligne, i) = '[') then
                if (isArray) then
                    raise Element_Tableau_Deja_Utilise;
                else
                    isArray := true;
                    creer_variables_tableau(ligne, i, nomVariableX, variables, ptrInstruction.all.operandes.y);
                    ptrInstruction.all.operandes.x := rechercher_variable(variables, nomVariableX).all.ptrVar;
                end if;
            else
                ptrInstruction.all.operandes.x := creer_variable(variables, nomVariableX, isCaractere);
                if (isCaractere) then
                    i := i+1;
                end if;
            end if;
        end if;

        --if(isCaractere) then
            --  i:=i+1;
            --ptrVariable := new T_Variable'(Character'Pos(element(nomVariableX,1)), To_Unbounded_String("Charactere"), To_Unbounded_String("Tmp"), false);
            --ptrInstruction.all.operandes.x := ptrVariable;
            
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
                    loop
                        append(operation, element(ligne, i));
                        i := i+1;
                    exit when (element(ligne,i) /= '<' and element(ligne,i) /= '>' and element(ligne,i) /= '=') ;
                    end loop;
                end if;

                recuperer_chaine(nomVariableY, ligne, i, 3);

                ptrInstruction.all.operandes.y := creer_variable(variables, nomVariableY, false);

            end if;
        else
            operation := To_Unbounded_String("AFFECTATION");
        end if;

        Exception
            when Element_Tableau_Deja_Utilise => put_line("Impossible d'utiliser deux éléments d'un tableau dans la même instruction");

    end affectation_operation;

end operations;