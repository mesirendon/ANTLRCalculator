# Calculadora simple con ANTLR

Correr esto para tener todo listo:
```bash
rm -f *.java *.class *.tokens && antlr Calc.g4 && javac *.java
```

Correr con los ejemplos:
```bash
grun Calc prog -ps tree.ps examples.calc && okular tree.ps
```

## Importante

Esta calculadora permite realizar operaciones básicas entre números enteros, dobles y complejos. Las operaciones definidas son suma, resta, multiplicación, división y módulo.

La calculadora también computa los resultados de funciones trigonométricas (seno, coseno y tangente).

El módulo y las funciones trigonométricas se calculan sobre la parte real de un número (no se consideró el cálculo completo de éstas con complejos).
