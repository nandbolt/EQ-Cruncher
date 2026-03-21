/// @desc Axes + Plot
draw_axes();

// Plot
draw_set_colour(point_color);
for (var _i = 0; _i < point_count; _i++)
{
    var _y = ys[eq_idx][_i];
    if (is_string(_y))
    {
        continue;
    }
    
    var _x = xs[_i];
    draw_circle(_x, _y, point_radius, false);
}
draw_set_colour(c_white);