with intermediaire, Ada.Strings.Unbounded; 
use intermediaire, Ada.Strings.Unbounded;

package operations_liste is

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
    --          f_l : in out T_List_Instruction    // liste
    --          f_nouveau : in T_Ptr_Instruction   // élément à ajouter
    -- préconditions
    --          Aucune
    -- post-conditions
    --          f_l.all.ptrVar = f_nouveau
    --          f_nouveau.all.prev = f_l
    -- exception : /
    procedure ajouter(f_l : in out T_List_Instruction; f_nouveau : in T_Ptr_Instruction);

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
    procedure pointer_en_tete_instructions (ptrInstruction : in out T_List_Instruction);



    private

     -- nom : afficher_ligne_instruction
    -- semantique : affiche une ligne d'instruction
    -- parametres :
    --          ptrInstruction : T_Ptr_Instruction
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
   procedure afficher_ligne_instruction (ptrInstruction : T_Ptr_Instruction);


   -- nom : afficher_parametre_ligne_instruction
    -- semantique : affiche les paramètres d'une ligne d'instruction
    -- parametres :
    --          ptrVariable : T_Ptr_Variable
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    procedure afficher_parametre_ligne_instruction (ptrVariable : T_Ptr_Variable);

    


end operations_liste;