// Inherit the parent event
event_inherited();

// Z -> Color
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_colour(c_gray);
draw_text(room_width - xmargin, eq_ytextcursor, $"z (normalized) -> color: hsv = (z,255,255), 0 <= z <= 255");
eq_ytextcursor += string_height("A");
draw_text(room_width - xmargin, eq_ytextcursor, $"time(s): {time}");