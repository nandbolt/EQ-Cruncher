/// @desc Previous Plot
eq_idx--;
if (eq_idx < 0)
{
    eq_idx = array_length(ys) - 1;
}
on_plot_changed();