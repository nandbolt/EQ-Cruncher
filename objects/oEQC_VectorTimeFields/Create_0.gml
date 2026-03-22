/// @desc Vector Fields Demo

/*
 * This demo showcases how to utilize expressions to make vector fields.
*/
event_inherited();

demo_name = "vector time fields";
output_string = "vx = f(x,y,t)";

vxs = [];
vys = [];
eq_spacing_idx = 2;
plot_resolution = 32;
point_radius = 2;
arrow_scale = 0.1;
arrowhead_size = 8;
start_x = xorigin - floor(room_width * 0.5 / plot_resolution) * plot_resolution - plot_resolution;
start_y = yorigin - floor(room_height * 0.5 / plot_resolution) * plot_resolution - plot_resolution;
var _i = 0;
for (var _y = start_y; _y < room_height + plot_resolution; _y += plot_resolution)
{
    for (var _x = start_x; _x < room_width + plot_resolution; _x += plot_resolution)
    {
        xs[_i] = _x;
        ys[_i] = _y;
        vxs[_i] = 0;
        vys[_i] = 0;
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
    var _xexpression = eqs[_eq_idx];
    var _yexpression = eqs[_eq_idx+1];
    for (var _i = 0; _i < point_count; _i++)
    {
        var _local_x = transform_to_local(xs[_i], xorigin, local_xscale);
        var _local_y = transform_to_local(ys[_i], yorigin, local_yscale);
        var _local_vx = _xexpression.evaluate([_local_x, _local_y, time]);
        var _local_vy = _yexpression.evaluate([_local_x, _local_y, time]);
        var _vx = _local_vx, _vy = _local_vy;
        if (!is_string(_vx) && !is_string(_vy))
        {
            _vx = transform_to_global(_local_vx * arrow_scale, 0, local_xscale);
            _vy = transform_to_global(_local_vy * arrow_scale, 0, local_yscale);
        }
        vxs[_i] = _vx;
        vys[_i] = _vy;
    }
}

/// @func   post_process_equation_string(eq_idx);
/// @desc Adds some post-processing to the equation's string if wanted.
post_process_equation_string = function(_eq_idx)
{
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x1", "x");
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x2", "y");
    eq_strs[_eq_idx] = string_replace_all(eq_strs[_eq_idx], "x3", "t");
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
    var _vx = vxs[_idx], _vy = vys[_idx];
    if (is_string(_vx) || is_string(_vy))
    {
        return;
    }
    draw_arrow(_x, _y, _x + _vx, _y + _vy, arrowhead_size);
}

#endregion

var _eq_idx = 0;

// vx = 1
// vy = 1
generate_equation(_eq_idx, [EQS.X3]);
_eq_idx++;
generate_equation(_eq_idx, [EQS.X3]);
eq_strs[_eq_idx] = string_replace(eq_strs[_eq_idx], "vx", "vy");
_eq_idx++;

// vx = x + y + t
// vy = x + y + t
generate_equation(_eq_idx, [EQS.X1, EQS.PLUS, EQS.X2, EQS.PLUS, EQS.X3]);
_eq_idx++;
generate_equation(_eq_idx, [EQS.X1, EQS.PLUS, EQS.X2, EQS.PLUS, EQS.X3]);
eq_strs[_eq_idx] = string_replace(eq_strs[_eq_idx], "vx", "vy");
_eq_idx++;

// vx = ysin(t)
// vy = x
generate_equation(_eq_idx, [EQS.X2, EQS.MULTIPLY, EQS.SINE, EQS.X3]);
_eq_idx++;
generate_equation(_eq_idx, [EQS.X1]);
eq_strs[_eq_idx] = string_replace(eq_strs[_eq_idx], "vx", "vy");
_eq_idx++;

// vx = 4sin(y+t)
// vy = 4cos(x+t)
generate_equation(_eq_idx, [EQS.FOUR, EQS.SINE, EQS.OPEN_PARENTHESIS, EQS.X2, EQS.PLUS, EQS.X3, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;
generate_equation(_eq_idx, [EQS.FOUR, EQS.COSINE, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X3, EQS.CLOSE_PARENTHESIS]);
eq_strs[_eq_idx] = string_replace(eq_strs[_eq_idx], "vx", "vy");
_eq_idx++;

// vx = 4sin(x+t)
// vy = 4cos(y+t)
generate_equation(_eq_idx, [EQS.FOUR, EQS.SINE, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X3, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;
generate_equation(_eq_idx, [EQS.FOUR, EQS.COSINE, EQS.OPEN_PARENTHESIS, EQS.X2, EQS.PLUS, EQS.X3, EQS.CLOSE_PARENTHESIS]);
eq_strs[_eq_idx] = string_replace(eq_strs[_eq_idx], "vx", "vy");
_eq_idx++;

// vx = 4sin(x+t)
// vy = 4cos(x+t)
generate_equation(_eq_idx, [EQS.FOUR, EQS.SINE, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X3, EQS.CLOSE_PARENTHESIS]);
_eq_idx++;
generate_equation(_eq_idx, [EQS.FOUR, EQS.COSINE, EQS.OPEN_PARENTHESIS, EQS.X1, EQS.PLUS, EQS.X3, EQS.CLOSE_PARENTHESIS]);
eq_strs[_eq_idx] = string_replace(eq_strs[_eq_idx], "vx", "vy");
_eq_idx++;

generate_plot(eq_idx);