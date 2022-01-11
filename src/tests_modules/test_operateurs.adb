with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
with operateurs; use operateurs;
with intermediaire; use intermediaire;

procedure test_operateurs is
    
    variables : T_List_Variable;
    search : T_List_Variable;
    --package operateurs_int is new operateurs(T=>Integer);
    --use operateurs_int;

    instruction : T_List_Instruction;

    operateur : String(1..2);
    op1 : Integer;
    op2 : Integer;
    cp : Integer;
    resultat_arithmetique : Integer;
    resultat_logique : Boolean;
    chaine: intermediaire.Chaine;
    operandes : T_Operandes;
    F         : File_Type;
    fileName : constant string :=  "code_test.med";
    ligne : Unbounded_string;

    

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

            recupererInstructions(instruction, ligne);
        
            ligne := renvoyerLigneSansEspace(Ada.Text_IO.Unbounded_IO.get_line(f));

        exit when (ligneCommenceParMotReserve(ligne, Reserved_Langage_Word'Image(Fin)));
        end loop;

        Close(F);



    -- Test affectation
        affectation("Entier","n",5,variables);
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

        operateur := "+";
        operationArithmetique(operateur,op1,op2,cp, resultat_arithmetique);
        if(resultat_arithmetique = 6) then
            Put_Line("Operation arithmetique OK");
        else
            Put_Line("Operation arithmetique KO");
        end if;

        if(cp = 1) then
            Put_Line("Operation arithmetique OK");
        else
            Put_Line("Operation arithmetique KO");
        end if;

        operateur := "-";
        operationArithmetique(operateur,op1,op2,cp, resultat_arithmetique);
        if(resultat_arithmetique = 2) then
            Put_Line("Operation arithmetique OK");
        else
            Put_Line("Operation arithmetique KO");
        end if;
        if(cp = 2) then
            Put_Line("Operation arithmetique OK");
        else
            Put_Line("Operation arithmetique KO");
        end if;

        operateur := "*";
        operationArithmetique(operateur,op1,op2,cp,resultat_arithmetique);
        if(resultat_arithmetique = 8) then
            Put_Line("Operation arithmetique OK");
        else
            Put_Line("Operation arithmetique KO");
        end if;
        if(cp = 3) then
            Put_Line("Operation arithmetique OK");
        else
            Put_Line("Operation arithmetique KO");
        end if;

        operateur := "/";
        operationArithmetique(operateur,op1,op2,cp,resultat_arithmetique);
        if(resultat_arithmetique = 2) then
            Put_Line("Operation arithmetique OK");
        else
            Put_Line("Operation arithmetique KO");
        end if;
        if(cp = 4) then
            Put_Line("Operation arithmetique OK");
        else
            Put_Line("Operation arithmetique KO");
        end if;

        begin
            operateur := "^";
            operationArithmetique(operateur,op1,op2,cp, resultat_arithmetique);

            exception
                when Operateur_Incorrect => Put_Line("OK");
                when others => Put_Line("NOK");
        end;


    -- Test opérateur logique
        affectation("Entier","i",5, variables);
        affectation("Entier","n",2, variables);

        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction'(null,null,null);
        chaine.str(1) := '=';
        chaine.nbCharsEffectif := 1;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction'(1,operandes,chaine);

        operationLogique(instruction,cp,resultat_logique);
        if(resultat_logique = false) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;


        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction'(null,null,null);
        chaine.str(1) := '>';
        chaine.nbCharsEffectif := 1;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        operationLogique(instruction,cp,resultat_logique);
        if(resultat_logique = true) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction'(null,null,null);
        chaine.str(1) := '<';
        chaine.nbCharsEffectif := 1;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        operationLogique(instruction,cp,resultat_logique);
        if(resultat_logique = false) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;


instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction'(null,null,null);
        chaine.str(1..2) := ">=";
        chaine.nbCharsEffectif := 2;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        operationLogique(instruction,cp,resultat_logique);
        if(resultat_logique = true) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction'(null,null,null);
        chaine.str(1..2) := "<=";
        chaine.nbCharsEffectif := 2;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction'(1,operandes,chaine);

        operationLogique(instruction,cp,resultat_logique);
        if(resultat_logique = false) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction'(null,null,null);
        chaine.str(1) := '&';
        chaine.nbCharsEffectif := 1;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        operationLogique(instruction,cp,resultat_logique);
        if(resultat_logique = false) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;

        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction'(null,null,null);
        chaine.str(1) := '|';
        chaine.nbCharsEffectif := 1;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        operationLogique(instruction,cp,resultat_logique);
        if(resultat_logique = true) then
            Put_Line("OK");
        else
            Put_Line("KO");
        end if;


    -- Test branchement basique
        cp := 0;

        branchementBasic(cp,3);
        if(cp = 3) then
            Put_Line("Branchement OK");
        else
            Put_Line("Branchement KO");
        end if;

    -- Test branchement conditionnel
        instruction := creer_liste_vide;
        instruction := new T_Cell_Instruction'(null,null,null);
        chaine.str(1) := '=';
        chaine.nbCharsEffectif := 1;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instruction.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        cp := 0;
        affectation("Entier","i",5, variables);
        affectation("Entier","n",2, variables);

        branchementConditionel(cp,instruction,33);
        if(cp = 33) then
            Put_Line("Branchement OK");
        else
            Put_Line("Branchement KO");
        end if;


        

end test_operateurs;