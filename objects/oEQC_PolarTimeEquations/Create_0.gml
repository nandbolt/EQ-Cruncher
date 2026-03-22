/// @desc Polar Time Equations Demo

/*
 * This demo showcases how to utilize expressions to plot polar equations.
 * All of the operators are showcased with their parent (or parent-like) functions.
*/
event_inherited();

demo_name = "polar time equations";
output_string = "r = f(theta, t)";

thetas = [];
rs = [];
point_count = 172;
plot_resolution = 2 * pi / 64;
for (var _i = point_count - 1; _i > -1; _i--)
{
    thetas[_i] = _i * plot_resolution;
    xs[_i] = 0;
    ys[_i] = 0;
}

#region Point Generation

/// @func   generate_plot(eq_idx);
/// @param {Real} eq_idx The equation index
/// @desc Generates a plot for the given equation index.
generate_plot = function(_eq_idx)
{
    var _expression = eqs[_eq_idx];
    for (var _i = 0; _i < point_count; _i++)
    {
        var _theta = _i * plot_resolution;
        thetas[_i] = _theta;
        var _r = _expression.evaluate([_theta, time]);
        var _local_x = 0, _local_y = 0;
        if (!is_string(_r))
        {
            _local_x = cos(_theta) * _r;
            _local_y = sin(_theta) * _r;
        }
        xs[_i] = transform_to_global(_local_x, xorigin, local_xscale);
        ys[_i] = transform_to_global(_local_y, yorigin, local_yscale);
    }
}

/// @func   post_process_equation_string(eq_idx);
/// @desc Adds some post-processing to the equation's string if wanted.
post_process_equation_string = function(_eq_idx)
{
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x1", "theta");
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x2", "t");
}

#endregion

var _eq_idx = 0;

// r = t
generate_equation(_eq_idx, [EQS.X2]);
_eq_idx++;

// r = theta - t
generate_equation(_eq_idx, [EQS.X1, EQS.MINUS, EQS.X2]);
_eq_idx++;

// r = ttheta^2
generate_equation(_eq_idx, [EQS.X2, EQS.X1, EQS.POWER, EQS.TWO]);
_eq_idx++;

// r = t / theta
generate_equation(_eq_idx, [EQS.X2, EQS.DIVIDE, EQS.X1]);
_eq_idx++;

// r = sin(theta)
generate_equation(_eq_idx, [EQS.SINE, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X2, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;

// r = tan(theta)
generate_equation(_eq_idx, [EQS.TANGENT, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X2, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;

// r = theta mod 2
generate_equation(_eq_idx, [EQS.X1, EQS.MOD, EQS.X2]);
_eq_idx++;

// r = round(theta)
generate_equation(_eq_idx, [EQS.ROUND, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.MINUS, EQS.X2, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;

generate_plot(eq_idx);