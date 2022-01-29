with intermediaire, Ada.Strings.Unbounded; 
use intermediaire, Ada.Strings.Unbounded;


package variables is

    -- nom : recuperer_variables
    -- semantique : récupère les variables d'un programme en langage intermédiaire contenues entre 'Début' (exclu) et 'Programme' (exclue)
    -- paramètres :
    --  variables : in out T_List_Variable : la liste des variables
    -- ligne : in Unbounded_string : la ligne à analyser
    -- Préconditions : le programme est correctement formé [Non vérifié dans notre cas]
    -- Postconditions : la liste doublement chainée contient les variables du programme
    -- Exceptions : Aucune_Variable_Definie, Variable_Deja_Definie
    procedure recuperer_variables(variables : in out T_List_Variable; ligne : in Unbounded_string);

    -- nom : creer_variables_tableau
    -- sémantique : Déplie un tableau de taille fixe en créant les variables correspondantes à chaque index
    -- paramètres :
    --     ligne : in Unbounded_String
    --     i : in out Integer
    --     nomVariable : in out Unbounded_String
    --     variables : in out T_List_Variable
    --     ptrVariable : out Ptr_Variable
    -- pré-conditions : /
    -- post-conditions : /
    -- exception : /
    procedure creer_variable_tableau (ligne : in Unbounded_String; i : in out integer; nomTableau : in out Unbounded_String; variables : in T_List_Variable; ptrVariable : out T_Ptr_Variable);

    function is_array (nomVariable : in Unbounded_String) return boolean;

    function recuperer_element_tableau(nomVariableTableau : in Unbounded_String; variables : in T_List_Variable) return T_Ptr_Variable;

    -- nom : creer_et_ajouter_variable
    -- sémantique : Créee et ajoute une variable dans la liste des variables
    -- paramètres :
    --     type : in Unbounded_String
    --     nomVariable : in out Unbounded_String
    --     variables : in out T_List_Variable
    -- pré-conditions : /
    -- post-conditions : /
    -- exception : /
    procedure creer_et_ajouter_variable(variables : in out T_List_Variable; typeVariable : in Unbounded_String; nomVariable : in Unbounded_String);


    -- nom : creer_variable
    -- sémantique : Crée une variable
    -- paramètres :
    --     isCaractere : in Boolean
    --     variables : in T_List_Variable
    --     nomVariable : out Unbounded_String
    function creer_variable(variables : in T_List_Variable; nomVariable : in Unbounded_String; isCaractere : in boolean) return T_Ptr_Variable;

    -- nom : rechercher_variable
    -- semantique : retourne un pointeur sur la variable recherchée
    -- parametres :
    --          nomVariable : in string         // nom de la variable à rechercher
    --          ptrVar : in T_List_Variable    // liste des variables
    -- typeRetour : 
    --          ptrVariable T_List_Variable    // pointeur sur la variable recherchée
    -- Préconditions    : 
    -- Postconditions   :  
    -- Exceptions : Variable_Non_Trouvee
    function rechercher_variable (variables : in T_List_Variable; nomVariable : in Unbounded_String) return T_List_Variable;

 private
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
    function creer_variable_tmp (nomVariable : in Unbounded_String; isCaractere : in boolean) return T_Ptr_Variable;
end variables;