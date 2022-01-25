with intermediaire; use intermediaire; --Permet de partager les types définis dans intermediaire.ads
with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, ADA.IO_EXCEPTIONS;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
with manipulation_chaine; use manipulation_chaine;
with variables; use variables;
package body operateurs is

    procedure affectation(ptrInstruction : in out T_List_Instruction) is
    begin
        if ptrInstruction.all.ptrIns.all.operandes.z.all.isConstant then
           raise Variable_Constante;
        else
            if (ptrInstruction.all.ptrIns.all.operandes.z.all.typeVariable = ptrInstruction.all.ptrIns.all.operandes.x.all.typeVariable) then
                ptrInstruction.all.ptrIns.all.operandes.z.all.valeurVariable := ptrInstruction.all.ptrIns.all.operandes.x.all.valeurVariable;
            else
                raise Type_Incorrect;
            end if;
        end if;
    end affectation;

    function operationArithmetique(op: in Character; op1 : in Integer; op2 : in Integer) return integer is
    
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

    end operationArithmetique;

    function operationLogique (op : in Unbounded_String; op1 : in Integer; op2 : in integer) return integer is
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

    end operationLogique;

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

    procedure branchementBasic(line : in Integer; instructions : in out T_List_Instruction) is
    
    begin
    
        changerInstructionParNumero(instructions,line);
    
    end branchementBasic;

    procedure ecrire(instructions : in out T_List_Instruction; variables : in T_List_Variable) is

        z : Integer;
        nomVariable : Unbounded_String;
        nomIndice : Unbounded_String;
        valeurIndice : Integer;
        op : character;
        op2 : integer;
        indiceDebutRecherche : integer;

    begin

        if (instructions.all.ptrIns.all.operandes.x /= null) then

            nomIndice := instructions.all.ptrIns.all.operandes.x.all.nomVariable;
            valeurIndice := rechercherVariable(variables, nomIndice).all.ptrVar.all.valeurVariable;
            if (length(nomIndice) > 1) then
                op := element(nomIndice, length(nomIndice)-1);
                op2 := Integer'Value((1 => element(nomIndice, length(nomIndice))));
                valeurIndice := operationArithmetique(op, valeurIndice, op2);
            end if;

            indiceDebutRecherche := 1;
            recupererChaine(nomVariable, instructions.all.ptrIns.all.operandes.z.all.nomVariable, indiceDebutRecherche, 3);

            append(nomVariable, "[" & Integer'Image(valeurIndice)(2..Integer'Image(valeurIndice)'length) & "]");

            z := rechercherVariable(variables, nomVariable).all.ptrVar.all.valeurVariable;

        else

            z := instructions.all.ptrIns.all.operandes.z.all.valeurVariable;
            
        end if;

        if (instructions.all.ptrIns.all.operandes.z.all.typeVariable = "Caractere") then
            put(Character'Val(z));
        else
            put(z, 1);
        end if;
        new_line;

        instructions := instructions.all.next;

    end ecrire;

    procedure lire(instructions : in out T_List_Instruction; variables : in T_List_Variable) is

        nomVariable : Unbounded_String;
        nomIndice : Unbounded_String;
        valeurIndice : Integer;
        op : character;
        op2 : integer;
        indiceDebutRecherche : integer;
        chaineLue : Unbounded_String;
        Variable : T_Ptr_Variable;
        variableZ : T_Variable;
        conditionSortie : boolean;

    begin

        variableZ := instructions.all.ptrIns.all.operandes.z.all;

        conditionSortie := false;
        loop
            put("Entrez une chaine de type ");
            put(variableZ.typeVariable);
            put(" pour la variable ");
            put(instructions.all.ptrIns.all.operandes.z.all.nomVariable);
            put(" : ");
            get_line(chaineLue);

            conditionSortie := (length(chaineLue) = 1 and variableZ.typeVariable = "Caractere") or (isANumber(chaineLue) and variableZ.typeVariable = "Entier");
            if (not conditionSortie) then
                put_line("La chaine remplie ne correspond pas au type demandé");
            end if;     
            exit when (conditionSortie);
        end loop;

        if (instructions.all.ptrIns.all.operandes.x = null) then

            if (instructions.all.ptrIns.all.operandes.z.all.typeVariable = "Caractere") then
                instructions.all.ptrIns.all.operandes.z.all.valeurVariable := Character'Pos(element(chaineLue, 1));
            else
                instructions.all.ptrIns.all.operandes.z.all.valeurVariable := Integer'Value(to_string(chaineLue));
            end if;

        else

            nomIndice := instructions.all.ptrIns.all.operandes.x.all.nomVariable;
            valeurIndice := rechercherVariable(variables, nomIndice).all.ptrVar.all.valeurVariable;
            if (length(nomIndice) > 1) then
                op := element(nomIndice, length(nomIndice)-1);
                op2 := Integer'Value((1 => element(nomIndice, length(nomIndice))));
                valeurIndice := operationArithmetique(op, valeurIndice, op2);
            end if;

            indiceDebutRecherche := 1;
            recupererChaine(nomVariable, instructions.all.ptrIns.all.operandes.z.all.nomVariable, indiceDebutRecherche, 3);

            append(nomVariable, "[" & Integer'Image(valeurIndice)(2..Integer'Image(valeurIndice)'length) & "]");

            variable := rechercherVariable(variables, nomVariable).all.ptrVar;

            if (instructions.all.ptrIns.all.operandes.z.all.typeVariable = "Caractere") then
                variable.all.valeurVariable := Character'Pos(element(chaineLue, 1));
            else
                variable.all.valeurVariable := Integer'Value(to_string(chaineLue));
            end if;

        end if;
    end lire;

    procedure branchementConditionel(instructions : in out T_List_Instruction; variables : in T_List_Variable) is
        
        x : Integer;
        z : Integer;
        currentLine : Integer;
        nomVariable : Unbounded_String;
        nomIndice : Unbounded_String;
        valeurIndice : Integer;
        op : character;
        op2 : integer;
        indiceDebutRecherche : integer;

    begin

        if (instructions.all.ptrIns.all.operandes.y /= null and then instructions.all.ptrIns.all.operandes.y.all.typeVariable = "Indice Tableau") then
            
            nomIndice := instructions.all.ptrIns.all.operandes.y.all.nomVariable;
            valeurIndice := rechercherVariable(variables, nomIndice).all.ptrVar.all.valeurVariable;
            if (length(nomIndice) > 1) then
                op := element(nomIndice, length(nomIndice)-1);
                op2 := Integer'Value((1 => element(nomIndice, length(nomIndice))));
                valeurIndice := operationArithmetique(op, valeurIndice, op2);
            end if;

            indiceDebutRecherche := 1;
            recupererChaine(nomVariable, instructions.all.ptrIns.all.operandes.x.all.nomVariable, indiceDebutRecherche, 3);

            append(nomVariable, "[" & Integer'Image(valeurIndice)(2..Integer'Image(valeurIndice)'length) & "]");

            x := rechercherVariable(variables, nomVariable).all.ptrVar.all.valeurVariable;

        else
            x := instructions.all.ptrIns.all.operandes.x.all.valeurVariable;
        end if;

        z := instructions.all.ptrIns.all.operandes.z.all.valeurVariable;
        if(x = 1) then
            branchementBasic(z,instructions);
        else
            currentLine := instructions.all.ptrIns.all.numInstruction;
            branchementBasic(currentLine+1, instructions);
        end if;
    end branchementConditionel;

end operateurs;