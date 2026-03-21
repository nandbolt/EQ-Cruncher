/// @desc Time Equations Demo

/*
 * This demo showcases how to utilize expressions to make use of time
 * as a function argument.
*/
event_inherited();

demo_name = "time equations";
output_string = "y = f(x,t)";

time = 0;

#region Point Generation

/// @func   generate_ys(xs, ys, expression);
/// @param {Array<Real>} xs The array of x-coordinates to use
/// @param {Array<Real>} ys The array of y-coordinates to fill (empty)
/// @param {Struct.Expression} expression The expression to generate the y-coordinates
/// @desc Generates all of the given y-coordinates based on the given x-coordinates and expression
generate_ys = function(_xs, _ys, _expression)
{
    for (var _i = 0; _i < point_count; _i++)
    {
        var _x = _i * plot_resolution;
        _xs[_i] = _x;
        var _local_x = transform_to_local(_x, xorigin, local_xscale);
        var _local_y = _expression.evaluate([_local_x, time]);
        var _y = _local_y;
        if (!is_string(_local_y))
        {
            _y = transform_to_global(_local_y, yorigin, local_yscale);
        }
        _ys[_i] = _y;
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

#region Plots

/// @func   on_plot_changed();
/// @desc Called whenever a plot is changed (but not when the demo changes).
on_plot_changed = function()
{
    time = 0;
}

#endregion

var _eq_idx = 0;

// f(x,t) = sin(x + t)
generate_equation(_eq_idx, [EQS.SINE, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X2, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;

// f(x,t) = tx^2
generate_equation(_eq_idx, [EQS.X2, EQS.X1, EQS.POWER, EQS.TWO]);
_eq_idx++;