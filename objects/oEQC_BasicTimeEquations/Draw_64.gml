/// @desc Show Time + GUI
event_inherited();

// Time
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_colour(c_gray);
draw_text(display_get_gui_width() - xmargin, eq_ytextcursor, $"time(s): {time}");