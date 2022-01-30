with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded,
   Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, operateurs, operations,
   variables, operations_liste, manipulation_chaine;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded,
   Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, operateurs, operations,
   variables, operations_liste, manipulation_chaine;
with Ada.Command_Line;  use Ada.Command_Line;
with Ada.IO_EXCEPTIONS; use Ada.IO_EXCEPTIONS;

package body intermediaire is

    --package Liste_Variables is new P_List_Double(pointeur => T_List_Variable);
    --use Liste_Variables;
    --package Liste_Instructions is new P_List_Double(pointeur => T_List_Instruction);
    --use Liste_Instructions;

    procedure traiter_programme is

        variables      : T_List_Variable;
        instructions   : T_List_Instruction;
        l_instructions : T_List_Instruction;
        choice         : Integer;
        fileName       : Unbounded_String;

    begin

        begin
            loop
                fileName := To_Unbounded_String (Argument (1));
                exit when (Argument_Count /= 0);
            end loop;

        exception
            when Constraint_Error =>
                Put_Line
                   ("Vous n'avez pas renseigné le fichier à interpréter;");
                Put_Line
                   ("Utilisation du programme : ./main ./chemin_vers_fichier/fichier_souhaité");
                raise Program_Error;
        end;

        if (Argument_Count = 2) then
            choice := (if Argument (2) = "--DEBUG" then 1 else 0);
        else
            choice := 0;
        end if;

        skip_line;

        begin
            parse_file (To_String (fileName), variables, instructions);

        exception
            when Ada.IO_EXCEPTIONS.DEVICE_ERROR =>
                Put_Line ("Fichier inexistant/invalide");
        end;

        pointer_en_tete_instructions (instructions);

        l_instructions := instructions;

        while (l_instructions /= null) loop
            if (choice = 1 and l_instructions.next /= null) then
                Put ("Numéro de l'instruction en cours : ");
                Put (l_instructions.all.ptrIns.all.numInstruction, 1);
                new_line;
            end if;
            interpreter_commande (l_instructions, variables);
        end loop;

        afficher_liste (instructions);
        Put_Line ("Etat des variables en terminaison du programme");
        afficher_liste (variables);

    end traiter_programme;

    -- private
    -- Les sous-programmes suivant ne sont pas déclarés private afin de pouvoir toujours réaliser des tests unitaires
    -- Dans une situation de mise en production, les autres sous-programmes devraient être déclarés private

    procedure parse_file
       (fileName     : in     string; variables : in out T_List_Variable;
        instructions : in out T_List_Instruction)
    is
        F     : File_Type;
        ligne : Unbounded_string;
    begin

        variables := creer_liste_vide;

        instructions := creer_liste_vide;

        Open (F, In_File, fileName);    -- Ouverture du fichier en lecture

        loop
            ligne :=
               renvoyer_ligne_sans_espace
                  (Ada.Text_IO.Unbounded_IO.get_line
                      (f));     -- Lecture de la ligne courante sans espace
            exit when
               (ligne_commence_par_mot_reserve
                   (ligne,
                    Reserved_Langage_Word'Image
                       (Programme)));  -- Tant que la ligne ne commence par un mot réservé
        end loop;

        loop
            ligne :=
               renvoyer_ligne_sans_espace
                  (Ada.Text_IO.Unbounded_IO.get_line
                      (f)); -- Lecture de la ligne courante sans espace
            exit when est_ligne_utile (ligne);
        end loop;

        if (ligne_commence_par_mot_reserve
               (ligne, Reserved_Langage_Word'Image (Debut)))
        then -- Si la ligne commence par un mot réservé
            raise Aucune_Variable_Definie;  -- On lève une exception car cela indique qu'il n'y a pas de variable
        end if;

        loop
            if (est_ligne_utile (ligne))
            then  -- Si la ligne est utile (ie. pas un commentaire )
                recuperer_variables
                   (variables, ligne);   -- Récupération des variables
            end if;
            ligne :=
               renvoyer_ligne_sans_espace
                  (Ada.Text_IO.Unbounded_IO.get_line
                      (f)); -- Lecture de la ligne courante sans espace
            exit when
               (ligne_commence_par_mot_reserve
                   (ligne,
                    Reserved_Langage_Word'Image
                       (Debut))); -- Jusqu'à arriver à 'Debut'
        end loop;

        ligne :=
           renvoyer_ligne_sans_espace (Ada.Text_IO.Unbounded_IO.get_line (f));

        loop
            if (est_ligne_utile (ligne)) then
                recuperer_instructions
                   (instructions, variables,
                    ligne);  -- Récupération des instructions
            end if;
            ligne :=
               renvoyer_ligne_sans_espace
                  (Ada.Text_IO.Unbounded_IO.get_line (f));
            exit when
               (ligne_commence_par_mot_reserve
                   (ligne,
                    Reserved_Langage_Word'Image
                       (Fin)));    -- Jusqu'à arriver à 'Fin'
        end loop;

        Close (F);

    end parse_file;

    function recuperer_numero_instruction_ligne
       (index : in out integer; ligne : in Unbounded_String) return integer
    is

        numInstruction : Unbounded_String;

    begin

        recuperer_chaine (numInstruction, ligne, index, 1);
        return Integer'Value (To_String (numInstruction));

    end recuperer_numero_instruction_ligne;

    procedure recuperer_instructions
       (instructions : in out T_List_Instruction;
        variables    : in out T_List_Variable; ligne : in Unbounded_string)
    is

        i             : integer;
        nomVariableZ  : Unbounded_String;
        nomVariableX  : Unbounded_String;
        typeVariableZ : Unbounded_String;
        nomVariableY  : Unbounded_String;
        operation     : Unbounded_String;
        instruction   : T_Ptr_Instruction;
        isCaractere   : boolean := false;

    begin

        instruction := new T_Instruction;

        -- recuperation du numero de l'instruction
        i                              := 1;
        instruction.all.numInstruction :=
           recuperer_numero_instruction_ligne (i, ligne);

        if (i <= length (ligne) - 1 and then Slice (ligne, i, i + 1) = "IF")
        then
            if_operation (ligne, i, instruction, operation, variables);
        elsif
           (i <= length (ligne) - 3 and then Slice (ligne, i, i + 3) = "GOTO")
        then
            goto_operation (ligne, i, instruction, operation, variables);
        elsif
           (i <= length (ligne) - 3 and then Slice (ligne, i, i + 3) = "NULL")
        then
            null_operation (operation);
        elsif
           (i <= length (ligne) - 5
            and then Slice (ligne, i, i + 5) = "Ecrire")
        then
            ecrire_operation (ligne, i, instruction, operation, variables);
        elsif
           (i <= length (ligne) - 3 and then Slice (ligne, i, i + 3) = "Lire")
        then
            lire_operation (ligne, i, instruction, operation, variables);
        else
            affectation_operation
               (ligne, i, instruction, operation, variables);
        end if;

        instruction.all.operation := operation;
        ajouter (instructions, instruction);

    end recuperer_instructions;

    procedure interpreter_commande
       (instructions : in out T_List_Instruction;
        variables    : in out T_List_Variable)
    is

        nomOperation  : Unbounded_String;
        nomVariable   : Unbounded_String;
        nomIndice     : Unbounded_String;
        nomIndiceReel : Unbounded_String;
        chaineLue     : Unbounded_String;

    begin

        nomOperation := instructions.all.ptrIns.all.operation;

        if (nomOperation = "NULL") then
            branchement_basic
               (instructions, instructions.all.ptrIns.all.numInstruction + 1);
        elsif (nomOperation = "GOTO") then
            -- On passe à l'instruction pointée par la valeur de la variable z de l'instruction ( GOTO z)
            branchement_basic
               (instructions,
                instructions.all.ptrIns.all.operandes.z.all.valeurVariable);
        elsif (nomOperation = "IF") then
            branchement_conditionel (instructions, variables);
        elsif (nomOperation = "ECRIRE") then
            ecrire (instructions, variables);
        elsif (nomOperation = "LIRE") then
            lire (instructions, variables);
        else
            affectation (instructions, variables);
        end if;

    end interpreter_commande;

end intermediaire;
