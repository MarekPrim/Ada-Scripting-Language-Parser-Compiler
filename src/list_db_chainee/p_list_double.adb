with ada.text_io, ada.integer_text_io;
use ada.text_io, ada.integer_text_io;

package body P_List_Double is

    function creer_liste_vide return pointeur is
        p : pointeur;
    begin
        p := null;
        return p;
    end creer_liste_vide;

    function est_vide (p : in pointeur) return Boolean is
    begin
        return p = null;
    end est_vide;

    procedure ajouter (p : in out pointeur; f_nouveau : in pointeur_record) is
    begin
        if (est_vide (p)) then
            p                  := f_nouveau;
            f_nouveau.all.prev := null;
            f_nouveau.all.next := null;
        else
            while (p.all.next /= null) loop
                p := p.all.next;
            end loop;

            p.all.next          := f_nouveau;
            p.all.next.all.prev := p;
        end if;
    end ajouter;

end P_List_Double;
