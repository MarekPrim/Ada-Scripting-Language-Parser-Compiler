with ada.text_io, ada.integer_text_io;
use ada.text_io, ada.integer_text_io;

package body P_List_Double is

    function creer_liste_vide return pointeur is
        p : pointeur;
    begin
        p := null;
        return p;
    end creer_liste_vide;

    function est_vide (ptr : in pointeur) return Boolean is
    begin
        return ptr = null;
    end est_vide;

    procedure ajouter (ptr : in out pointeur; rec : in pointeur) is
    begin
        if (est_vide (ptr)) then
            ptr                := rec;
            rec.all.prev := null;
            rec.all.next := null;
        else
            ptr.all.next := rec;
            ptr.all.next.all.prev := ptr;  
            ptr := ptr.all.next;
        end if;
    end ajouter;

end P_List_Double;
