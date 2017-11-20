# Simple calculator with ANTLR

Run this to get everything ready:
```bash
rm -f *.java *.class *.tokens && antlr Calc.g4 && javac *.java
```

Run with the example:
```bash
grun Calc prog -ps tree.ps examples.calc && okular tree.ps
```
