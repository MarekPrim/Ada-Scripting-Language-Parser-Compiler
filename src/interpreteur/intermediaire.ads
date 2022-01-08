generic
    type T is private;


package intermediaire is
    -- Enumerations
    type Reserved_Langage_Word is (Programme,Debut, Fin, est);
    
    SMAX : constant integer;        -- taille d'un string
    TMAX : constant integer;        -- taille du tableau de string
    CMAX : constant integer;        -- taille du tableau de variables

    Aucune_Variable_Definie : Exception; -- Aucune variable n'est definie dans le programme
    Type_Incorrect : Exception; -- Le type de la variable n'est pas correct pour l'opération à effectuer
    Variable_Non_Declaree : Exception; -- La variable à utiliser n'est pas declaree dans le programme
    Variable_Deja_Definie : Exception; -- La variable a déjà été déclarée dans le programme
    Acces_Limite : Exception; -- Le compteur CP est hors limite (Ex : Programme avec un corps de 10 lignes et CP = 11) dans le programme
    Fichier_Non_Lisible : Exception;
    Fichier_Non_Trouve : Exception;
    
    type variable is private;
    type ptrVariable is access variable;

    type ligne is private;
    type ptrLigne is access ligne;

    type type_operandes is array(1..3) of string;

    type ligne is record
        numLigne : integer;
        operandes : type_operandes;
        operation : String;
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
    -- paramètres :
    --      fileName : in String
    -- Préconditions :
    -- Postconditions :
    -- Exceptions : 
    procedure traiterProgramme;

    -- nom : recupererVariables
    -- semantique : récupère les variables d'un programme en langage intermédiaire contenues entre 'Début' (exclu) et 'Programme' (exclue)
    -- paramètres :
    --      fileName : in string        // nom du fichier à interpréter
    -- type-retour : 
    --      ptrVariable                 // pointeur sur un type variable
    -- Préconditions : le programme est correctement formé [Non vérifié dans notre cas]
    -- Postconditions : la liste doublement chainée contient les variables du programme
    -- Exceptions : Aucune_Variable_Definie, Type_Incorrect, Variable_Deja_Definie, Fichier_Non_Trouve, Fichier_Non_Lisible
    function recupererVariables(fileName : in string) return ptrvariable;
    
    -- nom : initialiserInstructions
    -- semantique : récupère les lignes d'un programme en langage intermédiaire contenues entre 'Début' (exclu) et 'Fin' (exclue)
    -- paramètres 
    --      fileName : in string        // nom du fichier à interpréter
    -- type-retour : 
    --      ptrLigne                    // pointeur sur un type ligne
    -- Préconditions : 
    --                  le fichier est fermé
    --                  le contenu entre 'Début' et 'Fin' n'est pas vide
    -- Postconditions : le fichier est fermé
    -- Exceptions : Fichier_Non_Trouve, Fichier_Non_Lisible
    function initialiserInstructions(fileName : in string) return ptrLigne;  

    -- nom : interpreterCommande
    -- semantique : interprete la ligne pointée par ptrLine
    -- parametres :
    --      ptrLine     : in ptrLigne           // pointeur sur les lignes
    --      ptrVariable : in ptrVariable        // pointeur sur les variables
    -- Préconditions    : ptrLigne n'est pas null
    -- Postconditions   : le numéro de la ligne pointée par ptrLine change pendant la procédure
    -- Exceptions       : Acces_Limite
    procedure interpreterCommande (ptrLine : in ptrLigne; ptrVar : in out ptrVariable);

    -- nom : rechercherVariable
    -- semantique : retourne un pointeur sur la variable recherchée
    -- parametres :
    --          nomVariable : in string         // nom de la variable à rechercher
    -- typeRetour : 
    --          ptrVariable                     // pointeur sur la variable recherchée
    -- Préconditions    : 
    -- Postconditions   :  
    -- Exceptions : Variable_Non_Trouvée
    function rechercherVariable (variables : in ptrVariable,nomVariable : in string) return ptrVariable;

    -- nom : pointerEnTeteVariables
    -- semantique : le pointeur pointe en tête de la liste doublement chaînée des variables
    -- parametres :
    --          ptr : in out ptrVariable       // pointeur sur les variables    
    -- Préconditions    : la liste des variables n'est pas vide
    -- Postconditions   : ptr.all.prev = null 
    -- Exceptions :                 
    procedure pointerEnTeteVariables (ptr : in ptrVariable);

    -- nom : pointerEnTeteLignes
    -- semantique : le pointeur pointe en tête de la liste doublement chaînée des lignes
    -- parametres :
    --          ptr : in out ptrVariable       // pointeur sur les lignes    
    -- Préconditions    : la liste des lignes n'est pas vide
    -- Postconditions   : ptr.all.prev = null 
    -- Exceptions :                 
    procedure pointerEnTeteLignes (ptr : in ptrLigne);

end intermediaire;