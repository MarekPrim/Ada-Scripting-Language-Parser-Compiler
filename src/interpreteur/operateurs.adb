package body operateurs is

    procedure affectation(identificateur : in String; variables : in out variables; valeur : in T) is
        var : variable;

        function recherche(id : in String; variables : in out variables) return variable is
        i : Integer := 1;
        begin
            while variables(i) and then variables(i).identificateur != id and i <= CMAX loop
                i := i + 1;
            end loop;
            return variables(i);
        end recherche;
    begin
        var := recherche(identificateur, variables);
        if var = null then
            raise Variable_Inconnue;
        end if;
        if(var.constant) then
            raise Variable_Constante;
        else
            var.valeur := valeur;
        end if;
    end;
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

    procedure operationLogique(op: in Character; variables : in variable[]; cp : in out Integer, res : out Boolean) is
        resultat : Boolean;
    begin
        case(op) is
            when '=' =>
                resultat := variables[1].valeur = variables[2].valeur;
                null;
            when '<' =>
                resultat := variables[1].valeur < variables[2].valeur;
                null;
            when '>' =>
                resultat := variables[1].valeur > variables[2].valeur;
                null;
            when '<=' =>
                resultat := variables[1].valeur <= variables[2].valeur;
                null;
            when '>=' =>
                resultat := variables[1].valeur >= variables[2].valeur;
                null;
            when others =>
                raise Operateur_Incorrect;
        end case;
        res := resultat;
    end operationLogique;

    procedure branchementBasic(cp : in out Integer; line : in Integer) is
    begin
        cp := line;
    end branchementBasic;

    procedure branchementConditionel(op : in Character; cp : in out Integer; variables : in variable[]; line : in Integer) is
        branch : Boolean := False;
    begin
        operationLogique(op,variables,cp,branch);
        if(branch) then
            branchementBasic(cp,line);
        else
            cp := cp + 1;
        end if;
    end branchementConditionel;

end operateurs;