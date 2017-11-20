grammar Calc;

@header {
  import java.util.*;
}

@parser::members {
  Map<String, double[]> memory = new HashMap<String, double[]>();
  double[] eval(double[] left, int op, double[] right) {
    switch(op) {
      case MUL : return new double[] { left[0] * right[0] - left[1] * right[1], left[0] * right[1] + left[1] * right[0] };
      case DIV : return new double[] { left[0] + right[0], left[1] + right[1] };
      case MOD : return new double[] { left[0] + right[0], left[1] + right[1] };
      case ADD : return new double[] { left[0] + right[0], left[1] + right[1] };
      case SUB : return new double[] { left[0] - right[0], left[1] - right[1] };
    }
    return new double[] {0,0};
  }
}

prog: stat+ ;

stat: e NEWLINE        {System.out.println("(" + $e.v[0] + "+" + $e.v[1] + "i)");}
    | ID '=' e NEWLINE {memory.put($ID.text, $e.v);}
    | NEWLINE
    ;

e returns [double[] v]
    : a=e op=('*'|'/'|'%') b=e     {$v = eval($a.v, $op.type, $b.v);}
    | a=e op=('+'|'-')     b=e     {$v = eval($a.v, $op.type, $b.v);}
    | '(' re=e ('+'|'-') im=e 'i)' {$v = new double[] {$re.v[0], $im.v[0]};}
    | INT                          {$v = new double[] {$INT.int, 0};}
    | DOUBLE                       {$v = new double[] {Double.parseDouble($DOUBLE.text), 0};}
    | ID
      {
        String id = $ID.text;
        $v = memory.containsKey(id) ? memory.get(id) : new double[] {0, 0};
      }
    | '(' e ')'                    {$v = $e.v;}
    ;

MUL : '*' ;
DIV : '/' ;
MOD : '%' ;
ADD : '+' ;
SUB : '-' ;

ID      : [a-zA-Z]+ ;
INT     : [0-9]+ ;
DOUBLE  : [0-9]+'.'[0-9]+;
NEWLINE : '\r'? '\n' ;
WS      : [ \t]+ -> skip ;
