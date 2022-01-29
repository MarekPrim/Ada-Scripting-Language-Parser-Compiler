with intermediaire; use intermediaire; --Permet de partager les types définis dans intermediaire.ads
with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, ADA.IO_EXCEPTIONS;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
with manipulation_chaine; use manipulation_chaine;
with variables; use variables;
package body operateurs is

    procedure affectation(instructions : in out T_List_Instruction; variables : in out T_List_Variable) is
    
        variableX : T_Ptr_Variable;
        variableY : T_Ptr_Variable;
        variableZ : T_Ptr_Variable;

    begin

        if (instructions.all.ptrIns.all.operandes.z /= null and then is_array(instructions.all.ptrIns.all.operandes.z.all.nomVariable)) then
            variableZ := recuperer_element_tableau(instructions.all.ptrIns.all.operandes.z.all.nomVariable, variables);
        else
            variableZ := instructions.all.ptrIns.all.operandes.z;
        end if;

        if (instructions.all.ptrIns.all.operandes.x /= null and then is_array(instructions.all.ptrIns.all.operandes.x.all.nomVariable)) then
            variableX := recuperer_element_tableau(instructions.all.ptrIns.all.operandes.x.all.nomVariable, variables);
        else
            variableX := instructions.all.ptrIns.all.operandes.x;
        end if;

        if (instructions.all.ptrIns.all.operandes.y /= null and then is_array(instructions.all.ptrIns.all.operandes.y.all.nomVariable)) then
            variableY := recuperer_element_tableau(instructions.all.ptrIns.all.operandes.y.all.nomVariable, variables);
        else
            variableY := instructions.all.ptrIns.all.operandes.y;
        end if;

        if (variableY = null) then
            variableZ.all.valeurVariable := variableX.all.valeurVariable;
        else
            if (element(instructions.all.ptrIns.all.operation, 1) = '+' or element(instructions.all.ptrIns.all.operation, 1) = '*' or element(instructions.all.ptrIns.all.operation, 1) = '/' or element(instructions.all.ptrIns.all.operation, 1) = '-') then
                variableZ.all.valeurVariable := operation_arithmetique(element(instructions.all.ptrIns.all.operation, 1), variableX.all.valeurVariable, variableY.all.valeurVariable);
            else
                variableZ.all.valeurVariable := operation_logique(instructions.all.ptrIns.all.operation, variableX.all.valeurVariable, variableY.all.valeurVariable);
            end if;
        end if;

        instructions := instructions.all.next;

    end affectation;

    function operation_arithmetique(op: in Character; op1 : in Integer; op2 : in Integer) return integer is
    
        resultat : Integer;
    
    begin

        case op is
            when '+' =>
                resultat := op1 + op2;
            when '-' =>
                resultat := op1 - op2;
            when '*' =>
                resultat := op1 * op2;
            when '/' =>
                resultat := op1 / op2;
            when others =>
                raise Operateur_Incorrect;
        end case;

        return resultat;

    end operation_arithmetique;

    function operation_logique (op : in Unbounded_String; op1 : in Integer; op2 : in integer) return integer is
        
        resultat : boolean;
    
    begin

        if (op = "AND") then
            resultat := (op1 + op2 = 2);
        elsif (op = "OR") then
            resultat := (op1 + op2 > 0);
        elsif (op = "=") then
            resultat := op1 = op2;
        elsif (op = "<") then
            resultat := op1 < op2;
        elsif (op = "<=") then
            resultat := op1 <= op2;
        elsif (op = ">") then
            resultat := op1 > op2;
        elsif (op = ">=") then
            resultat := op1 >= op2;
        else
            raise Operateur_Incorrect;
        end if;

        if (resultat) then
            return 1;
        end if;
        return 0;

    end operation_logique;

    function successeur(char : in Character) return Character is
        
        temporary : Integer;
    
    begin
    
        temporary := Character'POS(char);
        temporary := temporary + 1;
        return Character'VAL(temporary);
    
    end successeur;

    function predecesseur(char : in Character) return Character is
    
        temporary : Integer;
    
    begin
    
        temporary := Character'POS(char);
        temporary := temporary - 1;
        return Character'VAL(temporary);
    
    end predecesseur;

    procedure ecrire(instructions : in out T_List_Instruction; variables : in T_List_Variable) is

        variableZ : T_Ptr_Variable;
        nomVariable : Unbounded_String;
        nomIndice : Unbounded_String;

    begin

        if (is_array(instructions.all.ptrIns.all.operandes.z.all.nomVariable)) then
            variableZ := recuperer_element_tableau(instructions.all.ptrIns.all.operandes.z.all.nomVariable, variables);
        else
            variableZ := instructions.all.ptrIns.all.operandes.z;
        end if;
        if (variableZ.all.typeVariable = "Caractere") then
            put(Character'Val(variableZ.all.valeurVariable));
        else
            put(variableZ.all.valeurVariable, 1);
        end if;
        new_line;
        instructions := instructions.all.next;

    end ecrire;

    procedure lire(instructions : in out T_List_Instruction; variables : in T_List_Variable) is

        nomVariable : Unbounded_String;
        nomIndice : Unbounded_String;
        chaineLue : Unbounded_String;
        variableZ : T_Ptr_Variable;
        conditionSortie : boolean;

    begin

        if (is_array(instructions.all.ptrIns.all.operandes.z.all.nomVariable)) then
            variableZ := recuperer_element_tableau(instructions.all.ptrIns.all.operandes.z.all.nomVariable, variables);
        else
            variableZ := instructions.all.ptrIns.all.operandes.z;
        end if;

        conditionSortie := false;
        loop
            put("Entrez une chaine de type ");
            put(variableZ.all.typeVariable);
            put(" pour la variable ");
            put(variableZ.all.nomVariable);
            put(" : ");
            get_line(chaineLue);

            conditionSortie := (length(chaineLue) = 1 and variableZ.all.typeVariable = "Caractere") or (is_a_number(chaineLue) and variableZ.all.typeVariable = "Entier");
            if (not conditionSortie) then
                put_line("La chaine remplie ne correspond pas au type demandé");
            end if;     
            exit when (conditionSortie);
        end loop;

        if (variableZ.all.typeVariable = "Caractere") then
            variableZ.all.valeurVariable := Character'Pos(element(chaineLue, 1));
        else
            variableZ.all.valeurVariable := Integer'Value(to_string(chaineLue));
        end if;

        instructions := instructions.all.next;

    end lire;

    procedure branchement_conditionel(instructions : in out T_List_Instruction; variables : in T_List_Variable) is
        
        variableX : T_Ptr_Variable;
        variableZ : T_Ptr_Variable;

        currentLine : Integer;
        nomVariable : Unbounded_String;
        nomIndice : Unbounded_String;

    begin

        if (instructions.all.ptrIns.all.operandes.z /= null and then is_array(instructions.all.ptrIns.all.operandes.z.all.nomVariable)) then
            variableZ := recuperer_element_tableau(instructions.all.ptrIns.all.operandes.z.all.nomVariable, variables);
        else
            variableZ := instructions.all.ptrIns.all.operandes.z;
        end if;

        if (instructions.all.ptrIns.all.operandes.x /= null and then is_array(instructions.all.ptrIns.all.operandes.x.all.nomVariable)) then
            variableX := recuperer_element_tableau(instructions.all.ptrIns.all.operandes.x.all.nomVariable, variables);
        else
            variableX := instructions.all.ptrIns.all.operandes.x;
        end if;

        if(variableX.all.valeurVariable = 1) then
            branchement_basic(instructions, variableZ.all.valeurVariable);
        else
            currentLine := instructions.all.ptrIns.all.numInstruction;
            branchement_basic(instructions, currentLine+1);
        end if;

    end branchement_conditionel;

    procedure branchement_basic(instructions : in out T_List_Instruction; numInstruction : in integer) is
    
    begin

        if (instructions = null) then
            raise instuction_not_found;
        elsif (instructions.all.ptrIns.all.numInstruction < numInstruction) then
            instructions := instructions.all.next;
            branchement_basic(instructions, numInstruction);
        elsif (instructions.all.ptrIns.all.numInstruction > numInstruction) then
            instructions := instructions.all.prev;
            branchement_basic(instructions, numInstruction);
        else
            null;
        end if;

        exception
            when Instuction_Not_Found => 
                put("GOTO : la ligne précisée n'existe pas dans le fichier");
    
    end branchement_basic;

end operateurs;