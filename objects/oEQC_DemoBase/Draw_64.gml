/// @desc Equation + Controls

if (!show_gui)
{
    exit;
}

// Demo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(xmargin, ymargin, demo_name);

// Equation
draw_set_halign(fa_right);
draw_set_colour(point_color);
eq_ytextcursor = ymargin;
var _yspacing = string_height("A");
for (var _i = 0; _i < eq_spacing_idx; _i++)
{
    draw_text(display_get_gui_width() - xmargin, eq_ytextcursor, eq_strs[eq_idx + _i]);
    eq_ytextcursor += _yspacing;
}

// Controls
draw_set_valign(fa_bottom);
draw_set_colour(c_orange);
var _x = display_get_gui_width() - xmargin;
var _y = display_get_gui_height() - ymargin;
draw_text(_x, _y, "down: previous demo");
_y -= _yspacing;
draw_text(_x, _y, "up: next demo");
_y -= _yspacing * 2;
draw_set_colour(c_yellow);
draw_text(_x, _y, "left: previous plot");
_y -= _yspacing;
draw_text(_x, _y, "right: next plot");