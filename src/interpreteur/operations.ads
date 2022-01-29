with intermediaire, Ada.Strings.Unbounded; 
use intermediaire, Ada.Strings.Unbounded;

package operations is

    -- if_operation
    -- paramètres :
    --  ligne : in Unbounded_String
    --  i : in out integer
    --  ptrInstruction : in out T_Ptr_Instruction
    --  operation : out Unbounded_String
    --  variables : in T_List_Variable
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure if_operation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);
    
    -- goto_operation
    -- paramètres :
    --  ligne : in Unbounded_String
    --  i : in out integer
    --  ptrInstruction : in out T_Ptr_Instruction
    --  operation : out Unbounded_String
    --  variables : in T_List_Variable
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure goto_operation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

    -- null_operation
    -- paramètres :
    --  operation : out Unbounded_String
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure null_operation (operation : out Unbounded_String);

    -- lire_operation
    -- paramètres :
    --  ligne : in Unbounded_String
    --  i : in out integer
    --  ptrInstruction : in out T_Ptr_Instruction
    --  operation : out Unbounded_String
    --  variables : in T_List_Variable
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure lire_operation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

    -- ecrire_operation
    -- paramètres :
    --  ligne : in Unbounded_String
    --  i : in out integer
    --  ptrInstruction : in out T_Ptr_Instruction
    --  operation : out Unbounded_String
    --  variables : in T_List_Variable
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure ecrire_operation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

    -- affectation_operation
    -- paramètres :
    --  ligne : in Unbounded_String
    --  i : in out integer
    --  ptrInstruction : in out T_Ptr_Instruction
    --  operation : out Unbounded_String
    --  variables : in T_List_Variable
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure affectation_operation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

end operations;