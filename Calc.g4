grammar Calc;

@header {
  import java.util.*;
  import java.lang.*;
}

@parser::members {
  Map<String, double[]> memory = new HashMap<String, double[]>();
  double[] eval(double[] left, int op, double[] right) {
    switch(op) {
      case MUL : return evalAux(left, 0, right);
      case DIV : return evalAux(left, 1, right);
      case MOD : return evalAux(left, 2, right);
      case ADD : return evalAux(left, 3, right);
      case SUB : return evalAux(left, 4, right);
    }
    return new double[] {0,0};
  }

  double[] evalAux(double[] left, int op, double[] right) {
    switch(op) {
      case 0 : return new double[] { left[0] * right[0] - left[1] * right[1], left[0] * right[1] + left[1] * right[0] };
      case 1 :
        double[] conj = new double[] { right[0], -right[1] };
        double[] num = evalAux(left, 0, conj);
        double[] den = evalAux(right, 0, conj);
        return new double[] {num[0] / den[0], num[1] / den[0]};
      case 2 : return new double[] { left[0] % right[0], 0 };
      case 3 : return new double[] { left[0] + right[0], left[1] + right[1] };
      case 4 : return new double[] { left[0] - right[0], left[1] - right[1] };
    }
    return new double[] {0,0};
  }

  double[] trig(int func, double[] elem) {
    switch(func) {
      case SIN : return new double[] {Math.sin(Math.toRadians( elem[0] )), 0};
      case COS : return new double[] {Math.cos(Math.toRadians( elem[0] )), 0};
      case TAN : return new double[] {Math.tan(Math.toRadians( elem[0] )), 0};
    }
    return new double[] {0,0};
  }
}

prog: stat+ ;

stat: e NEWLINE        {System.out.println("(" + $e.v[0] + ( $e.v[1] >= 0 ? "+" : "" ) + $e.v[1] + "i)");}
    | ID '=' e NEWLINE {memory.put($ID.text, $e.v);}
    | NEWLINE
    ;

e returns [double[] v]
    : SUB e                              {$v = new double[] {-$e.v[0], -$e.v[1]};}
    | a=e op=(MUL | DIV | MOD) b=e       {$v = eval($a.v, $op.type, $b.v);}
    | a=e op=(ADD | SUB) b=e             {$v = eval($a.v, $op.type, $b.v);}
    | LPAR re=e ADD im=e IMAG RPAR       {$v = new double[] {$re.v[0], $im.v[0]};}
    | LPAR re=e SUB im=e IMAG RPAR       {$v = new double[] {$re.v[0], -$im.v[0]};}
    | INT                                {$v = new double[] {$INT.int, 0};}
    | DOUBLE                             {$v = new double[] {Double.parseDouble($DOUBLE.text), 0};}
    | ID
      {
        String id = $ID.text;
        $v = memory.containsKey(id) ? memory.get(id) : new double[] {0, 0};
      }
    | func=(SIN | COS | TAN) LPAR e RPAR {$v = trig($func.type, $e.v);}
    | '(' e ')'                          {$v = $e.v;}
    ;

trig
    : SIN
    | COS
    | TAN
    ;

SIN : 'sin' ;
COS : 'cos' ;
TAN : 'tan' ;

MUL  : '*' ;
DIV  : '/' ;
MOD  : '%' ;
ADD  : '+' ;
SUB  : '-' ;
LPAR : '(' ;
RPAR : ')' ;
IMAG : 'i' ;

ID      : [a-zA-Z]+ ;
INT     : [0-9]+ ;
DOUBLE  : [0-9]+'.'[0-9]+;
NEWLINE : '\r'? '\n' ;
WS      : [ \t]+ -> skip ;
