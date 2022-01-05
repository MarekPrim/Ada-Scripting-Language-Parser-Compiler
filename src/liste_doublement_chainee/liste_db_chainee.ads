package liste_db_chainee is

    Type cellule;
    Type liste is access cellule;
    Type cellule is record
        element : Integer; --Possibilité de rendre le type de lste'élément générique
        next : liste;
        prev : liste;
    end record;

    --exceptions

    Liste_vide : exception;
    Donnee_deja_presente : exception;
    Donnee_absente : exception;

    --Créer une liste vide
    --Préconditions : Rien
    --Postconditions: Liste créée vide
    --Exception : Rien
    function createEmptyList return liste;
    
    --Place lste'élément courant à lste'adresse du noeud contenant la valeur recherchée
    --Préconditions : Rien
    --Postconditions: Rien
    --Exception : Rien
    procedure rechercher(e:in Integer; lste:in out liste);

    --Insérer dans la liste
    --Préconditions : Element non présent
    --Postconditions: Element ajouté présent dans la liste
    --Exception : Donnée_deja_presente
    procedure ajouter(e : in Integer; lste : in out liste);

    --Afficher la liste
    --Préconditions : Rien
    --Postconditions: Rien
    --Exception : Rien
    procedure afficher(lste : in liste);

    --Affichage de lste'élément courant pour debug
    procedure afficherCourant(lste : in liste);

    --Suppression d'un élément de la liste    
    --Préconditions : Element présent
    --Postconditions: Element non présent
    --Exception : Donnee_absente
    procedure enlever(e : in Integer; lste: in out liste);

end liste_db_chainee;