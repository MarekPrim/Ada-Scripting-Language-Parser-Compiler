with Ada.Text_IO, Ada.Integer_Text_IO, intermediaire;
use Ada.Text_IO, Ada.Integer_Text_IO, intermediaire;

procedure main is

   fileName : constant string := "./interpreteur/character.med";
   choice : Integer;

begin

   loop
      Put_Line("Mode normal : 0");
      Put_Line("Debug : 1");
      new_line;
      Get(choice);
   exit when (choice = 0 or choice = 1);
   end loop;

   skip_line;

   traiterProgramme(fileName, choice);

end main;