with intermediaire, Ada.Strings.Unbounded; 
use intermediaire, Ada.Strings.Unbounded;

package operations is

    -- ifOperation
    -- paramètres :
    --  ligne : in Unbounded_String
    --  i : in out integer
    --  ptrInstruction : in out T_Ptr_Instruction
    --  operation : out Unbounded_String
    --  variables : in T_List_Variable
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure ifOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);
    
    -- gotoOperation
    -- paramètres :
    --  ligne : in Unbounded_String
    --  i : in out integer
    --  ptrInstruction : in out T_Ptr_Instruction
    --  operation : out Unbounded_String
    --  variables : in T_List_Variable
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure gotoOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

    -- nullOperation
    -- paramètres :
    --  operation : out Unbounded_String
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure nullOperation (operation : out Unbounded_String);

    -- lireOperation
    -- paramètres :
    --  ligne : in Unbounded_String
    --  i : in out integer
    --  ptrInstruction : in out T_Ptr_Instruction
    --  operation : out Unbounded_String
    --  variables : in T_List_Variable
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure lireOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

    -- ecrireOperation
    -- paramètres :
    --  ligne : in Unbounded_String
    --  i : in out integer
    --  ptrInstruction : in out T_Ptr_Instruction
    --  operation : out Unbounded_String
    --  variables : in T_List_Variable
    -- précondition : /
    -- postcondition : /
    -- exception : /
    procedure ecrireOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

    -- affectationOperation
    -- paramètres :
    --  ligne : in Unbounded_String
    --  i : in out integer
    --  ptrInstruction : in out T_Ptr_Instruction
    --  operation : out Unbounded_String
    --  variables : in T_List_Variable
    -- précondition : /
    -- postcondition : /
    -- exception : Element_Tableau_Deja_Utilise
    procedure affectationOperation (ligne : in Unbounded_String; i : in out integer; ptrInstruction : in out T_Ptr_Instruction; operation : out Unbounded_String; variables : in T_List_Variable);

end operations;