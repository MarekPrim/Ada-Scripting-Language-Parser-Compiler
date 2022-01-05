
package intermediaire is
-- Enumerations
 type Reserved_Langage_Word is (Programme,Debut, Fin, est);
    SMAX : constant integer := 100;        -- taille d'un string
    TMAX : constant integer := 100;        -- taille du tableau de string
    CMAX : constant integer := 100;        -- taille du tableau de variables

    Aucune_Variable_Definie : Exception; -- Aucune variable n'est definie dans le programme
    Type_Incorrect : Exception; -- Le type de la variable n'est pas correct pour l'opération à effectuer
    Variable_Non_Declaree : Exception; -- La variable à utiliser n'est pas declaree dans le programme
    Variable_Deja_Definie : Exception; -- La variable a déjà été déclarée dans le programme
    Acces_Limite : Exception; -- Le compteur CP est hors limite (Ex : Programme avec un corps de 10 lignes et CP = 11) dans le programme

    type variable;

    type ptrVariable is access variable;

    TYPE lignes is array(1.. TMAX) of String(1..SMAX);

    type record_lignes is record
        tab_lignes : lignes;
        nb_lignes : integer;
    end record;

    type variable is record
        valeur : integer; --{T : Integer || Character || [Integer] || [Boolean] || String[Capacite] || String}
        typeVariable : String(1..SMAX);
        identificateur : String(1..SMAX);
        isConstant : Boolean;
    end record;

    type variables is array(1..CMAX) of variable;

    type record_variables is record
        tab_variables : variables;
        nb_variables : integer;
    end record;

    --procedure traiterProgramme(); //appelera le parser, partie visible par l'utilisateur
    procedure traiterProgramme(fileName : in string);
    
    -- nom : initialiserInstructions
    -- semantique : parcoure les lignes du fichier et stocke ces lignes dans le tableau instructions
    -- parametres : fileName : in string        nom du fichier à interpréter
    -- Préconditions : le fichier est fermé
    -- Postconditions : le fichier est fermé
    function initialiserInstructions(fileName : in string) return record_lignes;


end intermediaire;