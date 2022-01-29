with intermediaire; use intermediaire; --Permet de partager les types définis dans intermediaire.ads
with operateurs; use operateurs;
with ada.Text_IO, ada.integer_Text_IO, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling, ADA.IO_EXCEPTIONS;
--with P_List_Double;
use ada.Text_IO, ada.integer_Text_io, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_IO, Ada.Characters.Handling;

package body operations_liste is


    procedure afficher_liste(f_l : in T_List_Variable) is
    
        l : T_List_Variable;
    
    begin
    
        l := f_l;
        while(l.all.prev /= null) loop
            l := l.all.prev;
        end loop;
        while (l /= null) loop
            put_line(l.all.ptrVar.all.nomVariable);
            put_line(l.all.ptrVar.all.typeVariable);
            if(l.all.ptrVar.all.typeVariable /= "Caractere") then
                put(l.all.ptrVar.all.valeurVariable, 1);
            else
                put(l.all.ptrVar.all.valeurVariable, 1);
                put(':');
                put("'");
                put(Character'Val(l.all.ptrVar.all.valeurVariable));
                put("'");
            end if;
            new_line;
            l := l.all.next;
        end loop;
   
    end afficher_liste;

    procedure afficher_liste(f_l : in T_List_Instruction) is
    
       l : T_List_Instruction;
    
    begin
    
        l := f_l;
        pointer_en_tete_instructions(l);
        while (l /= null) loop
            afficher_ligne_instruction(l.all.ptrIns);
            l := l.all.next;
        end loop;
    
    end afficher_liste;

    procedure afficher_ligne_instruction (ptrInstruction : T_Ptr_Instruction) is

    begin
        
        put("numero de ligne : ");
        put(ptrInstruction.all.numInstruction, 1);
        new_line;
        put("       operation   : ");
        put_line(ptrInstruction.all.operation);

        put("       parametre z :");
        afficher_parametre_ligne_instruction(ptrInstruction.all.operandes.z);

        put("       parametre x :");
        afficher_parametre_ligne_instruction(ptrInstruction.all.operandes.x);

        put("       parametre y :");
        afficher_parametre_ligne_instruction(ptrInstruction.all.operandes.y);

        new_line;

    end afficher_ligne_instruction;

    procedure afficher_parametre_ligne_instruction (ptrVariable : T_Ptr_Variable) is
    
    begin

        if (ptrVariable /= null) then
            new_line;
            put("                type    : ");
            put_line(ptrVariable.all.typeVariable);
            put("                nom     : ");
            put_line(ptrVariable.all.nomVariable);
            put("                valeur  : ");
            put(ptrVariable.all.valeurVariable, 1);
            if (ptrVariable.all.typeVariable = "Caractere") then
                put(" => ");
                put(Character'VAL(ptrVariable.all.valeurVariable));
            end if;
        else
            put(" /");
        end if;
        new_line;

    end afficher_parametre_ligne_instruction;

    function creer_liste_vide return T_List_Variable is
    
        p : T_List_Variable;
    
    begin
    
        p := null;
        return p;
    
    end creer_liste_vide;

    function est_vide(p : in T_List_Variable) return boolean is
    
    begin
    
        return p = null;
    
    end est_vide;

    function creer_liste_vide return T_List_Instruction is
    
        p : T_List_Instruction;
    
    begin
        p := null;
        
        return p;
    
    end creer_liste_vide;

    function est_vide(p : in T_List_Instruction) return boolean is
    
    begin
    
        return p = null;
    
    end est_vide;

    procedure ajouter(f_l : in out T_List_Variable; f_nouveau : in T_Ptr_Variable) is
    
    begin
    
        if (f_l = null) then
            f_l := new T_Cell_Variable'(f_nouveau, null, null);
        else
            while f_l.all.next /= null loop -- Parcours de la liste jusqu'à la queue
                f_l := f_l.all.next;
            end loop;
            f_l.all.next := new T_Cell_Variable'(f_nouveau, null, null);
            f_l.all.next.all.prev := f_l;  
            f_l := f_l.all.next;
        end if;
    
    end ajouter;

    procedure ajouter(f_l : in out T_List_Instruction; f_nouveau : in T_Ptr_Instruction) is
    
    begin
        
        if (f_l = null) then
            f_l := new T_Cell_Instruction'(f_nouveau, null, null);
        else
            while f_l.all.next /= null loop -- Parcours de la liste jusqu'à la queue
                f_l := f_l.all.next;
            end loop;
            f_l.all.next := new T_Cell_Instruction'(f_nouveau, null, null);
            f_l.all.next.all.prev := f_l;  
            f_l := f_l.all.next;
        end if;
    
    end ajouter;

    procedure pointer_en_tete_instructions (ptrInstruction : in out T_List_Instruction) is

    begin

        while(ptrInstruction /= null and then ptrInstruction.all.prev /= null) loop
            ptrInstruction := ptrInstruction.all.prev;
        end loop;

    end pointer_en_tete_instructions;

end operations_liste;