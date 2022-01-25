with intermediaire, Ada.Strings.Unbounded; 
use intermediaire, Ada.Strings.Unbounded;

package operations is

    procedure ifOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);
    
    procedure gotoOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

    procedure nullOperation (operation : out Unbounded_String);

    procedure lireOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

    procedure ecrireOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

    procedure affectationOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

end operations;