generic type T is private;
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
    procedure affectation(typeVariable : in String; identificateur : in String; valeur : in T; ptrvar : in out ptrVariable);

    -- nom : operationArithmetique
    -- semantique : effectue l'operation arithmetique
    -- parametres :
    -- op : operateur arithmetique {+,-,*,/}
    -- op1 : operande 1
    -- op2 : operande 2
    -- cp : indice de l'instruction courante
    -- Précondition : la liste des variables est bien formée; op est un operateur arithmetique
    -- Postcondition : CP est incrémenté de 1
    -- Exceptions : Aucune
    procedure operationArithmetique(op: in Character; op1 : in Integer; op2 : in Integer; cp : in out Integer; res : out Integer);

    -- operationLogique
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
    procedure operationLogique(op: in Character; variables : in variable[]; cp : in out Integer, res : out Boolean);

    -- branchementBasic
    -- Attribution d'un numéro de ligne à CP
    -- Précondition : 
    -- Postcondition :
    -- Exceptions :
    procedure branchementBasic(cp : in out Integer; line : in Integer);

    -- branchementConditionel
    -- Evaluation d'une condition, affectation à CP de line si la condition est vraie sinon incrémentation de CP
    -- Précondition : 
    -- Postcondition :
    -- Exceptions :
    procedure branchementConditionel(op : in Character; cp : in out Integer; variables : in variable[]; line : in Integer);

end operateurs;
