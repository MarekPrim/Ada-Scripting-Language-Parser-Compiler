package body operateurs is

    procedure affectation(identificateur : in String; variables : in out T_List_Variable; valeur : in T) is
        var : variable;

    begin
        var := rechercherVariable(variables, identificateur);
        if var = null then
            raise Variable_Inconnue;
        end if;
        if(var.all.ptrVar.all.isConstant) then
            raise Variable_Constante;
        else
            var.all.ptrVar.all.valeurVariable := valeur;
        end if;
    end affectation;

    procedure operationArithmetique(op: in Character; op1 : in Integer; op2 : in Integer; cp : in out Integer; res : out Integer) is
        resultat : Integer;
    begin
        case(op) is
            when '+' =>
                resultat := op1 + op2;
                null;
            when '-' =>
                resultat := op1 - op2;
                null;
            when '*' =>
                resultat := op1 * op2;
                null;
            when '/' =>
                resultat := op1 / op2;
                null;
            when others =>
                raise Operateur_Incorrect;
        end case;
        res := resultat;
        cp := cp + 1;
    end operationArithmetique;

    procedure operationLogique(instructions : in T_Instruction; cp : in out Integer, res : out Boolean) is
        resultat : Boolean;
        op : String;
        op1 : T_Ptr_Variable;
        op2 : T_Ptr_Variable;
    begin
        op := instructions.all.operateur.string;
        op1 := instructions.all.operande1.all.ptrVar;
        op2 := instructions.all.operande2.all.ptrVar;

        case(op) is
            when '=' =>
                resultat := op1.all.valeurVariable = op2.all.valeurVariable;
                null;
            when '<' =>
                resultat := op1.all.valeurVariable < op2.all.valeurVariable;
                null;
            when '>' =>
                resultat := op1.all.valeurVariable > op2.all.valeurVariable;
                null;
            when '<=' =>
                resultat := op1.all.valeurVariable <= op2.all.valeurVariable;
                null;
            when '>=' =>
                resultat := op1.all.valeurVariable >= op2.all.valeurVariable;
                null;
            when others =>
                raise Operateur_Incorrect;
        end case;
        cp := cp + 1;
        res := resultat;
    end operationLogique;

    procedure branchementBasic(cp : in out Integer; line : in Integer) is
    begin
        cp := line;
    end branchementBasic;

    procedure branchementConditionel(op : in Character; cp : in out Integer; instructions : in T_Instruction; line : in Integer) is
        branch : Boolean := False;
    begin
        operationLogique(instruction,cp,branch);
        if(branch) then
            branchementBasic(cp,line);
        else
            cp := cp + 1;
        end if;
    end branchementConditionel;

end operateurs;