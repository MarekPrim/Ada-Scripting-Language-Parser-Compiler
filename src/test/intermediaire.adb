with ada.Text_IO, Ada.Streams.Stream_IO;
use ada.text_io, Ada.Streams.Stream_IO;

package body intermediaire is

    function recupererInstructions(fileName : in String) return record_lignes is
        F : File_Type;
        S : stream_access;
        lines : record_lignes;
        str : string(1..SMAX);
        i : integer;
    begin
        Open (F, In_File, fileName);
        lines.nb_lignes := 0;
        i := 1;
        S := stream(F);
        while not End_Of_File (F) loop
            str := String'Input(S);
            if (str(1..2) /= "--") then
                lines.tab_lignes(i) := str;
                lines.nb_lignes := lines.nb_lignes + 1;
                i := i+1;
            end if;
        end loop;
        Close (F);
        return lines;
    end recupererInstructions;

    procedure traiterProgramme (fileName : in string) is
        lines : record_lignes;
    begin
        lines := recupererInstructions(fileName);
    end traiterProgramme;

end intermediaire;
