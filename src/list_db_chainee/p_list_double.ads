generic

    type pointeur is private;
    type type_record is private;

package P_List_Double is

    -- nom : creer_liste_vide
    -- semantique : creer une liste vide
    -- parametres : /
    -- type retour : T_List_Integer
    -- pre-condition : /
    -- post-condition : est_vide (l) est vide
    -- exception : /
    function creer_liste_vide return pointeur
    with 
        post => est_vide(creer_liste_vide'result) = true;

    -- nom : est_vide
    -- semantique : teste si une liste f_l est vide
    -- parametres : l : in T_List_Integer
    -- type retour : boolean
    -- pre-condiition : /
    -- post-condition : /
    -- exception : /
    function est_vide(ptr : in pointeur) return boolean;

    -- nom : ajouter
    -- semantique : ajouter l'element f_nouveau, le noeud courant sera le noeud insere
    -- parametres :
    --          f_l : in out T_List_Integer
    --          f_nouveau : in My_Type
    -- pre-condiition : /
    -- post-condition : f_nouveau appartient a la liste
    -- exception : /
    procedure ajouter(ptr : in out pointeur; rec : in type_record); 

end P_List_Double;