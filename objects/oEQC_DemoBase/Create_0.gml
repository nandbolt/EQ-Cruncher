/// @desc EQ Cruncher Demo Base

/*
 * This is a base object inherited by the demos for EQ Cruncher.
*/

demo_name = "demo";
time = 0;

// Equations
eqs = [];
eq_strs = [];
eq_idx = 0;
eq_spacing_idx = 1;

// Points
xs = [];        // The x-coordinates of the current equation (1D Array)
ys = [];        // The y-coordinates of the current equation (1D Array)
plot_resolution = 8;
point_count = ceil((room_width + plot_resolution) / plot_resolution);
for (var _i = point_count - 1; _i > -1; _i--)
{
    xs[_i] = _i * plot_resolution;
}
point_radius = 2;
point_color = c_lime;

// Axes
xorigin = room_width * 0.5;
yorigin = room_height * 0.5;
local_xscale = 64;
local_yscale = -64;
axes_color = c_gray;
show_axes = true;

// GUI
xmargin = 16;
ymargin = 8;
output_string = "y";
eq_ytextcursor = ymargin;
show_gui = true;

#region Axes

/// @func   draw_axes();
/// @desc Draws the axes and some the associated information on them.
draw_axes = function()
{
    if (!show_axes)
    {
        return;
    }
    
    draw_set_colour(axes_color);
    draw_line(0, yorigin, room_width, yorigin);
    draw_line(xorigin, 0, xorigin, room_height);
    draw_line(xorigin + local_xscale, yorigin - 16, xorigin + local_xscale, yorigin + 16);
    draw_line(xorigin - 16, yorigin + local_yscale, xorigin + 16, yorigin + local_yscale);
    draw_circle(xorigin, yorigin, 4, false);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(xorigin + local_xscale, yorigin + 24, "1");
    draw_text(room_width - 32, yorigin + 24, "x");
    draw_set_halign(fa_right);
    draw_set_valign(fa_center);
    draw_text(xorigin - 24, yorigin + local_yscale, "1");
    draw_text(xorigin - 24, 32, "y");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

#endregion

#region Coordinate Transformations

/// @func   transform_to_local(global_coordinate, origin, scale);
/// @param {real} global_coordinate The global coordinate to convert
/// @param {real} origin Where the origin is globally
/// @param {real} scale The scale of the coordinate axis
/// @desc Converts the input global coordinate into a local coordinate system, returning the value.
transform_to_local = function(_global_coordinate, _origin, _scale)
{
    return (_global_coordinate - _origin) / _scale;
}

/// @func   transform_to_global(local_coordinate, origin, scale);
/// @param {real} local_coordinate The local coordinate to convert
/// @param {real} origin Where the origin is globally
/// @param {real} scale The scale of the coordinate axis
/// @desc Converts the input local coordinate into the global coordinate system, returning the value.
transform_to_global = function(_local_coordinate, _origin, _scale)
{
    return _local_coordinate * _scale + _origin;
}

#endregion

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
        var _local_y = _expression.evaluate([_local_x]);
        var _y = _local_y;
        if (!is_string(_local_y))
        {
            _y = transform_to_global(_local_y, yorigin, local_yscale);
        }
        ys[_i] = _y;
    }
}

/// @func   generate_equation(eq_idx, symbols);
/// @param {Real} eq_idx The equation index
/// @param {Array<Constant.EQS>} symbols
/// @desc Generates an equation at the given index.
generate_equation = function(_eq_idx, _symbols)
{
    eqs[_eq_idx] = new Expression();
    eqs[_eq_idx].set(_symbols);
    eq_strs[_eq_idx] = $"{output_string} = {string(eqs[_eq_idx])}";
    post_process_equation_string(_eq_idx);
}

/// @func   post_process_equation_string(eq_idx);
/// @desc Adds some post-processing to the equation's string if wanted.
post_process_equation_string = function(_eq_idx){}

#endregion

#region Plots

/// @func   draw_plot();
/// @desc Draws the current equation plot.
draw_plot = function()
{
    draw_set_colour(point_color);
    for (var _i = 0; _i < point_count; _i++)
    {
        var _x = xs[_i], _y = ys[_i];
        if (is_string(_x) || is_string(_y))
        {
            continue;
        }
        draw_plot_segment(_x, _y, _i);
    }
    draw_set_colour(c_white);
}

/// @func   draw_plot_segment(x, y, idx);
/// @param {Real} x
/// @param {Real} y
/// @param {Real} idx The current point index
/// @desc Draws a segment of the plot.
draw_plot_segment = function(_x, _y, _idx)
{
    draw_circle(_x, _y, point_radius, false);
}

/// @func   on_plot_changed();
/// @desc Called whenever a plot is changed (but not when the demo changes).
on_plot_changed = function()
{
    time = 0;
}

#endregion

#region Debugging

/// @func   print_equation(eq_idx);
/// @param {Real} eq_idx The equation index
/// @desc Prints information about the equation.
print_equation = function(_eq_idx)
{
    var _eq = eqs[eq_idx];
    show_debug_message($"\ny = {_eq}");
    show_debug_message($"symbols: {_eq.symbols}");
    show_debug_message($"postfix: {_eq.postfix_symbols}");
    show_debug_message($"tree: {_eq.tree}");
}

#endregion