with intermediaire, Ada.Strings.Unbounded; 
use intermediaire, Ada.Strings.Unbounded;
--generic type T is private;
package operateurs is

    Variable_Inconnue : Exception;
    Variable_Constante : Exception;
    Operateur_Incorrect : Exception;


    -- nom : affectation
    -- semantique : affectation d'une valeur a une variable identifiée par son nom/identificateur
    -- paramètres :
    --      identificateur : in String // nom de la variable
    --      valeur : in T // valeur a affecter
    --      ptrVariable : in ptrVariable        // pointeur sur les variables
    -- Préconditions : 
    -- Postconditions : 
    --                  ptrVar.all.valeur = T
    --                  ptrVar.all.typeVariable = typeVariable
    --                  ptrVar.all.identificateur = identificateur
    -- Exceptions : Variable_Inconnue, Variable_Constante
        procedure affectation(instructions : in out T_List_Instruction; variables : in out T_List_Variable);

    -- nom : operation_arithmetique
    -- semantique : effectue l'operation arithmetique
    -- parametres :
    -- op : operateur arithmetique {+,-,*,/}
    -- op1 : operande 1
    -- op2 : operande 2
    -- cp : indice de l'instruction courante
    -- Précondition : la liste des variables est bien formée; op est un operateur arithmetique
    -- Postcondition : CP est incrémenté de 1
    -- Exceptions : Operateur_Incorrect
    function operation_arithmetique(op: in Character; op1 : in Integer; op2 : in Integer) return integer;
    
    -- operation_logique
    -- Retourne si une opération logique est vraie ou fausse
    -- Paramètres :
        -- op : le caractère représentant l'opération logique {OR ; AND ; NOT}
        -- variables : la liste des variables à utiliser, différenciée des variables du programme
        -- cp : le compteur de ligne
    -- Retourne :
        -- true si l'opération logique est vraie, false sinon
    -- Préconditions : op est bien un opérateur logique
    -- Postconditions : 
    -- Exceptions : 
    function operation_logique (op : in Unbounded_String; op1 : in Integer; op2 : in integer) return integer;

    -- successeur
    -- Retourne le successeur d'un charactère
    -- Paramètres :
        -- char : in Character
    -- Retourne :
        -- le successeur du charactère
    -- Préconditions : /
    -- Postconditions : /
    -- Exceptions : /
    function successeur(char : in Character) return Character;

    -- predecesseur
    -- Retourne le predecesseur d'un charactère
    -- Paramètres :
        -- char : in Character
    -- Retourne :
        -- le predecesseur du charactère
    -- Préconditions : /
    -- Postconditions : /
    -- Exceptions : /
    function predecesseur(char : in Character) return Character;

    -- nom : branchement_basic
    -- semantique : change l'instruction à executer par une autre ligne d'instruction (EX : GOTO)
    -- parametres :
    --          instructions : T_List_Instruction
    --          numeroInstruction : in integer
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    procedure branchement_basic(instructions : in out T_List_Instruction; numInstruction : in integer);

    -- branchement_conditionel
    -- Evaluation d'une condition, affectation à CP de line si la condition est vraie sinon incrémentation de CP
    -- Précondition : 
    -- Postcondition :
    -- Exceptions :
    procedure branchement_conditionel(instructions : in out T_List_Instruction; variables : in T_List_Variable);

    -- ecrire
    -- Ecriture d'une chaine de caractère sur la sortie standard
    -- Précondition : /
    -- Postcondition : /
    -- Exceptions : /
    -- Paramètres :
        -- instructions : in out T_List_Instruction
        -- variables : in T_List_Variable
    procedure ecrire(instructions : in out T_List_Instruction; variables : in T_List_Variable);

    -- lire
    -- Lecture d'une chaine de caractère sur la sortie standard
    -- Précondition : /
    -- Postcondition : /
    -- Exceptions : /
    -- Paramètres :
        -- instructions : in out T_List_Instruction
        -- variables : in T_List_Variable
    procedure lire(instructions : in out T_List_Instruction; variables : in T_List_Variable);

    

end operateurs;
