// Inherit the parent event
event_inherited();

// Theta
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_colour(c_gray);
draw_text(room_width - xmargin, ymargin + string_height("A"), $"0 <= theta <= {plot_resolution * point_count}");