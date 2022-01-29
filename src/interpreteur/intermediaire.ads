with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;
with Ada.Command_Line; use Ada.Command_Line;

package intermediaire is
    -- Enumerations
    type Reserved_Langage_Word is (Programme,Debut, Fin);
     type Type_Defini is (Entier,Booleen); -- Soumis à modification pour la deuxième partie
    Aucune_Variable_Definie : Exception; -- Aucune variable n'est definie dans le programme
    Type_Incorrect : Exception; -- Le type de la variable n'est pas correct pour l'opération à effectuer
    Variable_Non_Declaree : Exception; -- La variable à utiliser n'est pas declaree dans le programme
    Variable_Deja_Definie : Exception; -- La variable a déjà été déclarée dans le programme
    Variable_Non_Trouvee : Exception; -- Variable non trouvée dans la recherche d'une variable
    Acces_Limite : Exception; -- Le compteur CP est hors limite (Ex : Programme avec un corps de 10 lignes et CP = 11) dans le programme
    Fichier_Non_Lisible : Exception;
    Fichier_Non_Trouve : Exception;
    Element_Tableau_Deja_Utilise : Exception;
    Instuction_Not_Found: Exception;

    type Tab_Chaines is array(1..2) of Unbounded_String;

    type T_Chaines_Reservees is record
        chaines : Tab_Chaines;
        nbElements : integer;
    end record;

    type T_Cell_Variable;
    type T_Cell_Instruction;
    type T_Variable;
    type T_Instruction;

    type T_List_Variable is access T_Cell_Variable;
    type T_List_Instruction is access T_Cell_Instruction;

    type T_Ptr_Variable is access T_Variable;
    type T_Ptr_Instruction is access T_Instruction;

    --type T_Operandes is private;
    type T_Operandes is record
        x : T_Ptr_Variable;
        y : T_Ptr_Variable;
        z : T_Ptr_Variable;
    end record;

    type T_Variable is record
        valeurVariable : Integer;
        typeVariable : Unbounded_String;
        nomVariable : Unbounded_String;
        isConstant : Boolean;
    end record;

    type T_Instruction is record
        numInstruction : Integer;
        operandes : T_Operandes;
        operation : Unbounded_String;
    end record;

    type T_Cell_Instruction is record
        ptrIns : T_Ptr_Instruction; 
        prev : T_List_Instruction;
        next : T_List_Instruction;
    end record;

    type T_Cell_Variable is record
        ptrVar : T_Ptr_Variable;
        next : T_List_Variable;
        prev : T_List_Variable;
    end record;

    -- Parse le fichier en lisant une par une les lignes du fichier afin de passer les données aux autres fonctions
    -- Paramètres :
    --  fileName in string : le nom du fichier à lire
    --  listeInstructions in out T_List_Instruction : la liste des instructions
    --  listeVariables in out T_List_Variable : la liste des variables
    -- Préconditions:
    --  aucune
    -- Postconditions
    --  aucune
    -- Exceptions : Aucune_Variable_Definie
    procedure parseFile (fileName : in string; variables : in out T_List_Variable; instructions : in out T_List_Instruction);

    
    -- Wrapper pour le traitement du programme
    -- Paramètres :
    --  fileName in string : le nom du fichier à lire
    -- Préconditions
    --  Aucune
    -- Postconditions
    --  Aucune
    -- Exception
    --  Aucune
    procedure traiter_programme;

    -- nom : recupererVariables
    -- semantique : récupère les variables d'un programme en langage intermédiaire contenues entre 'Début' (exclu) et 'Programme' (exclue)
    -- paramètres :
    --  variables : in out T_List_Variable : la liste des variables
    -- ligne : in Unbounded_string : la ligne à analyser
    -- Préconditions : le programme est correctement formé [Non vérifié dans notre cas]
    -- Postconditions : la liste doublement chainée contient les variables du programme
    -- Exceptions : Aucune_Variable_Definie, Variable_Deja_Definie
     procedure recupererVariables(variables : in out T_List_Variable; ligne : in Unbounded_string);
    
    -- nom : recupererInstructions
    -- semantique : récupère les lignes d'un programme en langage intermédiaire contenues entre 'Début' (exclu) et 'Fin' (exclue)
    -- paramètres 
    --  instructions : in out T_List_Instruction : la liste des instructions
    --  ligne : in Unbounded_string : la ligne à analyser
    -- Préconditions : 
    --                  le fichier est fermé
    --                  le contenu entre 'Début' et 'Fin' n'est pas vide
    -- Postconditions : le fichier est fermé
    procedure recupererInstructions(instructions : in out T_List_Instruction; variables : in out T_List_Variable; ligne : in Unbounded_string);

    -- nom : interpreterCommande
    -- semantique : interprete la ligne pointée par ptrLine
    -- parametres :
    --  ptrLine : in out T_Cell_Instruction : la ligne à interpréter
    --  ptrVar : in out T_List_Variable : la liste des variables
    -- Préconditions    : ptrLigne n'est pas null
    -- Postconditions   : le numéro de la ligne pointée par ptrLine change pendant la procédure
    -- Exceptions       : Acces_Limite
    procedure interpreterCommande (ptrInstruction : in out T_List_Instruction; variables : in T_List_Variable);




   

     

    -- nom : changerInstructionParNumero
    -- semantique : change l'instruction à executer par une autre ligne d'instruction (EX : GOTO)
    -- parametres :
    --          ptrInstruction : T_List_Instruction
    --          numeroInstruction : in integer
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : instuction_not_found
    procedure changerInstructionParNumero(ptrInstruction : in out T_List_Instruction; numInstruction : in integer);

    

   

   

end intermediaire;