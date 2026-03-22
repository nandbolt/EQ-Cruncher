/// @desc Basic Time Equations Demo

/*
 * This demo showcases how to utilize expressions to make use of time
 * as a function argument.
*/
event_inherited();

demo_name = "basic time equations";
output_string = "y = f(x,t)";

#region Point Generation

/// @func   generate_plot(eq_idx);
/// @param {Real} eq_idx The equation index
/// @desc Generates a plot for the given equation index.
generate_plot = function(_eq_idx)
{
    var _expression = eqs[_eq_idx];
    for (var _i = 0; _i < point_count; _i++)
    {
        var _x = _i * plot_resolution;
        xs[_i] = _x;
        var _local_x = transform_to_local(_x, xorigin, local_xscale);
        var _local_y = _expression.evaluate([_local_x, time]);
        var _y = _local_y;
        if (!is_string(_local_y))
        {
            _y = transform_to_global(_local_y, yorigin, local_yscale);
        }
        ys[_i] = _y;
    }
}

/// @func   post_process_equation_string(eq_idx);
/// @desc Adds some post-processing to the equation's string if wanted.
post_process_equation_string = function(_eq_idx)
{
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x1", "x");
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x2", "t");
}

#endregion

var _eq_idx = 0;

// y = tx
generate_equation(_eq_idx, [EQS.X2, EQS.X1]);
_eq_idx++;

// y = tx^2
generate_equation(_eq_idx, [EQS.X2, EQS.X1, EQS.POWER, EQS.TWO]);
_eq_idx++;

// y = t / x
generate_equation(_eq_idx, [EQS.X2, EQS.DIVIDE, EQS.X1]);
_eq_idx++;

// y = t root x
generate_equation(_eq_idx, [EQS.X2, EQS.ROOT, EQS.X1]);
_eq_idx++;

// y = sin(x + t)
generate_equation(_eq_idx, [EQS.SINE, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X2, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;

// y = 2cos(2x + t) + cos(x + t)
generate_equation(_eq_idx, [EQS.TWO, EQS.COSINE, EQS.OPEN_PARENTHESIS, EQS.TWO, EQS.X1, EQS.PLUS, EQS.X2, EQS.CLOSE_PARENTHESIS, EQS.PLUS, EQS.COSINE, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X2, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;

// y = tan(x + t)
generate_equation(_eq_idx, [EQS.TANGENT, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X2, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;

// y = tx mod 2
generate_equation(_eq_idx, [EQS.OPEN_PARENTHESIS, EQS.X2, EQS.X1, EQS.CLOSE_PARENTHESIS, EQS.MOD, EQS.TWO]);
_eq_idx++;

// y = |tx|
generate_equation(_eq_idx, [EQS.ABSOLUTE_VALUE, EQS.OPEN_PARENTHESIS, EQS.X2, EQS.X1, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;

// y = round(tx)
generate_equation(_eq_idx, [EQS.ROUND, EQS.OPEN_PARENTHESIS, EQS.X2, EQS.X1, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;