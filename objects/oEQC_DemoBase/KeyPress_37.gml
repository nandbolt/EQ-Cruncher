/// @desc Previous Plot
eq_idx--;
if (eq_idx < 0)
{
    eq_idx = array_length(eqs) - 1;
}
generate_plot(eq_idx);
on_plot_changed();