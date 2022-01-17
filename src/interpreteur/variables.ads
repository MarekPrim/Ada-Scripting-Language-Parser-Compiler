generic
type T is private
package variables is

    type T_Variable is record
        valeurVariable : T;
        typeVariable : Chaine;
        nomVariable : Chaine;
        isConstant : Boolean;
    end record;

end variables;