/// @desc Basic Equations Demo

/*
 * This demo showcases how to utilize expressions to make scalar fields.
*/
event_inherited();

demo_name = "scalar fields";
output_string = "z = f(x,y)";

zs = [];
zmin = 0;
zmax = 0;
min_hue = 0;
max_hue = 255;
plot_resolution = 16;
point_radius = 2;
start_x = xorigin - floor(room_width * 0.5 / plot_resolution) * plot_resolution;
start_y = yorigin - floor(room_height * 0.5 / plot_resolution) * plot_resolution;
var _i = 0;
for (var _y = start_y; _y < room_height; _y += plot_resolution)
{
    for (var _x = start_x; _x < room_width; _x += plot_resolution)
    {
        xs[_i] = _x;
        ys[_i] = _y;
        zs[_i] = 0;
        _i++;
    }
}
point_count = _i;

#region Point Generation

/// @func   generate_plot(eq_idx);
/// @param {Real} eq_idx The equation index
/// @desc Generates a plot for the given equation index.
generate_plot = function(_eq_idx)
{
    var _expression = eqs[_eq_idx];
    for (var _i = 0; _i < point_count; _i++)
    {
        var _local_x = transform_to_local(xs[_i], xorigin, local_xscale);
        var _local_y = transform_to_local(ys[_i], yorigin, local_yscale);
        var _local_z = _expression.evaluate([_local_x, _local_y]);
        zs[_i] = _local_z;
    }
    
    zmin = undefined;
    zmax = undefined;
    for (var _i = 0; _i < point_count; _i++)
    {
        var _z = zs[_i];
        if (is_string(_z) || is_infinity(_z))
        {
            continue;
        }
        
        if (is_undefined(zmin))
        {
            zmin = _z;
        }
        else
        {
        	zmin = min(zmin, _z);
        }
        
        if (is_undefined(zmax))
        {
            zmax = _z;
        }
        else
        {
            zmax = max(zmax, _z);
        }
    }
}

/// @func   post_process_equation_string(eq_idx);
/// @desc Adds some post-processing to the equation's string if wanted.
post_process_equation_string = function(_eq_idx)
{
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x1", "x");
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x2", "y");
}

#endregion

#region Plots

/// @func   draw_plot_segment(x, y, idx);
/// @param {Real} x
/// @param {Real} y
/// @param {Real} idx The current point index
/// @desc Draws a segment of the plot.
draw_plot_segment = function(_x, _y, _idx)
{
    if (is_string(zs[_idx]))
    {
        return;
    }
    var _hue = (zs[_idx] - zmin) / (zmax - zmin) * max_hue;
    var _color = make_colour_hsv(_hue, 255, 255);
    draw_set_colour(_color);
    draw_circle(_x, _y, point_radius, false);
}

#endregion

var _eq_idx = 0;

// z = 1
generate_equation(_eq_idx, [EQS.ONE]);
_eq_idx++;

// z = x + y
generate_equation(_eq_idx, [EQS.X1, EQS.PLUS, EQS.X2]);
_eq_idx++;

// z = sqrt(x^2 + y^2)
generate_equation(_eq_idx, [EQS.ROOT, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.POWER, EQS.TWO, EQS.PLUS, EQS.X2, EQS.POWER, EQS.TWO, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;

// z = sin(x) + cos(y)
generate_equation(_eq_idx, [EQS.SINE, EQS.X1, EQS.PLUS, EQS.COSINE, EQS.X2]);
_eq_idx++;

// z = sin(x)
generate_equation(_eq_idx, [EQS.SINE, EQS.X1]);
_eq_idx++;

// z = 1 / (x + y)
generate_equation(_eq_idx, [EQS.ONE, EQS.DIVIDE, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X2, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;

generate_plot(eq_idx);