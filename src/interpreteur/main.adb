with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure main is
   file_name : constant string := "facto.med";
   F : File_Type;

    str : String(1..4);

begin
    
     Open (F, In_File, file_name);

    while (not End_Of_File (F)) loop
        str(1..4) := Get_Line(F)(1..4);
        put_line(str);
    end loop;

    Close(F);

end main;