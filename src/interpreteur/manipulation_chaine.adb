with intermediaire; use intermediaire; --Permet de partager les types définis dans intermediaire.ads
with operateurs; use operateurs;
with operations_liste; use operations_liste;
with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, ADA.IO_EXCEPTIONS;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;

package body manipulation_chaine is

    function ligne_commence_par_mot_reserve (ligne : in Unbounded_string; enum : in string) return boolean is
        
        i : integer;
        longueurEnum : integer;
        currentChar : Character;
        
    begin

        i := 1;

        longueurEnum := length(To_Unbounded_String(enum));

        while (i <= length(ligne) and i <= longueurEnum) loop -- On parcourt toute l'énumération et la ligne

            if (i > 1) then -- Les caractères à comparer doivent être une lettre miniscule
                currentChar := To_Lower(enum(i));
            else
                currentChar := enum(i); -- Le premier caractère de l'énumération doit être une lettre majuscule
            end if;

            if (not (element(ligne, i) = currentChar)) then
                return false;
            end if;
            i := i+1;
        end loop;

        return true; -- Si on a parcouru toute l'énumération sans rencontrer de caractère différent, on retourne vrai

    end ligne_commence_par_mot_reserve;

    function renvoyer_ligne_sans_espace (ligne : in Unbounded_string) return Unbounded_string is
        
        j : integer;
        trimLigne : Unbounded_string;
    
    begin

        j := 1;
        for i in 1..length(ligne) loop -- Parcours de la ligne
            if (not (element(ligne, i) = ' ')) then -- Si le caractère n'est pas un espace
                append(trimLigne, element(ligne, i)); -- On ajoute le caractère à la chaîne de caractère temporaire
                j := j+1;
            end if;
        end loop;
    
        return trimLigne;
    
    end renvoyer_ligne_sans_espace;

    function est_ligne_utile (ligne : in Unbounded_String) return boolean is
    
    begin
        -- return => ligne commence par un commentaire
        return not(length(ligne) = 0 or (length(ligne) >= 2 and then slice(ligne, 1, 2) = "--"));

    end est_ligne_utile;

    function is_a_number (nomVariable : in Unbounded_String) return boolean is
        
        j : integer;
    
    begin

        if (length(nomVariable) = 0) then
            return false;
        elsif ((element(nomVariable, 1) /= '-') and not (Character'POS(element(nomVariable,1)) in 48..57)) then
            return false;
        else
            j := 2;
            while(j <= length(nomVariable)) loop
                if (not(Character'POS(element(nomVariable, j)) in 48..57)) then
                    return false;
                end if;
                j := j+1;
            end loop;
        end if;
        return true;

    end is_a_number;


    procedure recuperer_chaine(chaineRetour : out Unbounded_String; chaineDepart : in Unbounded_String; i : in out integer; condition : in integer) is

        conditionVerifiee : boolean;
        iInitial : integer;

    begin

        iInitial := i;

        -- 1 : numerique
        -- 2 : alphebetique
        -- 3 : alphanumerique

        conditionVerifiee := true;
        while (i <= length(chaineDepart) and conditionVerifiee) loop

            if (((condition = 1 or condition = 3) and then (Character'POS(element(chaineDepart, i)) in 48..57 or (iInitial = i and then element(chaineDepart, iInitial) = '-'))) or ((condition = 2 or condition = 3) and then ((Character'POS(element(chaineDepart, i)) in 65..90) or (Character'POS(element(chaineDepart, i)) in 97..122)))) then
                append(chaineRetour, element(chaineDepart, i));
                i := i+1;
            else
                conditionVerifiee := false;
            end if;
        end loop;

    end recuperer_chaine;

     procedure recuperer_chaine(chaineRetour : out Unbounded_String; chaineDepart : in Unbounded_String; i : in out integer; condition : in integer; chainesReservees : in T_Chaines_Reservees) is

        conditionVerifiee : boolean;
        j : integer;
        iInitial : integer;

    begin

        iInitial := i;

        -- 1 : numerique
        -- 2 : alphebetique
        -- 3 : alphanumerique

        conditionVerifiee := true;
        while (i <= length(chaineDepart) and conditionVerifiee) loop
            --if ((((condition = 1 or condition = 3) and then Character'POS(element(ligne, i)) in 48..57) or ((condition = 2 or condition = 3) and then ((Character'POS(element(ligne, i)) in 65..90) or (Character'POS(element(ligne, i)) in 97..122)))) and then not(i <= i+length(chaineReservee)-1 and then slice(ligne, i, i+length(chaineReservee)-1) = chaineReservee)) then
            j := 1;
            while(j <= chainesReservees.nbElements and conditionVerifiee) loop
                if (i+length(chainesReservees.chaines(j))-1 <= length(chaineDepart) and then slice(chaineDepart, i, i+length(chainesReservees.chaines(j))-1) = chainesReservees.chaines(j)) then
                    conditionVerifiee := false;
                end if;
                j := j+1;
            end loop;

            if (not (((condition = 1 or condition = 3) and then (Character'POS(element(chaineDepart, i)) in 48..57 or (iInitial = i and then element(chaineDepart,iInitial) = '-'))) or ((condition = 2 or condition = 3) and then ((Character'POS(element(chaineDepart, i)) in 65..90) or (Character'POS(element(chaineDepart, i)) in 97..122)))) and then conditionVerifiee) then
                conditionVerifiee := false;                
            end if;

            if (conditionVerifiee) then
                append(chaineRetour, element(chaineDepart, i));
                i := i+1;
            end if;
        end loop;

    end recuperer_chaine;

end manipulation_chaine;