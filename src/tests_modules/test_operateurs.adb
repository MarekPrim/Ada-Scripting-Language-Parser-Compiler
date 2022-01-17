with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
with operateurs; use operateurs;
with intermediaire; use intermediaire;

procedure test_operateurs is
    
    variables : T_List_Variable;
    search : T_List_Variable;
    --package operateurs_int is new operateurs(T=>Integer);
    --use operateurs_int;

    instructions : T_List_Instruction;
    instruction : T_List_Instruction;
    operateur : String(1..2);
    op1 : Integer;
    op2 : Integer;
    cp : Integer;
    resultat_arithmetique : Integer;
    resultat_logique : Integer;
    chaine: intermediaire.Chaine;
    operandes : T_Operandes;
    F         : File_Type;
    fileName : constant string :=  "code_test.med";
    ligne : Unbounded_string;
    chne : intermediaire.Chaine;

    

begin



variables := creer_liste_vide;
instructions := creer_liste_vide;
search := creer_liste_vide;
parseFile(fileName, variables, instructions);
instruction := creer_liste_vide;

        afficher_liste(instructions);
    -- Test affectation
        instruction := instructions;
        pointerEnTeteInstructions(instruction);
        affectation(instruction);
        
        --search := rechercherVariable(variables,chne);
        new_line;
        Put(instruction.all.ptrIns.all.operandes.x.all.valeurVariable);
        new_line;
        Put(instruction.all.ptrIns.all.operandes.z.all.valeurVariable);
        new_line;
        if(instruction.all.ptrIns.all.operandes.x.all.valeurVariable = 5) then
            Put_Line("OK affectation");
        else
            Put_Line("KO affectation");
        end if;

    -- Test +;-;*;/

        cp :=0;
        op1 := 4;
        op2 := 2;
        resultat_arithmetique := 0;

        --operateur(1) := '+';
        resultat_arithmetique := operationArithmetique('+',op1,op2);
        if(resultat_arithmetique = 6) then
            Put_Line("Operation arithmetique + OK");
        else
            Put_Line("Operation arithmetique + KO");
        end if;



        --operateur(1) := '-';
        resultat_arithmetique := operationArithmetique('-',op1,op2);
        if(resultat_arithmetique = 2) then
            Put_Line("Operation arithmetique - OK");
        else
            Put_Line("Operation arithmetique - KO");
        end if;


        --operateur(1) := '*';
        resultat_arithmetique := operationArithmetique('*',op1,op2);
        if(resultat_arithmetique = 8) then
            Put_Line("Operation arithmetique * OK");
        else
            Put_Line("Operation arithmetique * KO");
        end if;


        --operateur(1) := '/';
        resultat_arithmetique := operationArithmetique('/',op1,op2);
        if(resultat_arithmetique = 2) then
            Put_Line("Operation arithmetique / OK ");
        else
            Put_Line("Operation arithmetique / KO ");
        end if;


        begin
            operateur(1) := '^';
             resultat_arithmetique := operationArithmetique(':',op1,op2);

            exception
                when Operateur_Incorrect => Put_Line("OK exception : Operateur_Incorrect");
                when others => Put_Line("NOK");
        end;


    -- Test opérateur logique
        -- Retour au début de la liste de variables
            while(variables.all.prev /= null) loop
                variables := variables.all.prev;
            end loop;
        op1 := 2;
        op2 := 4;
        chne.nbCharsEffectif := 1;
        chne.str(1) := 'i';
        --affectation("Entier",chne,5, variables);
        --chne.str(1) := 'n';
        --affectation("Entier",chne,2, variables);
        
        instructions := creer_liste_vide;
        instructions := new T_Cell_Instruction'(null,null,null);
        chaine.str(1) := '=';
        chaine.nbCharsEffectif := 1;
        operandes.x := variables.all.ptrVar;
        operandes.y := variables.all.next.all.ptrVar;
        operandes.z := null;
        instructions.all.ptrIns := new T_Instruction'(1,operandes,chaine);

        resultat_logique := operationLogique(chaine,op1,op2);
        if(resultat_logique = 0) then
            Put_Line("OK operation logique ="); 
        else
            Put_Line("KO  operation logique =");
        end if;


        instructions := creer_liste_vide;
        instructions := new T_Cell_Instruction'(null,null,null);
        chaine.str(1) := '>';
        chaine.nbCharsEffectif := 1;
        instructions.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        resultat_logique := operationLogique(chaine,op1,op2);
        if(resultat_logique = 0) then
            Put_Line("OK operation logique >");
        else
            Put_Line("KO operation logique >");
        end if;

        instructions := creer_liste_vide;
        instructions := new T_Cell_Instruction'(null,null,null);
        chaine.str(1) := '<';
        chaine.nbCharsEffectif := 1;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instructions.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        resultat_logique := operationLogique(chaine,op1,op2);
        if(resultat_logique = 1) then
            Put_Line("OK operation logique <");
        else
            Put_Line("KO operation logique <");
        end if;


instructions := creer_liste_vide;
        instructions := new T_Cell_Instruction'(null,null,null);
        chaine.str(1..2) := ">=";
        chaine.nbCharsEffectif := 2;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instructions.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        resultat_logique := operationLogique(chaine,op1,op2);
        if(resultat_logique = 0) then
            Put_Line("OK operation logique >= ");
        else
            Put_Line("KO operation logique >= ");
        end if;

        instructions := creer_liste_vide;
        instructions := new T_Cell_Instruction'(null,null,null);
        chaine.str(1..2) := "<=";
        chaine.nbCharsEffectif := 2;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instructions.all.ptrIns := new T_Instruction'(1,operandes,chaine);

        resultat_logique := operationLogique(chaine,op1,op2);
        if(resultat_logique = 1) then
            Put_Line("OK operation logique <= ");
        else
            Put_Line("KO operation logique <= ");
        end if;

        instructions := creer_liste_vide;
        instructions := new T_Cell_Instruction'(null,null,null);
        chaine.str(1..3) := "AND";
        chaine.nbCharsEffectif := 3;
        variables.all.ptrVar.typeVariable.str(1..7) := "Booleen";
        variables.all.next.all.ptrVar.typeVariable.str(1..7) := "Booleen";
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instructions.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        resultat_logique := operationLogique(chaine,op1,op2);
        if(resultat_logique = 0) then
            Put_Line("OK operation logique & ");
        else
            Put_Line("KO operation logique & ");
        end if;

        instructions := creer_liste_vide;
        instructions := new T_Cell_Instruction'(null,null,null);
        chaine.str(1..2) := "OR";
        chaine.nbCharsEffectif := 2;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instructions.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        resultat_logique := operationLogique(chaine,op1,op2);
        if(resultat_logique = 1) then
            Put_Line("OK operation logique | ");
        else
            Put_Line("KO operation logique | ");
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
        instructions := creer_liste_vide;
        instructions := new T_Cell_Instruction'(null,null,null);
        chaine.str(1) := '<';
        chaine.nbCharsEffectif := 1;
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instructions.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        cp := 0;
        chne.nbCharsEffectif := 1;
        chne.str(1) := 'i';

        --affectation("Entier",chne,5, variables);
        --chne.str(1) := 'n';
        --affectation("Entier",chne,2, variables);

        branchementConditionel(cp,instructions,33);
        if(cp = 33) then
            Put_Line("Branchement conditionel OK");
        else
            Put_Line("Branchement conditionel KO");
        end if;


        

end test_operateurs;