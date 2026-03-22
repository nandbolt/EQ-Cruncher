/// @desc Next Plot
eq_idx++;
if (eq_idx >= array_length(eqs))
{
    eq_idx = 0;
}
generate_plot(eq_idx);
on_plot_changed();