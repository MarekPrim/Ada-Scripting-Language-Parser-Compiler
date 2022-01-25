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

    procedure recupererChaine(nomVariable : out Unbounded_String; ligne : in Unbounded_String; i : in out integer; condition : in integer);

    procedure recupererChaine(nomVariable : out Unbounded_String; ligne : in Unbounded_String; i : in out integer; condition : in integer; chainesReservees : in T_Chaines_Reservees);

end manipulation_chaine;