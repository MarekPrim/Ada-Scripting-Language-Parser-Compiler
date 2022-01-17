with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

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
    -- Préconditions
    procedure parseFile (fileName : in string; variables : in out T_List_Variable; instructions : in out T_List_Instruction);

    -- Indique si la chaine de caractère est un mot réservé
    -- Paramètres :
    --  ligne in Unbounded_String : la chaine à tester
    --  enum in String : le mot réservé à chercher
    -- Préconditions
    --  ligne ne doit pas être vide
    -- Postconditions
    --  renvoie true si la chaine est un mot réservé, false sinon
    -- Exception
    --  Aucune
    function ligneCommenceParMotReserve (ligne : in Unbounded_string; enum : in string) return boolean;

    -- Renvoie une chaine de caracteres sans espace (trim)
    -- Paramètres :
    --  chaine in Unbounded_String : la chaine à traiter
    -- Préconditions
    --  Aucune
    -- Postconditions
    --  renvoie une chaine de caracteres sans espace
    -- Exception
    --  Aucune
    function renvoyerLigneSansEspace (ligne : in Unbounded_string) return Unbounded_string;

    -- Wrapper pour le traitement du programme
    -- Paramètres :
    --  fileName in string : le nom du fichier à lire
    -- Préconditions
    --  Aucune
    -- Postconditions
    --  Aucune
    -- Exception
    --  Aucune
    procedure traiterProgramme(fileName : in string);

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
    procedure interpreterCommande (ptrInstruction : in out T_List_Instruction);

    -- nom : rechercherVariable
    -- semantique : retourne un pointeur sur la variable recherchée
    -- parametres :
    --          nomVariable : in string         // nom de la variable à rechercher
    --          ptrVar : in T_List_Variable    // liste des variables
    -- typeRetour : 
    --          ptrVariable T_List_Variable    // pointeur sur la variable recherchée
    -- Préconditions    : 
    -- Postconditions   :  
    -- Exceptions : Variable_Non_Trouvee
    function rechercherVariable (variables : in T_List_Variable; nomVariable : in Unbounded_String) return T_List_Variable;

    -- nom : pointerEnTeteVariables
    -- semantique : le pointeur pointe en tête de la liste doublement chaînée des variables
    -- parametres :
    --          ptr : in out ptrVariable       // pointeur sur les variables    
    -- Préconditions    : la liste des variables n'est pas vide
    -- Postconditions   : ptr.all.prev = null 
    -- Exceptions :                 
    -- procedure pointerEnTeteVariables (ptr : in T_List_Variable);

    -- nom : pointerEnTeteLignes
    -- semantique : le pointeur pointe en tête de la liste doublement chaînée des lignes
    -- parametres :
    --          ptr : in out ptrVariable       // pointeur sur les lignes    
    -- Préconditions    : la liste des lignes n'est pas vide
    -- Postconditions   : ptr.all.prev = null 
    -- Exceptions :                 
    procedure pointerEnTeteInstructions (ptrInstruction : in out T_List_Instruction);

    -- nom : creer_liste_vide
    -- semantique : creer une liste vide
    -- parametres : /
    -- type retour : T_List_Integer
    -- pre-condition : /
    -- post-condition : est_vide (l) est vide
    -- exception : /
    function creer_liste_vide return T_List_Variable
    with 
       post => est_vide(creer_liste_vide'result) = true;

    -- nom : creer_liste_vide
    -- semantique : creer une liste vide
    -- parametres : /
    -- type retour : T_List_Integer
    -- pre-condition : /
    -- post-condition : est_vide (l) est vide
    -- exception : /
    function creer_liste_vide return T_List_Instruction
    with 
       post => est_vide(creer_liste_vide'result) = true;

    -- nom : est_vide
    -- semantique : teste si une liste f_l est vide
    -- parametres : l : in T_List_Integer
    -- type retour : boolean
    -- pre-condiition : /
    -- post-condition : /
    -- exception : /
    function est_vide(p : in T_List_Variable) return boolean;

    -- nom : est_vide
    -- semantique : teste si une liste f_l est vide
    -- parametres : l : in T_List_Integer
    -- type retour : boolean
    -- pre-condiition : /
    -- post-condition : /
    -- exception : /
    function est_vide(p : in T_List_Instruction) return boolean;


    -- nom : ajouter
    -- semantique : ajoute un élément en queue de liste
    -- parametres :
    --          f_l : in out T_List_Variable    // liste
    --          f_nouveau : in T_Ptr_Variable   // élément à ajouter
    -- préconditions
    --          Aucune
    -- post-conditions
    --          f_l.all.ptrVar = f_nouveau
    --          f_nouveau.all.prev = f_l
    -- exception : /
    procedure ajouter(f_l : in out T_List_Variable; f_nouveau : in T_Ptr_Variable);

    -- nom : ajouter
    -- semantique : ajoute un élément en queue de liste
    -- parametres :
    --          f_l : in out T_List_Instruction    // liste
    --          f_nouveau : in T_Ptr_Instruction   // élément à ajouter
    -- préconditions
    --          Aucune
    -- post-conditions
    --          f_l.all.ptrVar = f_nouveau
    --          f_nouveau.all.prev = f_l
    -- exception : /
    procedure ajouter(f_l : in out T_List_Instruction; f_nouveau : in T_Ptr_Instruction);

       -- nom : afficher_liste
    -- semantique : affiche une liste
    -- parametres :
    --          f_l : in T_List_Variable    // liste
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    procedure afficher_liste(f_l : in T_List_Variable);

    -- nom : afficher_liste
    -- semantique : affiche une liste
    -- parametres :
    --          f_l : in T_List_Instruction    // liste
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    procedure afficher_liste(f_l : in T_List_Instruction);

    -- nom : afficherLigneInstruction
    -- semantique : affiche une ligne d'instruction
    -- parametres :
    --          ptrInstruction : T_Ptr_Instruction
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    procedure afficherLigneInstruction (ptrInstruction : T_Ptr_Instruction);

    -- nom : afficherParametreLigneInstruction
    -- semantique : affiche les paramètres d'une ligne d'instruction
    -- parametres :
    --          ptrVariable : T_Ptr_Variable
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    procedure afficherParametreLigneInstruction (ptrVariable : T_Ptr_Variable);

    -- nom : changerInstructionParNumero
    -- semantique : change l'instruction à executer par une autre ligne d'instruction (EX : GOTO)
    -- parametres :
    --          ptrInstruction : T_List_Instruction
    --          numeroInstruction : in integer
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    procedure changerInstructionParNumero(ptrInstruction : in out T_List_Instruction; numInstruction : in integer);

    -- nom : creer_variable_tmp
    -- semantique : crée une variable temporaire
    -- parametres :
    --          nomVariable : in chaine
    -- type retour : T_Ptr_Variable
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    function creer_variable_tmp (nomVariable : in Unbounded_String) return T_Ptr_Variable;

    -- nom : estLigneUtile
    -- semantique : teste si une ligne d'instruction est utile
    -- parametres :
    --          ligne : Unbounded_String
    -- type retour : boolean
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    function estLigneUtile (ligne : in Unbounded_String) return boolean;

    -- nom : isANumber
    -- semantique : teste si une chaine est un nombre
    -- parametres :
    --          chaine : in chaine
    -- type retour : boolean
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    function isANumber (nomVariable : in Unbounded_String) return boolean;

    --private
        
        

end intermediaire;