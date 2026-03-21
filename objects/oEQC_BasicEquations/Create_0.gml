/// @desc Basic Equations Demo

/*
 * This demo showcases how to utilize expressions to make basic scatter plots.
 * All of the operators are showcased with their parent (or parent-like) functions.
*/
event_inherited();

demo_name = "basic equations";
output_string = "y = f(x)";

/// @func   post_process_equation_string(eq_idx);
/// @desc Adds some post-processing to the equation's string if wanted.
post_process_equation_string = function(_eq_idx)
{
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x1", "x");
}

var _eq_idx = 0;

// f(x) = 0
generate_equation(_eq_idx, [EQS.ZERO]);
_eq_idx++;

// f(x) = x
generate_equation(_eq_idx, [EQS.X1]);
_eq_idx++;

// f(x) = x^2
generate_equation(_eq_idx, [EQS.X1, EQS.POWER, EQS.TWO]);
_eq_idx++;

// f(x) = x^3
generate_equation(_eq_idx, [EQS.X1, EQS.POWER, EQS.THREE]);
_eq_idx++;

// f(x) = 1 / x
generate_equation(_eq_idx, [EQS.ONE, EQS.DIVIDE, EQS.X1]);
_eq_idx++;

// f(x) = sqrt(x)
generate_equation(_eq_idx, [EQS.ROOT, EQS.X1]);
_eq_idx++;

// f(x) = log10(x)
generate_equation(_eq_idx, [EQS.LOG, EQS.X1]);
_eq_idx++;

// f(x) = sin(x)
generate_equation(_eq_idx, [EQS.SINE, EQS.X1]);
_eq_idx++;

// f(x) = cos(x)
generate_equation(_eq_idx, [EQS.COSINE, EQS.X1]);
_eq_idx++;

// f(x) = tan(x)
generate_equation(_eq_idx, [EQS.TANGENT, EQS.X1]);
_eq_idx++;

// f(x) = x mod 2
generate_equation(_eq_idx, [EQS.X1, EQS.MOD, EQS.TWO]);
_eq_idx++;

// f(x) = abs(x)
generate_equation(_eq_idx, [EQS.ABSOLUTE_VALUE, EQS.X1]);
_eq_idx++;

// f(x) = round(x)
generate_equation(_eq_idx, [EQS.ROUND, EQS.X1]);
_eq_idx++;