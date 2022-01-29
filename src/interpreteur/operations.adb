with intermediaire; use intermediaire; --Permet de partager les types définis dans intermediaire.ads
with variables; use variables;
with manipulation_chaine; use manipulation_chaine;
with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, ADA.IO_EXCEPTIONS;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;

package body operations is

    procedure ifOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is
    
        nomVariableX : Unbounded_String;
        nomVariableY : Unbounded_String;
        nomVariableZ : Unbounded_String;
        nomIndice : Unbounded_String;
        chainesReservees : T_Chaines_Reservees;
        nomTableau : Unbounded_String;
    
    begin
    
        operation := To_Unbounded_String("IF");
        i := i+2;

        chainesReservees.chaines(1) := To_Unbounded_String("GOTO");
        chainesReservees.nbElements := 1;
        
        -- parcourir la ligne jusqu'au début de la chaîne GOTO, mettre le résultat dans nomVariableX
        recupererChaine(nomVariableX, ligne, i, 3, chainesReservees);

        if (element(ligne, i) = '[') then
            creer_variable_tableau(ligne, i, nomVariableX, variables, ptrInstruction.all.operandes.x);
        else
            ptrInstruction.all.operandes.x := rechercherVariable(variables, nomVariableX).all.ptrVar;
        end if;
        i := i+4;
        
        -- recuperer le paramètre z : numero de ligne du GOTO
        recupererChaine(nomVariableZ, ligne, i, 1);

        ptrInstruction.all.operandes.z := creer_variable(variables, nomVariableZ, false);

    end ifOperation;

    procedure ecrireOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is
    
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
        
        recupererChaine(nomVariableZ, ligne, i, 3);

        if (element(ligne, i) = '[') then
            creer_variable_tableau(ligne, i, nomVariableZ, variables, ptrInstruction.all.operandes.z);
        else
            ptrInstruction.all.operandes.z := creer_variable(variables, nomVariableZ, isCaractere);
        end if;

    end ecrireOperation;

    procedure lireOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is
    
        nomVariableZ : Unbounded_String;
        nomVariableX : Unbounded_String;

    begin

        operation := To_Unbounded_String("LIRE");
        i := i+5;
        recupererChaine(nomVariableZ, ligne, i, 3);

        if (element(ligne, i) = '[') then
            creer_variable_tableau(ligne, i, nomVariableZ, variables, ptrInstruction.all.operandes.z);
        else
            ptrInstruction.all.operandes.z := creer_variable(variables, nomVariableZ, false);
        end if;

    end lireOperation;

    procedure gotoOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is
    
        nomVariableZ : Unbounded_String;

    begin

        operation := To_Unbounded_String("GOTO");
        i := i+4;
        recupererChaine(nomVariableZ, ligne, i, 1);
        ptrInstruction.all.operandes.z := creer_variable(variables, nomVariableZ, false);

    end gotoOperation;

    procedure nullOperation (operation : out Unbounded_String) is

    begin

        operation := To_Unbounded_String("NULL");

    end nullOperation;

    procedure affectationOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable) is

        nomVariableX : Unbounded_String;
        nomVariableY : Unbounded_String;
        nomVariableZ : Unbounded_String;
        nomIndice : Unbounded_String;
        chainesReservees : T_Chaines_Reservees;
        isCaractere : boolean;

    begin

        recupererChaine(nomVariableZ, ligne, i, 3);

        if (element(ligne, i) = '[') then
            creer_variable_tableau(ligne, i, nomVariableZ, variables, ptrInstruction.all.operandes.z);
        else
            ptrInstruction.all.operandes.z := rechercherVariable(variables, nomVariableZ).all.ptrVar;
        end if;

        i := i+2;

        chainesReservees.chaines(1..2) := (To_Unbounded_String("OR"), To_Unbounded_String("AND"));
        chainesReservees.nbElements := 2;

        isCaractere := element(ligne,i) = ''';
        if (isCaractere) then
            i := i+1;
        end if;

        recupererChaine(nomVariableX, ligne, i, 3, chainesReservees);

        if (i <= length(ligne) and then element(ligne, i) = '[') then
            creer_variable_tableau(ligne, i, nomVariableX, variables, ptrInstruction.all.operandes.x);
        else
            ptrInstruction.all.operandes.x := creer_variable(variables, nomVariableX, isCaractere);
            if (isCaractere) then
                i := i+1;
            end if;
        end if;
        
        -- il y a encore du texte après la variable x
        if (i <= length(ligne)) then
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
            recupererChaine(nomVariableY, ligne, i, 3);
            if (i <= length(ligne) and then element(ligne, i) = '[') then
                creer_variable_tableau(ligne, i, nomVariableY, variables, ptrInstruction.all.operandes.y);
            else
                ptrInstruction.all.operandes.y := creer_variable(variables, nomVariableY, isCaractere);
            end if;
        else
            operation := To_Unbounded_String("AFFECTATION");
        end if;

    end affectationOperation;

end operations;