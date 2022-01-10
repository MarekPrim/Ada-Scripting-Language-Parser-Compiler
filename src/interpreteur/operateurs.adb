with intermediaire; use intermediaire; --Permet de partager les types définis dans intermediaire.ads

package body operateurs is

    procedure affectation(typeVariable : in String; identificateur : in String; valeur : in Integer; variables : in out T_List_Variable) is
        var : T_List_Variable;
        ch : Chaine;
    begin
        var := rechercherVariable(variables, identificateur);
        if var = null then
            raise Variable_Inconnue;
        end if;
        if(var.all.ptrVar.all.isConstant) then
            raise Variable_Constante;
        else
            var.all.ptrVar.all.valeurVariable := valeur;
            ch.str(1) := typeVariable(1);
            ch.nbCharsEffectif := 2;
            var.all.ptrVar.all.typeVariable := ch;
        end if;
    end affectation;

    procedure operationArithmetique(op: in String; op1 : in Integer; op2 : in Integer; cp : in out Integer; res : out Integer) is
        resultat : Integer;
    begin
        if op = "+" then
                resultat := op1 + op2;
                null;
        elsif op = "-" then
                resultat := op1 - op2;
                null;
        elsif op =  "*" then
                resultat := op1 * op2;
                null;
        elsif op = "/" then
                resultat := op1 / op2;
                null;
        else
                raise Operateur_Incorrect;
        end if;
        res := resultat;
        cp := cp + 1;
    end operationArithmetique;

    procedure operationLogique(instructions : in T_List_Instruction; cp : in out Integer; res : out Boolean) is
        resultat : Boolean;
        op : String(1..2) := "  ";
        op1 : T_Ptr_Variable;
        op2 : T_Ptr_Variable;
    begin
        op := instructions.all.ptrIns.all.operation.str(1..2);
        op1 := instructions.all.ptrIns.all.operandes(1);
        op2 := instructions.all.ptrIns.all.operandes(2);

        if op = "=" then
                resultat := op1.all.valeurVariable = op2.all.valeurVariable;
                null;
            elsif op="<" then
                resultat := op1.all.valeurVariable < op2.all.valeurVariable;
                null;
            elsif op= ">" then
                resultat := op1.all.valeurVariable > op2.all.valeurVariable;
                null;
            elsif op= "<=" then
                resultat := op1.all.valeurVariable <= op2.all.valeurVariable;
                null;
            elsif op= ">=" then
                resultat := op1.all.valeurVariable >= op2.all.valeurVariable;
                null;
            --elsif op= "&" then
            --    resultat := op1.all.valeurVariable and op2.all.valeurVariable;
            --    null;
            --elsif op= "|" then
            --   resultat := op1.all.valeurVariable or op2.all.valeurVariable;
            --    null;
            else 
                raise Operateur_Incorrect;
        end if;
        cp := cp + 1;
        res := resultat;
    end operationLogique;

    procedure branchementBasic(cp : in out Integer; line : in Integer) is
    begin
        cp := line;
    end branchementBasic;

    procedure branchementConditionel(cp : in out Integer; instructions : in T_List_Instruction; line : in Integer) is
        branch : Boolean := False;
    begin
        operationLogique(instructions,cp,branch);
        if(branch) then
            branchementBasic(cp,line);
        else
            cp := cp + 1;
        end if;
    end branchementConditionel;

end operateurs;