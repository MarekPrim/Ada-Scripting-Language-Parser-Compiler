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
            if ptrInstruction.all.ptrIns.all.operandes.z.all.typeVariable.str(1..ptrInstruction.all.ptrIns.all.operandes.z.all.typeVariable.nbCharsEffectif) = ptrInstruction.all.ptrIns.all.operandes.x.all.typeVariable.str(1..ptrInstruction.all.ptrIns.all.operandes.x.all.typeVariable.nbCharsEffectif) then
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

    function operationLogique (op : in chaine; op1 : in Integer; op2 : in integer) return integer is
        resultat : boolean;
    begin

        if (op.str(1..op.nbCharsEffectif) = "AND") then
            resultat := (op1 + op2 = 2);
        elsif (op.str(1..op.nbCharsEffectif) = "OR") then
            resultat := (op1 + op2 > 0);
        elsif (op.str(1..op.nbCharsEffectif) = "=") then
            resultat := op1 = op2;
        elsif (op.str(1..op.nbCharsEffectif) = "<") then
            resultat := op1 < op2;
        elsif (op.str(1..op.nbCharsEffectif) = "<=") then
            resultat := op1 <= op2;
        elsif (op.str(1..op.nbCharsEffectif) = ">") then
            resultat := op1 <= op2;
        elsif (op.str(1..op.nbCharsEffectif) = ">=") then
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
        op : String(1..3) := "   ";
        op1 : T_Ptr_Variable;
        op2 : T_Ptr_Variable;
    begin
        op := instructions.all.ptrIns.all.operation.str(1..3);
        op1 := instructions.all.ptrIns.all.operandes.x;
        op2 := instructions.all.ptrIns.all.operandes.y;
        resultat := false;
        if op1.all.typeVariable.str(1..7) = "Booleen" and op2.all.typeVariable.str(1..7) = "Booleen" then
            if op(1..3) = "AND" then
                resultat := op1.all.valeurVariable + op2.all.valeurVariable = 2;
                null;
            elsif op(1..2) = "OR" then
                resultat := op1.all.valeurVariable + op2.all.valeurVariable > 1;
                null;
            else
                raise Operateur_Incorrect;
            end if;
        else 
            if op(1) = '=' then
                    resultat := op1.all.valeurVariable = op2.all.valeurVariable;
                    null;
                elsif op(1) = '<' then
                    resultat := op1.all.valeurVariable < op2.all.valeurVariable;
                    null;
                elsif op(1) = '>' then
                    resultat := op1.all.valeurVariable > op2.all.valeurVariable;
                    null;
                elsif op(1..2) = "<=" then
                    resultat := op1.all.valeurVariable <= op2.all.valeurVariable;
                    null;
                elsif op(1..2) = ">=" then
                    resultat := op1.all.valeurVariable >= op2.all.valeurVariable;
                    null;
                else 
                    raise Operateur_Incorrect;
            end if;
        end if;
        cp := cp + 1;
        res := resultat;
    end operationLogique2;

    procedure branchementBasic(cp : in out Integer; line : in Integer) is
    begin
        cp := line;
    end branchementBasic;

    procedure branchementConditionel(cp : in out Integer; instructions : in T_List_Instruction; line : in Integer) is
        branch : Boolean := False;
    begin
        operationLogique2(instructions,cp,branch);
        if(branch) then
            branchementBasic(cp,line);
        else
            cp := cp + 1;
        end if;
    end branchementConditionel;

end operateurs;