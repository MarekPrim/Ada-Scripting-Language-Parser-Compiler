with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;
with operateurs; use operateurs;
with intermediaire; use intermediaire;
with operations; use operations;
with manipulation_chaine; use manipulation_chaine;
with variables; use variables;
with operations_liste; use operations_liste;

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
    chaine: Unbounded_String;
    operandes : T_Operandes;
    F         : File_Type;
    fileName : constant string :=  "code_test.med";
    fileNameGoto : constant String := "code_test_goto.med";
    ligne : Unbounded_string;
    chne : Unbounded_String;

    charac : Character;

    

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
        affectation(instruction, variables);
        instruction := instruction.all.prev;
        
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
        
        chne := To_Unbounded_String("i");
        --affectation("Entier",chne,5, variables);
        --chne.str(1) := 'n';
        --affectation("Entier",chne,2, variables);
        
        instructions := creer_liste_vide;
        instructions := new T_Cell_Instruction'(null,null,null);
        chaine := To_Unbounded_String("=");
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
        chaine := To_Unbounded_String(">");
        instructions.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        resultat_logique := operationLogique(chaine,op1,op2);
        if(resultat_logique = 0) then
            Put_Line("OK operation logique >");
        else
            Put_Line("KO operation logique >");
        end if;

        instructions := creer_liste_vide;
        instructions := new T_Cell_Instruction'(null,null,null);
        chaine := To_Unbounded_String("<");
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
        chaine := To_Unbounded_String(">=");
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
        chaine := To_Unbounded_String("<=");
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
        chaine := To_Unbounded_String("AND");

        variables.all.ptrVar.typeVariable := To_Unbounded_String("Booleen");
        variables.all.next.all.ptrVar.typeVariable := To_Unbounded_String("Booleen");
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
        chaine := To_Unbounded_String("OR");
        operandes := (variables.all.ptrVar,variables.all.next.ptrVar,null);
        instructions.all.ptrIns := new T_Instruction'(1,operandes,chaine);
        resultat_logique := operationLogique(chaine,op1,op2);
        if(resultat_logique = 1) then
            Put_Line("OK operation logique | ");
        else
            Put_Line("KO operation logique | ");
        end if;


    -- Test branchement basique

        instructions := creer_liste_vide;
        variables := creer_liste_vide;
        parseFile(fileNameGoto, variables, instructions);

        branchementBasic(instructions, 3);
        if(instructions.all.ptrIns.all.numInstruction = 3) then
            Put_Line("OK branchement basique");
        else
            Put_Line("KO branchement basique");
        end if;

        branchementConditionel(instructions, variables);
        if(instructions.all.ptrIns.all.numInstruction = 4) then
            Put_Line("OK branchement conditionnel");
        else
            Put_Line("KO branchement conditionnel");
        end if;



    -- Test opérations character
        
        charac := 'c';
        if(successeur(charac) = 'd') then
            Put_Line("OK successeur");
        else
            Put_Line("KO successeur");
        end if;

        if(predecesseur(charac) = 'b') then
            Put_Line("OK predecesseur");
        else
            Put_Line("KO predecesseur");
        end if;
        

end test_operateurs;