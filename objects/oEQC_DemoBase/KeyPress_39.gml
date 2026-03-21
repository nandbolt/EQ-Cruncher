/// @desc Next Plot
eq_idx++;
if (eq_idx >= array_length(ys))
{
    eq_idx = 0;
}
on_plot_changed();