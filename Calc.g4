grammar Calc;

@header {
  import java.util.*;
}

@parser::members {
  Map<String, Double> memory = new HashMap<String, Double>();
  double eval(double left, int op, double right) {
    switch(op) {
      case MUL : return left * right;
      case DIV : return left / right;
      case MOD : return left % right;
      case ADD : return left + right;
      case SUB : return left - right;
    }
    return 0;
  }

  public class Tuple<A, B> {

    public final A a;
    public final B b;

    public Tuple(A a, B b) {
      this.a = a;
      this.b = b;
    }

    @Override
      public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Tuple<?, ?> tuple = (Tuple<?, ?>) o;
        if (!a.equals(tuple.a)) return false;
        return b.equals(tuple.b);
      }

    @Override
      public int hashCode() {
        int result = a.hashCode();
        result = 31 * result + b.hashCode();
        return result;
      }
  }
}

prog: stat+ ;

stat: e NEWLINE        {System.out.println($e.v);}
    | ID '=' e NEWLINE {memory.put($ID.text, $e.v);}
    | NEWLINE
    ;

e returns [double v]
    : a=e op=('*'|'/'|'%') b=e {$v = eval((Double)$a.v, $op.type, (Double)$b.v);}
    | a=e op=('+'|'-')     b=e {$v = eval((Double)$a.v, $op.type, (Double)$b.v);}
    | INT                      {$v = $INT.int;}
    | DOUBLE                   {$v = Double.parseDouble($DOUBLE.text);}
    | ID
      {
        String id = $ID.text;
        $v = memory.containsKey(id) ? memory.get(id) : 0;
      }
    | '(' e ')'                {$v = $e.v;}
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
