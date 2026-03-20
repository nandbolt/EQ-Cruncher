/// @desc EQ Cruncher Scatter Plot Demo

eq1 = new Expression();
eq1.set([EQS.ONE, EQS.PLUS, EQS.TWO, EQS.MULTIPLY, EQS.THREE]);
value = eq1.evaluate();
show_debug_message($"\nexpression 1: {eq1} = {value}");
show_debug_message($"symbols: {eq1.symbols}");
show_debug_message($"postfix: {eq1.postfix_symbols}");
show_debug_message($"tree: {eq1.tree}");