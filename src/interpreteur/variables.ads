with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

generic
type T is private;
package variables is

    type T_Variable is record
        valeurVariable : T;
        typeVariable : Unbounded_String;
        nomVariable : Unbounded_String;
        isConstant : Boolean;
    end record;

    function getValeur(variable : in T_Variable) return T;
    procedure setValeur(variable : in out T_Variable; valeur : in T);

    function getType(variable : in T_Variable) return Unbounded_String;
    procedure setType(variable : in out T_Variable; typeVariable : in Unbounded_String);

    function getNom(variable : in T_Variable) return Unbounded_String;
    procedure setNom(variable : in out T_Variable; nomVariable : in Unbounded_String);

    function isConstant(variable : in T_Variable) return Boolean;


end variables;