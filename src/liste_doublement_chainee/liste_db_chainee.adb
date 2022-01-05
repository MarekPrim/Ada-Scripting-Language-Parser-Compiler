with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
--with Ada.Float_Text_IO; use Ada.Float_Text_IO;

package body liste_db_chainee is

    --Créer une liste vide
    function createEmptyList return liste is
        lste : liste := new cellule;
    begin
        lste := null;
        return lste;
    end createEmptyList;
    
    --Trouver dans la liste
    procedure rechercher(e:in Integer; lste:in out liste) is
        courant : liste := lste;
    begin
        if(lste = null)then
            raise Liste_vide;
        end if;
        courant:=lste;

        if (e>lste.all.element) then
            while(lste/=null and then e/=lste.all.element)loop
                lste:=lste.all.next;
            end loop;
        elsif (e<lste.all.element)then
            while(lste/=null and then e/=lste.all.element)loop
                lste:=lste.all.prev;
            end loop;
        end if;
        if(lste/=null and then lste.all.element/=e)then
            lste:=courant;
        end if;
    end rechercher;

    --Insérer en tête de liste
    procedure ajouter(e : in Integer; lste : in out liste) is
        new_element : liste;
        tmp : liste := lste;
    begin

        if(lste/=null)then
            --exception duplicate data
            rechercher(e,tmp);
            if(tmp/=null and then tmp.all.element=e)then
                raise Donnee_deja_presente;
            end if;

            --ajout d'un élément
            if(e>lste.all.element)then
                if(lste.all.next = null)then --cas next vide,insérer elem
                    lste.all.next:=new cellule;
                    lste.all.next.all.element:=e;
                    lste.all.next.all.next:=null;
                    lste.all.next.all.prev:=lste;
                    lste:=lste.all.next;
                else
                    if(e>lste.all.next.all.element)then
                        lste:=lste.all.next;
                        ajouter(e,lste);
                    else
                        new_element:= new cellule;
                        new_element.all.element:=e;
                        new_element.all.prev:=lste;
                        new_element.all.next:=lste.all.next;
                        lste.all.next.all.prev:=new_element;
                        lste.all.next:=new_element;
                        lste:=new_element;
                    end if;
                end if;
            else
                if(lste.all.prev = null)then
                    lste.all.prev:=new cellule;
                    lste.all.prev.all.element:=e;
                    lste.all.prev.all.next:=lste;
                    lste.all.prev.all.prev:=null;
                    lste:=lste.all.prev;
                else
                    if(e<lste.all.prev.all.element)then
                        lste:=lste.all.prev;
                        ajouter(e,lste);
                    else
                        new_element:= new cellule;
                        new_element.all.element:=e;
                        new_element.all.prev:=lste.all.prev.all.prev;
                        new_element.all.next:=lste;
                        lste.all.prev:=new_element;
                        lste.all.prev.all.next:=new_element;
                        lste:=new_element;
                    end if;
                end if;
            end if;
        else--Cas liste vide
            lste:=new cellule;
            lste.all.element:=e;
            lste.all.next:=null;
            lste.all.prev:=null;
        end if;

    end ajouter;

    --Afficher la liste
    procedure afficher(lste : in liste) is
        courant : liste;
    begin
        courant := lste;
        if(courant/=null)then
            --go to head of list
            while(courant.all.prev/=null)loop
                courant:=courant.all.prev;
            end loop;
            
            --print all the list
            while(courant/=null)loop
                Put(courant.all.element,0);
                Put(" : ");
                courant:=courant.all.next;
            end loop;
            New_line;
        else
            Put_line("Empty list !");
        end if;
    end afficher;

    procedure afficherCourant(lste : in liste)is

    begin
        Put("Actual is : ");
        Put(lste.all.element,0);
        New_line;
    end afficherCourant;

    --enlever de la liste
    procedure enlever(e : in Integer; lste: in out liste) is
        courant : liste;
    begin
        rechercher(e,lste);
        if(e/=lste.all.element)then
            raise Donnee_absente;
        else
            if(lste.all.prev /= null)then
                lste.all.prev.all.next:=lste.all.next;
                if(lste.all.next/= null) then
                    lste.all.next.all.prev:=lste.all.prev;
                end if;
                lste:=lste.all.prev;
            elsif (lste.all.next /= null)then
                lste.all.next.all.prev:=null;-Content 1
+Content 2
                lste:=lste.all.next;
            else
                lste:=null;
            end if;
        end if;
    end enlever;

end liste_db_chainee;