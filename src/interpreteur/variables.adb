package body variables is

     function getValeur(variable : in T_Variable) return T is
     begin
        return variable.valeurVariable;
    end getValeur;

    procedure setValeur(variable : in out T_Variable; valeur : in T) is
    begin
        variable.valeurVariable := valeur;
    end setValeur;

    function getNom(variable : in T_Variable) return Unbounded_String is
    begin
        return variable.nomVariable;
    end getNom;

    procedure setNom(variable : in out T_Variable; nomVariable : in Unbounded_String) is
    begin
        variable.nomVariable := nom;
    end setNom;

    function getType(variable : in T_Variable) return Unbounded_String is
    begin
        return variable.typeVariable;
    end getType;

    procedure setType(variable : in out T_Variable; typeVariable : in Unbounded_String) is
    begin
        variable.typeVariable := typeVariable;
    end setType;

    function isConstant(variable : in T_Variable) return Boolean is
    begin
        return variable.isConstant;
    end isConstant;

end variables;