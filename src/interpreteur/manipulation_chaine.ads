with intermediaire, Ada.Strings.Unbounded; 
use intermediaire, Ada.Strings.Unbounded;

package manipulation_chaine is


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
    function ligne_commence_par_mot_reserve (ligne : in Unbounded_string; enum : in string) return boolean;

    -- Renvoie une chaine de caracteres sans espace (trim)
    -- Paramètres :
    --  chaine in Unbounded_String : la chaine à traiter
    -- Préconditions
    --  Aucune
    -- Postconditions
    --  renvoie une chaine de caracteres sans espace
    -- Exception
    --  Aucune
    function renvoyer_ligne_sans_espace (ligne : in Unbounded_string) return Unbounded_string;


     -- nom : est_ligne_utile
    -- semantique : teste si une ligne d'instruction est utile
    -- parametres :
    --          ligne : Unbounded_String
    -- type retour : boolean
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    function est_ligne_utile (ligne : in Unbounded_String) return boolean;

    -- nom : is_a_number
    -- semantique : teste si une chaine est un nombre
    -- parametres :
    --          chaine : in chaine
    -- type retour : boolean
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    function is_a_number (nomVariable : in Unbounded_String) return boolean;

    --private

    -- nom : recuperer_chaine
    -- semantique : recupere la chaine d'une ligne basique
    -- parametres :
    --          chaineRetour : Unbounded_String
    --          chaineDepart : Unbounded_String
    --          i : in out integer
    --          condition : in boolean
    -- type retour : Unbounded_String
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    procedure recuperer_chaine(chaineRetour : out Unbounded_String; chaineDepart : in Unbounded_String; i : in out integer; condition : in integer);

    -- nom : recuperer_chaine
    -- semantique : recupere la chaine d'une ligne jusqu'à un mot réservé
    -- parametres :
    --          chaineRetour : Unbounded_String
    --          chaineDepart : Unbounded_String
    --          i : in out integer
    --          condition : in boolean
    --          chaineReserve : in T_Chaines_Reservees
    -- type retour : Unbounded_String
    -- préconditions
    --          Aucune
    -- post-conditions
    --          Aucune
    -- exception : /
    procedure recuperer_chaine(chaineRetour : out Unbounded_String; chaineDepart : in Unbounded_String; i : in out integer; condition : in integer; chainesReservees : in T_Chaines_Reservees);

end manipulation_chaine;