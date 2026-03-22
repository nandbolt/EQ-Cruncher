/// @desc Basic Equations Demo

/*
 * This demo showcases how to utilize expressions to make basic scatter plots.
 * All of the operators are showcased with their parent (or parent-like) functions.
*/
event_inherited();

demo_name = "basic equations";
output_string = "y = f(x)";

#region Point Generation

/// @func   post_process_equation_string(eq_idx);
/// @desc Adds some post-processing to the equation's string if wanted.
post_process_equation_string = function(_eq_idx)
{
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x1", "x");
}

#endregion

var _eq_idx = 0;

// y = 1
generate_equation(_eq_idx, [EQS.ONE]);
_eq_idx++;

// y = x
generate_equation(_eq_idx, [EQS.X1]);
_eq_idx++;

// y = x^2
generate_equation(_eq_idx, [EQS.X1, EQS.POWER, EQS.TWO]);
_eq_idx++;

// y = x^3
generate_equation(_eq_idx, [EQS.X1, EQS.POWER, EQS.THREE]);
_eq_idx++;

// y = 1 / x
generate_equation(_eq_idx, [EQS.ONE, EQS.DIVIDE, EQS.X1]);
_eq_idx++;

// y = sqrt(x)
generate_equation(_eq_idx, [EQS.ROOT, EQS.X1]);
_eq_idx++;

// y = log10(x)
generate_equation(_eq_idx, [EQS.LOG, EQS.X1]);
_eq_idx++;

// y = sin(x)
generate_equation(_eq_idx, [EQS.SINE, EQS.X1]);
_eq_idx++;

// y = cos(x)
generate_equation(_eq_idx, [EQS.COSINE, EQS.X1]);
_eq_idx++;

// y = tan(x)
generate_equation(_eq_idx, [EQS.TANGENT, EQS.X1]);
_eq_idx++;

// y = x mod 2
generate_equation(_eq_idx, [EQS.X1, EQS.MOD, EQS.TWO]);
_eq_idx++;

// y = abs(x)
generate_equation(_eq_idx, [EQS.ABSOLUTE_VALUE, EQS.X1]);
_eq_idx++;

// y = round(x)
generate_equation(_eq_idx, [EQS.ROUND, EQS.X1]);
_eq_idx++;

generate_plot(eq_idx);