package operateurs is


    function operationArithmetique(op: in Caracter; variables : in variable[]; cp : in out Integer) return Integer;

    -- operationLogique
    -- Retourne si une opération logique est vraie ou fausse
    -- Paramètres :
        -- op : le caractère représentant l'opération logique {OR ; AND ; NOT}
        -- variables : la liste des variables à utiliser, différenciée des variables du programme
        -- cp : le compteur de ligne
    -- Retourne :
        -- true si l'opération logique est vraie, false sinon
    -- Préconditions : 
    -- Postconditions : 
    -- Exceptions : 
    function operationLogique(op: in Caracter; variables : in variable[]; cp : in out Integer) return Boolean;

    procedure branchementBasic(cp : in out Integer; line : in Integer);