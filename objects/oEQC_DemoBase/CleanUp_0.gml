/// @desc Free Equations
for (var _i = 0; _i < array_length(eqs); _i++)
{
    var _expression = eqs[_i];
    if (is_instanceof(_expression, Expression))
    {
        _expression.cleanup();
        delete _expression;
    }
}