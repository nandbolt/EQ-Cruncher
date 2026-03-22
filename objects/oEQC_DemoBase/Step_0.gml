/// @desc Update Time + GIF
time += delta_time / 1000000;

if (global.save_gif == true)
{
    if (global.gif_timer == 0)
    {
        global.gif_image = gif_open(window_get_width(), window_get_height());
    }
    else if (global.gif_timer < global.gif_frames)
    {
        gif_add_surface(global.gif_image, application_surface, global.gif_delay);
    }
    else
    {
        gif_save(global.gif_image, $"gifs/gif_{global.screenshot_idx}.gif");
        global.gif_timer = 0;
        global.save_gif = false;
    }
    global.gif_timer++;
}