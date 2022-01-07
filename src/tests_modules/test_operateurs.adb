with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with operateurs; 

procedure test_operateurs is
    
    TYPE Tab_Entiers is array(1.. 2) of Integer;
    TYPE Tab_Boolean is array(1.. 2) of Boolean;
    TYPE Tab_Variables is array(1..2) of variable;

    variables : ptrVariable;
    package operateurs_int is new operateurs(T=>Integer);
    use operateurs_int;

    operateur : Character;
    op1 : Integer;
    op2 : Integer;
    cp : Integer;
    resultat_arithmetique : Integer;
    resultat_logique : Boolean;
    
    tab_i : Tab_Entiers;
    tab_b : Tab_Boolean;
    tab_v : Tab_Variables;

    

begin

variables := new new variable'(null,"entier","test",false, null, null);
variables.all.next := new variable'(2,"entier","test2",false, null, variables);
variables.all.next.all.next := new variable'(2,"entier","test_constant",false, null, variables.all.next);

    -- Test affectation
        affectation("entier","test",1,variables);
        if(variables.all.valeur = 1) then
            write("Affectation OK");
        else
            write("Affectation KO");
        end if;

        begin
            affectation("entier","test_constant",1,variables);

            exception
                when Variable_Constante => Put_Line("OK");
                when others => Put_Line("NOK");
        end;

    -- Test +;-;*;/
        cp :=0;
        op1 := 4;
        op2 := 2;
        resultat_arithmetique := 0;

        operateur := '+';
        operationArithmetique(operateur,op1,op2,cp; resultat_arithmetique);
        if(resultat_arithmetique = 6) then
            write("Operation arithmetique OK");
        else
            write("Operation arithmetique KO");
        end if;

        if(cp = 1) then
            write("Operation arithmetique OK");
        else
            write("Operation arithmetique KO");
        end if;

        operateur := '-';
        operationArithmetique(operateur,op1,op2,cp; resultat_arithmetique);
        if(resultat_arithmetique = 2) then
            write("Operation arithmetique OK");
        else
            write("Operation arithmetique KO");
        end if;
        if(cp = 2) then
            write("Operation arithmetique OK");
        else
            write("Operation arithmetique KO");
        end if;

        operateur := '*';
        operationArithmetique(operateur,op1,op2,cp; resultat_arithmetique);
        if(resultat_arithmetique = 8) then
            write("Operation arithmetique OK");
        else
            write("Operation arithmetique KO");
        end if;
        if(cp = 3) then
            write("Operation arithmetique OK");
        else
            write("Operation arithmetique KO");
        end if;

        operateur := '/';
        operationArithmetique(operateur,op1,op2,cp; resultat_arithmetique);
        if(resultat_arithmetique = 2) then
            write("Operation arithmetique OK");
        else
            write("Operation arithmetique KO");
        end if;
        if(cp = 4) then
            write("Operation arithmetique OK");
        else
            write("Operation arithmetique KO");
        end if;

        begin
            operateur := "^";
            operationArithmetique(operateur,op1,op2,cp; resultat_arithmetique);

            exception
                when Operateur_Incorrect => Put_Line("OK");
                when others => Put_Line("NOK");
        end;

    -- Test opérateur logique
        tab_i:= (1,2);
        tab_b:= (true,false);
        resultat_logique := False;
        operateur := '&';
        
        operationLogique(operateur,tab_i,cp,resultat_logique);
        if(resultat_logique = true) then -- TRUE -> ∀x, x ≠ 0
            write("Operation logique OK");
        else
            write("Operation logique KO");
        end if;

        if(cp = 1) then
            write("Operation logique OK");
        else
            write("Operation logique KO");
        end if;

        operationLogique(operateur,tab_b,cp,resultat_logique);
        if(resultat_logique = false) then 
            write("Operation logique OK");
        else
            write("Operation logique KO");
        end if;
        if(cp = 2) then
            write("Operation logique OK");
        else
            write("Operation logique KO");
        end if;

        operateur := '|';
        operationLogique(operateur,tab_b,cp,resultat_logique);
        if(resultat_logique = true) then 
            write("Operation logique OK");
        else
            write("Operation logique KO");
        end if;

        if(cp = 3) then
            write("Operation logique OK");
        else
            write("Operation logique KO");
        end if;

        operateur := '=';
        operationLogique(operateur,tab_i,cp,resultat_logique);
        if(resultat_logique = false) then 
            write("Operation logique OK");
        else
            write("Operation logique KO");
        end if;
        
        if(cp = 4) then
            write("Operation logique OK");
        else
            write("Operation logique KO");
        end if;

        operateur := '<';
        operationLogique(operateur,tab_i,cp,resultat_logique);
        if(resultat_logique = true) then 
            write("Operation logique OK");
        else
            write("Operation logique KO");
        end if;

        operateur := '>';
        operationLogique(operateur,tab_i,cp,resultat_logique);
        if(resultat_logique = false) then 
            write("Operation logique OK");
        else
            write("Operation logique KO");
        end if;

        begin
            operateur := "^";
            operationLogique(operateur,tab_i,cp,resultat_logique);

            exception
                when Operateur_Incorrect => Put_Line("OK");
                when others => Put_Line("NOK");
        end;

    
    -- Test branchement basique
        cp := 0;

        branchementBasic(cp,3);
        if(cp = 3) then
            write("Branchement OK");
        else
            write("Branchement KO");
        end if;

    -- Test branchement conditionnel

        operateur := '=';
        tab_v := (variables,variables.all.next);
        cp := 0;

        branchementConditionel(operateur,cp,tab_v,33);

        if(cp = 1) then
            write("Branchement OK");
        else
            write("Branchement KO");
        end if;

        affectation("entier","test",2,variables);
        branchementConditionel(operateur,cp,tab_v,33);

        if(cp = 33) then
            write("Branchement OK");
        else
            write("Branchement KO");
        end if;

end test_operateurs;