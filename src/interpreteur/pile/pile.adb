with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;  -- for Integer_Text_IO      

package body Pile is

function creerPile return T_Pile is
begin
    return (null);
end creerPile;

function isEmpty(pile : in T_Pile) return Boolean is
begin
    return (pile = null);
end isEmpty;

procedure empiler(pile : in out T_Pile; val : in T) is
begin
    pile := new C_Pile'(val, pile);
end empiler;

procedure depiler(pile : in out T_Pile) is
begin
    if isEmpty(pile) then
        raise Pile_Vide;
    else
        pile := pile.all.next;
    end if;
end depiler;

function sommet(pile : in T_Pile) return T is
begin
    if isEmpty(pile) then
        raise Pile_Vide;
    else
        return (pile.all.val);
    end if;
end sommet;

function taille(pile : in T_Pile) return Integer is
copy : T_Pile;
temp : Integer;
begin
    temp := 0;
    if isEmpty(pile) then
        null;
    else
        temp := 1;
        copy := pile;
        while copy.all.next /= null loop
            copy := copy.all.next;
            temp := temp + 1;
        end loop;
        
    end if;
    return temp;
end taille;

procedure afficher(pile : in T_Pile) is
copy : T_Pile;
begin
    if isEmpty(pile) then
        Put_Line("La pile est vide");
    else
        copy := pile;
        New_Line(1);
        Put_Line("La pile contient : ");
        while copy /= null loop
            Put("|");
            Put(Image(copy.all.val));
            Put("|");
            New_Line(1);
            copy := copy.all.next;
        end loop;
    end if;
end afficher;

end Pile;



