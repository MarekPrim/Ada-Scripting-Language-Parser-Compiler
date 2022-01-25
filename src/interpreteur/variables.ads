with intermediaire, Ada.Strings.Unbounded; 
use intermediaire, Ada.Strings.Unbounded;


package variables is

    procedure creer_variables_tableau (ligne : in Unbounded_String; i : in out integer; nomVariable : in out Unbounded_String; variables : in T_List_Variable; ptrVariable : out T_Ptr_Variable);

     procedure creerEtAjouterVariable(variables : in out T_List_Variable; typeVariable : in Unbounded_String; nomVariable : in Unbounded_String);

    function creer_variable(variables : in T_List_Variable; nomVariable : in Unbounded_String; isCaractere : in boolean) return T_Ptr_Variable;

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


end variables;