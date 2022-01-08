with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package intermediaire is
    -- Enumerations
    type Reserved_Langage_Word is (Programme,Debut, Fin);
    
    Aucune_Variable_Definie : Exception; -- Aucune variable n'est definie dans le programme
    Type_Incorrect : Exception; -- Le type de la variable n'est pas correct pour l'opération à effectuer
    Variable_Non_Declaree : Exception; -- La variable à utiliser n'est pas declaree dans le programme
    Variable_Deja_Definie : Exception; -- La variable a déjà été déclarée dans le programme
    Acces_Limite : Exception; -- Le compteur CP est hors limite (Ex : Programme avec un corps de 10 lignes et CP = 11) dans le programme
    Fichier_Non_Lisible : Exception;
    Fichier_Non_Trouve : Exception;

    type T_Cell_Variable;
    type T_Cell_Instruction;
    type T_Variable;
    type T_Instruction;

    type T_List_Variable is access T_Cell_Variable;
    type T_List_Instruction is access T_Cell_Instruction;

    type T_Ptr_Variable is access T_Variable;
    type T_Ptr_Instruction is access T_Instruction;

    type Chaine is record
        str : String(1..100);
        nbCharsEffectif : Integer;
    end record;

    type T_Operandes is array(1..3) of T_Ptr_Variable;

    type T_Variable is record
        valeurVariable : Integer;
        typeVariable : Chaine;
        nomVariable : Chaine;
        isConstant : Boolean;
    end record;

    type T_Instruction is record
        numInstruction : Integer;
        operandes : T_Operandes;
        operation : Chaine;
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
    --  fileName : le nom du fichier à lire
    --  listeInstructions : la liste des instructions
    --  listeVariables : la liste des variables
    -- Préconditions
    procedure parseFile (fileName : in string; variables : in out T_List_Variable; instructions : in out T_List_Instruction);

    function ligneCommenceParMotReserve (ligne : in Unbounded_string; enum : in string) return boolean;

    function renvoyerLigneSansEspace (ligne : in Unbounded_string) return Unbounded_string;

    procedure traiterProgramme(fileName : in string);

    -- nom : recupererVariables
    -- semantique : récupère les variables d'un programme en langage intermédiaire contenues entre 'Début' (exclu) et 'Programme' (exclue)
    -- paramètres :
    --      fileName : in string        // nom du fichier à interpréter
    -- type-retour : 
    --      ptrVariable                 // pointeur sur un type variable
    -- Préconditions : le programme est correctement formé [Non vérifié dans notre cas]
    -- Postconditions : la liste doublement chainée contient les variables du programme
    -- Exceptions : Aucune_Variable_Definie, Type_Incorrect, Variable_Deja_Definie
     procedure recupererVariables(variables : in out T_List_Variable; ligne : in Unbounded_string);
    
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
    -- function initialiserInstructions(fileName : in string) return ptrLigne;  

    -- nom : interpreterCommande
    -- semantique : interprete la ligne pointée par ptrLine
    -- parametres :
    --      ptrLine     : in ptrLigne           // pointeur sur les lignes
    --      ptrVariable : in ptrVariable        // pointeur sur les variables
    -- Préconditions    : ptrLigne n'est pas null
    -- Postconditions   : le numéro de la ligne pointée par ptrLine change pendant la procédure
    -- Exceptions       : Acces_Limite
    -- procedure interpreterCommande (ptrLine : in ptrLigne; ptrVar : in out ptrVariable);

    -- nom : rechercherVariable
    -- semantique : retourne un pointeur sur la variable recherchée
    -- parametres :
    --          nomVariable : in string         // nom de la variable à rechercher
    -- typeRetour : 
    --          ptrVariable                     // pointeur sur la variable recherchée
    -- Préconditions    : 
    -- Postconditions   :  
    -- Exceptions : Variable_Non_Trouvée
    -- function rechercherVariable (variables : in ptrVariable,nomVariable : in string) return ptrVariable;

    -- nom : pointerEnTeteVariables
    -- semantique : le pointeur pointe en tête de la liste doublement chaînée des variables
    -- parametres :
    --          ptr : in out ptrVariable       // pointeur sur les variables    
    -- Préconditions    : la liste des variables n'est pas vide
    -- Postconditions   : ptr.all.prev = null 
    -- Exceptions :                 
    -- procedure pointerEnTeteVariables (ptr : in ptrVariable);

    -- nom : pointerEnTeteLignes
    -- semantique : le pointeur pointe en tête de la liste doublement chaînée des lignes
    -- parametres :
    --          ptr : in out ptrVariable       // pointeur sur les lignes    
    -- Préconditions    : la liste des lignes n'est pas vide
    -- Postconditions   : ptr.all.prev = null 
    -- Exceptions :                 
    -- procedure pointerEnTeteLignes (ptr : in ptrLigne);

    -- nom : creer_liste_vide
    -- semantique : creer une liste vide
    -- parametres : /
    -- type retour : T_List_Integer
    -- pre-condition : /
    -- post-condition : est_vide (l) est vide
    -- exception : /
    --function creer_liste_vide return T_List_Variable
    --with 
    --    post => est_vide(creer_liste_vide'result) = true;

    -- nom : est_vide
    -- semantique : teste si une liste f_l est vide
    -- parametres : l : in T_List_Integer
    -- type retour : boolean
    -- pre-condiition : /
    -- post-condition : /
    -- exception : /
    --function est_vide(p : in T_List_Variable) return boolean;


    --procedure ajouter(f_l : in out T_List_Variable; f_nouveau : in T_Ptr_Variable);

    procedure afficher_liste(f_l : in T_List_Variable);

end intermediaire;