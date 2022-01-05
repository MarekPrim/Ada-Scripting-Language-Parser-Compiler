
package intermediaire is
-- Enumerations
 type Reserved_Langage_Word is (Programme,Début, Fin, est);
    SMAX : constant integer;        -- taille d'un string
    TMAX : constant integer;        -- taille du tableau de string
    CMAX : constant integer;        -- taille du tableau de variables

    Aucune_Variable_Definie : Exception; -- Aucune variable n'est definie dans le programme
    Type_Incorrect : Exception; -- Le type de la variable n'est pas correct pour l'opération à effectuer
    Variable_Non_Declaree : Exception; -- La variable à utiliser n'est pas declaree dans le programme
    Variable_Deja_Definie : Exception -- La variable a déjà été déclarée dans le programme
    Acces_Limite : Exception; -- Le compteur CP est hors limite (Ex : Programme avec un corps de 10 lignes et CP = 11) dans le programme
    
    
    type variable is private;
    type ptrVariable is access variable;

    type ligne is private;
    type ptrLigne is access ligne;

    type ligne is record
        text : String;
        prev : ptrLigne;
        next : ptrLigne;
    end record;

    type variable is record
        valeur : T; --{T : Integer || Character || [Integer] || [Boolean] || String[Capacite] || String}
        type : String;
        identificateur : String;
        constant : Boolean;
        next : ptrVariable;
        prev : ptrVariable;
    end record;

    --procedure traiterProgramme(); //appelera le parser, partie visible par l'utilisateur
    procedure traiterProgramme;
    
    -- nom : initialiserInstructions
    -- semantique : parcoure les lignes du fichier et stocke ces lignes dans le tableau instructions
    -- parametres : fileName : in string        nom du fichier à interpréter
    -- Préconditions : le fichier est fermé
    -- Postconditions : le fichier est fermé
    function initialiserInstructions(fileName : in string) return lignes;


    -- nom : recuperationVariables
    -- semantique : Récupérer les variables d'un programme en langage intermédiaire
    -- paramètres :
    --    lines -> in lignes // Contient le programme en langage intermédiaire
    --    vars -> in variables // Contient les variables du programme
    -- et les stocker dans un tableau de variables en mémoire
    -- Préconditions : le programme est correctement formé [Non vérifié dans notre cas]
    -- Postconditions : variables.length > 0 && variables contient les variables du programme
    -- Exceptions : Aucune_Variable_Definie, Type_Incorrect, Variable_Deja_Definie
    function recuperationVariables(lines : in lignes) return variables;

    -- nom : interpreterCommande
    -- semantique : interprete la ligne ou se trouve cp
    -- parametres :
    --          lines -> in lignes // Contient le programme en langage intermédiaire
    --          vars -> in out variables // Contient les variables du programme
    --          cp -> in out int // Contient la position du curseur (ligne interpretee) dans le programme
    -- Préconditions :
    -- Postconditions :  
    -- Exceptions : Acces_Limite
    procedure interpreterCommande (lines : in lignes; vars : in out variables; cp : in out integer);


    -- nom : rechercherVariable
    -- semantique : retourne un pointeur sur la variable recherchée
    -- parametres :
    --          nomVariable : in string             nom de la variable à rechercher
    -- typeRetour : 
    --          ptrVariable                         pointeur sur la variable recherchée
    -- Préconditions :
    -- Postconditions :  
    -- Exceptions : Variable_Non_Trouvée
    function rechercherVariable (nomVariable : in string) return ptrVariable;


end intermediaire;