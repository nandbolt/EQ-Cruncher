/// @desc Previous Plot
eq_idx -= eq_spacing_idx;
if (eq_idx < 0)
{
    eq_idx = array_length(eqs) - eq_spacing_idx;
}
generate_plot(eq_idx);
on_plot_changed();