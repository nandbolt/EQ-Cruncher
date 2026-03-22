/// @desc Equation + Controls

// Demo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(xmargin, ymargin, demo_name);

// Equation
draw_set_halign(fa_right);
draw_set_colour(point_color);
draw_text(room_width - xmargin, ymargin, eq_strs[eq_idx]);

// Controls
draw_set_valign(fa_bottom);
draw_set_colour(c_orange);
var _x = room_width - xmargin;
var _y = room_height - ymargin, _yspacing = string_height("A");
draw_text(_x, _y, "down: previous demo");
_y -= _yspacing;
draw_text(_x, _y, "up: next demo");
_y -= _yspacing * 2;
draw_set_colour(c_yellow);
draw_text(_x, _y, "left: previous plot");
_y -= _yspacing;
draw_text(_x, _y, "right: next plot");