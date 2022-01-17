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

    procedure operationLogique2(instructions : in T_List_Instruction; cp : in out Integer; res : out Boolean) is
        resultat : Boolean;
        op : Unbounded_String;
        op1 : T_Ptr_Variable;
        op2 : T_Ptr_Variable;
    begin
        op := instructions.all.ptrIns.all.operation;
        op1 := instructions.all.ptrIns.all.operandes.x;
        op2 := instructions.all.ptrIns.all.operandes.y;
        resultat := false;

        if op1.all.typeVariable = "Booleen" and op2.all.typeVariable = "Booleen" then
            Put_Line("Bool");
            if op = "AND" then
                resultat := op1.all.valeurVariable + op2.all.valeurVariable = 2;
                null;
            elsif op = "OR" then
                resultat := op1.all.valeurVariable + op2.all.valeurVariable > 1;
                null;
            else
                raise Operateur_Incorrect;
            end if;
        else 
            if op = "=" then
                    resultat := op1.all.valeurVariable = op2.all.valeurVariable;
                    null;
                elsif op = "<" then
                    resultat := op1.all.valeurVariable < op2.all.valeurVariable;
                    null;
                elsif op = ">" then
                    resultat := op1.all.valeurVariable > op2.all.valeurVariable;
                    null;
                elsif op = "<=" then
                    resultat := op1.all.valeurVariable <= op2.all.valeurVariable;
                    null;
                elsif op = ">=" then
                    resultat := op1.all.valeurVariable >= op2.all.valeurVariable;
                    null;
                else 
                    raise Operateur_Incorrect;
            end if;
        end if;
        cp := cp + 1;
        res := resultat;
    end operationLogique2;

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