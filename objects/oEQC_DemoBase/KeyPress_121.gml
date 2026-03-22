/// @desc Fullscreen
var _fullscreen = !window_get_fullscreen();
window_set_fullscreen(_fullscreen)
if (_fullscreen)
{
    surface_resize(application_surface, display_get_width(), display_get_height());
    display_set_gui_size(display_get_width(), display_get_height());
}
else
{
    surface_resize(application_surface, room_width, room_height);
    display_set_gui_size(room_width, room_height);
}