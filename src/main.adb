with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure main is

FALSE : Integer := 0;
TRUE : Integer := 1;
F         : File_Type;
   File_Name : constant String := "facto.med";
begin
   Open (F, In_File, File_Name);
   while not End_Of_File (F) loop
      Put_Line (Get_Line (F));
   end loop;
   Close (F);
end main;