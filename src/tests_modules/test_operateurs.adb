with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with operateurs; 

procedure test_operateurs is
    
    variables : T_List_Variable;
    search : T_List_Variable;
    package operateurs_int is new operateurs(T=>Integer);
    use operateurs_int;

    instruction : T_List_Instruction;

    operateur : Character;
    op1 : Integer;
    op2 : Integer;
    cp : Integer;
    resultat_arithmetique : Integer;
    resultat_logique : Boolean;
    Chaine: Chaine;
    operandes : T_Operandes;


    

begin
variables := creer_liste_vide;
instruction := creer_liste_vide;
search := creer_liste_vide;
Open (F, In_File, fileName);
        loop
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Programme)));
        end loop;
        ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
        loop
            recupererVariables(variables, ligne);
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));
        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Debut)));
        end loop;
        loop

            recupererInstructions(instructions, ligne);
        
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Fin)));
        end loop;

        Close(F);



    -- Test affectation
        affectation("entier","n",variables, 5);
        search := rechercherVariable(variables,"n");
        if(search.all.ptrVar.all.valeurVariable = 5) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

    -- Test +;-;*;/

        cp :=0;
        op1 := 4;
        op2 := 2;
        resultat_arithmetique := 0;

        operateur := '+';
        operationArithmetique(operateur,op1,op2,cp, resultat_arithmetique);
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
        operationArithmetique(operateur,op1,op2,cp, resultat_arithmetique);
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
        operationArithmetique(operateur,op1,op2,cp,resultat_arithmetique);
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
        operationArithmetique(operateur,op1,op2,cp,resultat_arithmetique);
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
            operationArithmetique(operateur,op1,op2,cp, resultat_arithmetique);

            exception
                when Operateur_Incorrect => Put_Line("OK");
                when others => Put_Line("NOK");
        end;


    -- Test opérateur logique
        affectation("entier","i",variables, 5);
        affectation("entier","n",variables, 2);

        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction(null,null,null);
        Chaine:= Chaine("=",1);
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction(1,operandes,chaine);

        operationLogique(instruction,cp,resultat_logique);
        if(resultat_logique = false) then
            write("OK");
        else
            write("KO");
        end if;


        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction(null,null,null);
        Chaine:= Chaine(">",1);
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction(1,operandes,chaine);
        operationLogique(operateur,instruction,cp,resultat_logique);
        if(resultat_logique = true) then
            write("OK");
        else
            write("KO");
        end if;

        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction(null,null,null);
        Chaine:= Chaine("<",1);
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction(1,operandes,chaine);
        operationLogique(operateur,instruction,cp,resultat_logique);
        if(resultat_logique = false) then
            write("OK");
        else
            write("KO");
        end if;


instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction(null,null,null);
        Chaine:= Chaine(">=",2);
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction(1,operandes,chaine);
        operationLogique(operateur,instruction,cp,resultat_logique);
        if(resultat_logique = true) then
            write("OK");
        else
            write("KO");
        end if;

instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction(null,null,null);
        Chaine:= Chaine("<=",2);
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction(1,operandes,chaine);

        operationLogique(operateur,instruction,cp,resultat_logique);
        if(resultat_logique = false) then
            write("OK");
        else
            write("KO");
        end if;

        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction(null,null,null);
        Chaine:= Chaine("&",1);
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction(1,operandes,chaine);
        operationLogique(operateur,instruction,cp,resultat_logique);
        if(resultat_logique = false) then
            write("OK");
        else
            write("KO");
        end if;

        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction(null,null,null);
        Chaine:= Chaine("|",1);
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction(1,operandes,chaine);
        operationLogique(operateur,instruction,cp,resultat_logique);
        if(resultat_logique = true) then
            write("OK");
        else
            write("KO");
        end if;


    -- Test branchement basique
        cp := 0;

        branchementBasic(cp,3);
        if(cp = 3) then
            write("Branchement OK");
        else
            write("Branchement KO");
        end if;

    -- Test branchement conditionnel
        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction(null,null,null);
        Chaine:= Chaine("=",1);
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction(1,operandes,chaine);
        cp := 0;
        affectation("entier","i",variables, 5);
        affectation("entier","n",variables, 2);

        branchementConditionnel(cp,instruction,33);
        if(cp = 33) then
            write("Branchement OK");
        else
            write("Branchement KO");
        end if;


        

end test_operateurs;