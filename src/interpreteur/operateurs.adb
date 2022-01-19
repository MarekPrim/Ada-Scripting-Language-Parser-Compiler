with intermediaire; use intermediaire; --Permet de partager les types définis dans intermediaire.ads
with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, ADA.IO_EXCEPTIONS;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;

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
            resultat := op1 <= op2;
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

    procedure branchementConditionel(instructions : in out T_List_Instruction) is
        x : Integer;
        z : Integer;
        currentLine : Integer;
    begin
        x := instructions.all.ptrIns.all.operandes.x.all.valeurVariable;
        z := instructions.all.ptrIns.all.operandes.z.all.valeurVariable;
        currentLine := instructions.all.ptrIns.all.numInstruction;
        if(x = 1) then
            branchementBasic(z,instructions);
        else
            branchementBasic(currentLine+1, instructions);
        end if;
    end branchementConditionel;

end operateurs;