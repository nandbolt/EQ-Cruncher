// Inherit the parent event
event_inherited();

// Vector Scale
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_colour(c_gray);
draw_text(room_width - xmargin, eq_ytextcursor, $"vector scaling: {arrow_scale}");
eq_ytextcursor += string_height("A");
draw_text(room_width - xmargin, eq_ytextcursor, $"time(s): {time}");