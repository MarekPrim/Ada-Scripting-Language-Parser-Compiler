
package intermediaire is

    SMAX : constant integer;        -- taille d'un string
    TMAX : constant integer;        -- taille du tableau de string
    CMAX : constant integer;        -- taille du tableau de variables

    TYPE lignes is array(1.. TMAX) of String(1..SMAX);
    type  variable is record
        valeur : T; {T : Integer || Caracter || [Integer] || [Boolean] || String[Capacite] || String}
        type : String;
        identificateur : String;
    end record;

    type variables is array(1..CMAX) of variable;

    

    -- nom : recuperationVariables
    -- semantique : Récupérer les variables d'un programme en langage intermédiaire
    -- paramètres :
    --    lines -> in lignes // Contient le programme en langage intermédiaire
    --    vars -> in variables // Contient les variables du programme
    -- et les stocker dans un tableau de variables en mémoire
    -- Préconditions : le programme est correctement formé [Non vérifié dans notre cas]
    -- Postconditions : variables.length > 0 && variables contient les variables du programme
    -- Exceptions : Aucune_Variable_Definie, Type_Incorrect, Variable_Deja_Definie
    procedure recuperationVariables(lines : in lignes; vars : out variable[]);

    -- nom : interpreterCommande
    -- semantique : interprete la ligne ou se trouve cp
    -- parametres :
    --          lines -> in lignes // Contient le programme en langage intermédiaire
    --          vars -> in out variables // Contient les variables du programme
    --          cp -> in out int // Contient la position du curseur (ligne interpretee) dans le programme
    -- Préconditions :
    -- Postconditions :  
    procedure interpreterCommande (lines : in lignes; vars : in out variable[]; cp : in out integer);

    -- nom : initialiserInstructions
    -- semantique : parcoure les lignes du fichier et stocke ces lignes dans le tableau instructions
    -- parametres : /
    -- Préconditions : le fichier est fermé
    -- Postconditions : le fichier est fermé
    function initialiserInstructions return lignes;

end intermediaire;