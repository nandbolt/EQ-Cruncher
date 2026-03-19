/// @func   Expression();
/// @desc A mathematical expression that can "hopefully" evaluate into a number.
function Expression() constructor
{
    static initialized = false;
    
    symbols = [];
    postfix_symbols = [];
    static precedence_map = ds_map_create();
    static special_constants_map = ds_map_create();
    
    tree = new BinaryTree();
    
    error_message = "";
    
    #region Setters
    
    /// @func   set(symbols);
    /// @param {Array<Constant.EQS>} symbols
    /// @desc Sets the equation using the given symbols.
    static set = function(_symbols)
    {
        error_message = validate(_symbols);
        show_debug_message(_symbols);
        show_debug_message(error_message);
        if (is_valid())
        {
            update_symbols(_symbols);
            update_postfix_symbols();
            update_tree();
        }
    }
    
    #endregion
    
    #region Events
    
    /// @func   cleanup();
    /// @desc Cleans up any memory before getting deleted.
    static cleanup = function()
    {
        symbols = -1;
        postfix_symbols = -1;
        
        tree.cleanup();
        delete tree;
    }
    
    #endregion
    
    #region General
    
    /// @func   clear();
    /// @desc Clears the expression so that it can be reused.
    static clear = function()
    {
        symbols = [];
        tree.clear();
        error_message = "";
    }
    
    #endregion
    
    #region Validation
    
    /// @func   validate(symbols);
    /// @param {Array<Constant.EQS>} symbols
    /// @desc Validates the given symbols, returning either an error message or empty string if no errors.
    static validate = function(_symbols)
    {
        try
        {
        	check_error_empty(_symbols);
            check_error_lone_symbol(_symbols);
            check_error_parenthesis(_symbols);
            check_error_number_construction(_symbols);
        }
        catch (_exception)
        {
        	return _exception.message;
        }
        return "";
    }
    
    /// @func   is_valid();
    /// @desc Returns whether the expression is valid without any errors.
    static is_valid = function()
    {
        return error_message == "";
    }
    
    /// @func   check_error_empty(symbols);
    /// @param {Array<Constant.EQS>} symbols
    /// @desc Throws an error if there are no symbols.
    static check_error_empty = function(_symbols)
    {
        if (array_length(_symbols) == 0)
        {
            throw("Empty error: no symbols inputted!");
        }
    }
    
    /// @func   check_error_empty(symbols);
    /// @param {Array<Constant.EQS>} symbols
    /// @desc Throws an error if there is an invalid lone symbol.
    static check_error_lone_symbol = function(_symbols)
    {
        if (array_length(_symbols) == 1)
        {
            var _symbol = _symbols[0];
            if (_symbol == EQS.DECIMAL)
            {
                throw("Decimal error: lone symbol!");
            }
            if (symbol_is_operator(_symbol))
            {
                throw("Operator error: lone symbol!");
            }
            if (_symbol == EQS.OPEN_PARENTHESIS || _symbol == EQS.CLOSE_PARENTHESIS)
            {
                throw("Parenthesis error: lone symbol!");
            }
        }
    }
    
    /// @func   check_error_parenthesis(symbols);
    /// @param {Array<Constant.EQS>} symbols
    /// @desc Throws an error if there is something wrong with the parenthesis sum or value enclosure.
    static check_error_parenthesis = function(_symbols)
    {
        var _sum = 0, _empty = false, _contains_value = false;
        var _symbol_count = array_length(_symbols);
        for (var _i = 0; _i < _symbol_count; _i++)
        {
            var _symbol = _symbols[_i];
            if (_symbol == EQS.OPEN_PARENTHESIS)
            {
                _sum++;
                _empty = true;
            }
            else if (_symbol == EQS.CLOSE_PARENTHESIS)
            {
                if (_empty)
                {
                    throw("Parenthesis error: empty parentheses!");
                }
                _sum--;
            }
            else
            {
            	if (!_contains_value && (symbol_is_constant(_symbol) || symbol_is_variable(_symbol)))
                {
                    _contains_value = true;
                }
                _empty = false;
            }
            
            if (_sum < 0)
            {
                throw("Parenthesis error: incorrect order!");
            }
        }
        
        if (_sum != 0)
        {
            throw("Parenthesis error: missing a parenthesis!");
        }
        
        if (!_contains_value)
        {
            throw("Parenthesis error: parentheses enclose nothing of value!");
        }
    }
    
    /// @func   check_error_number_construction(symbols);
    /// @param {Array<Constant.EQS>} symbols
    /// @desc Throws an error if there is something wrong when trying to construct a number.
    static check_error_number_construction = function(_symbols)
    {
        var _number_added = false, _decimal_used = false;
        var _symbol_count = array_length(_symbols);
        for (var _i = 0; _i < _symbol_count; _i++)
        {
            var _symbol = _symbols[_i];
            var _is_digit = symbol_is_digit(_symbol);
            if (_is_digit || _symbol == EQS.DECIMAL)
            {
                if (!_is_digit)
                {
                    if (_decimal_used)
                    {
                        throw("Decimal error: multiple decimals in one number!");
                    }
                    _decimal_used = true;
                }
                else
                {
                	_number_added = true;
                }
            }
            else if (_decimal_used && !_number_added)
            {
                throw("Decimal error: lone decimal!");
            }
            else
            {
            	_number_added = false;
                _decimal_used = false;
            }
        }
    }
    
    #endregion
    
    #region Symbols
    
    /// @func   init_special_constants();
    /// @desc Initializes the special constants map of values.
    static init_special_constants = function()
    {
        special_constants_map[? EQS.E] = 2.72;
        special_constants_map[? EQS.PI] = pi;
    }
    
    /// @func   update_symbols(symbols);
    /// @param {Array<Constant.EQS>} symbols
    /// @desc Updates the expression's symbols. The input symbols should be validated beforehand.
    static update_symbols = function(_symbols)
    {
        symbols = [];
        var _symbols_copy = [];
        array_copy(_symbols_copy, 0, _symbols, 0, array_length(_symbols));
        add_implied_symbols(_symbols_copy);
        
        var _symbol_count = array_length(_symbols_copy);
        for (var _i = 0; _i < _symbol_count; _i++)
        {
            var _symbol = _symbols_copy[_i];
            if (symbol_is_constant(_symbol))
            {
                var _number_arr = [0];
                if (symbol_is_digit(_symbol) || _symbol == EQS.DECIMAL)
                {
                    var _number_str = construct_number_string(_symbols_copy, _i);
                    _number_arr[0] = real(_number_str);
                    _i += string_length(_number_str) - 1;
                }
                else
                {
                	_number_arr[0] = special_constants_map[? _symbol];
                }
                array_push(symbols, _number_arr);
            }
            else
            {
            	array_push(symbols, _symbol);
            }
        }
    }
    
    /// @func   add_implied_symbols(symbols);
    /// @param {Array<Constant.EQS>} symbols
    /// @desc Adds symbols that are implied and required to have the tree working correctly.
    static add_implied_symbols = function(_symbols)
    {
        for (var _i = 0; _i < array_length(_symbols); _i++)
        {
            var _symbol = _symbols[_i];
            
            // Trig/absolute value/round with single operand
            if ((symbol_is_trig(_symbol) || _symbol == EQS.ABSOLUTE_VALUE || _symbol == EQS.ROUND) &&
                implied_operator_number(_symbols, _i))
            {
                // Add implied 1 before operator
                array_insert(_symbols, _i+1, EQS.ONE);
                _i++;
            }
            // Log with single operand
            else if (_symbol == EQS.LOG && implied_operator_number(_symbols, _i))
            {
                // Add implied log base 10
                array_insert(_symbols, _i+1, EQS.ZERO);
                array_insert(_symbols, _i+1, EQS.ONE);
                _i += 2;
            }
            // Root with single operand
            else if (_symbol == EQS.ROOT && implied_operator_number(_symbols, _i))
            {
                // Add implied square root
                array_insert(_symbols, _i+1, EQS.TWO);
                _i++;
            }
            // Positive/negative number
            else if ((_symbol == EQS.PLUS || _symbol == EQS.MINUS) && implied_operator_number(_symbols, _i))
            {
                // Add implied zero
                array_insert(_symbols, _i+1, EQS.ZERO);
                _i++;
            }
            // Constant OR variable OR closing parenthesis with special constant OR opening parenthesis
            else if (_i < (array_length(_symbol) - 1) &&
                (symbol_is_constant(_symbol) || symbol_is_variable(_symbol) || _symbol == EQS.CLOSE_PARENTHESIS) &&
                (symbol_is_special_constant(_symbols[_i+1]) || symbol_is_variable(_symbols[_i+1]) || _symbols[_i+1] == EQS.OPEN_PARENTHESIS)))
            {
                // Add implied multiplication
                array_insert(_symbols, _i+1, EQS.MULTIPLY);
                _i++;
            }
        }
    }
    
    /// @func   implied_operator_number(symbols, idx);
    /// @param {Array<Constant.EQS>} symbols
    /// @param {Real} idx The index of the operator symbol
    /// @desc Returns if the operator has an implied number somewhere. Should be called if the operator is already known.
    static implied_operator_number = function(_symbols, _idx)
    {
        return _idx == 0 || symbol_is_operator(_symbols[_idx - 1]) || _symbols[_idx - 1] == EQS.OPEN_PARENTHESIS;
    }
    
    /// @func   construct_number_string(symbols, start_idx);
    /// @param {Array<Constant.EQS>} symbols
    /// @param {Real} start_idx The index to start at for number creation
    /// @desc Returns a string representation of the next number.
    static construct_number_string = function(_symbols, _start_idx)
    {
        var _number_str = "", _number_size = 0;
        var _symbol_count = array_length(_symbols);
        for (var _i = _start_idx; _i < _symbol_count; _i++)
        {
            var _symbol = _symbols[_i];
            if (symbol_is_digit(_symbol))
            {
                _number_str += string(_symbol);
            }
            else if (_symbol == EQS.DECIMAL)
            {
                _number_str += ".";
            }
            else
            {
            	break;
            }
        }
        return _number_str;
    }

    /// @func   update_postfix_symbols();
    /// @desc Converts the expression's symbols into its postfix form which can be used to build an expression tree.
    static update_postfix_symbols = function()
    {
        postfix_symbols = [];
    }
    
    /// @func   symbol_is_digit(symbol);
    /// @param {Constant.EQS} symbol
    /// @desc Returns if the symbol is a whole number.
    static symbol_is_digit = function(_symbol)
    {
        return _symbol < EQS.DECIMAL && _symbol >= EQS.ZERO;
    }
    
    /// @func   symbol_is_special_constant(symbol);
    /// @param {Constant.EQS} symbol
    /// @desc Returns if the symbol is a special constant.
    static symbol_is_special_constant = function(_symbol)
    {
        return !is_undefined(special_constants_map[? _symbol]);
    }
    
    /// @func   symbol_is_constant(symbol);
    /// @param {Constant.EQS} symbol
    /// @desc Returns if the symbol is a constant.
    static symbol_is_constant = function(_symbol)
    {
        return symbol_is_digit(_symbol) || symbol_is_special_constant(_symbol);
    }
    
    /// @func   symbol_is_variable(symbol);
    /// @param {Constant.EQS} symbol
    /// @desc Returns if the symbol is a constant.
    static symbol_is_variable = function(_symbol)
    {
        return _symbol <= EQS.X8 && _symbol >= EQS.X1;
    }
    
    /// @func   symbol_is_operator(symbol);
    /// @param {Constant.EQS} symbol
    /// @desc Returns if the symbol is an operator.
    static symbol_is_operator = function(_symbol)
    {
        return !is_undefined(precedence_map[? _symbol]) && _symbol != EQS.OPEN_PARENTHESIS;
    }
    
    /// @func   symbol_is_trig(symbol);
    /// @param {Constant.EQS} symbol
    /// @desc Returns if the symbol is a trigonometric operator.
    static symbol_is_trig = function(_symbol)
    {
        return _symbol == EQS.SINE || _symbol == EQS.COSINE || _symbol == EQS.TANGENT;
    }
    
    /// @func   symbol_is_parenthesis(symbol);
    /// @param {Constant.EQS} symbol
    /// @desc Returns if the symbol is a parenthesis.
    static symbol_is_parenthesis = function(_symbol)
    {
        return _symbol == EQS.OPEN_PARENTHESIS || _symbol == EQS.CLOSE_PARENTHESIS;
    }
    
    #endregion
    
    #region Tree
    
    /// @func   update_tree();
    /// @desc Generates the tree based on the current postfix symbols.
    static update_tree = function()
    {
        tree.clear();
    }
    
    #endregion
    
    #region Precedence
    
    /// @func   init_precedence();
    /// @desc Initializes the precedence map, dictating the order of operations for the operators.
    static init_precedence = function()
    {
        precedence_map[? EQS.OPEN_PARENTHESIS] = 1;
        precedence_map[? EQS.PLUS] = 2;
        precedence_map[? EQS.MINUS] = 2;
        precedence_map[? EQS.MULTIPLY] = 3;
        precedence_map[? EQS.DIVIDE] = 3;
        precedence_map[? EQS.SINE] = 3;
        precedence_map[? EQS.COSINE] = 3;
        precedence_map[? EQS.TANGENT] = 3;
        precedence_map[? EQS.MOD] = 3;
        precedence_map[? EQS.ABSOLUTE_VALUE] = 3;
        precedence_map[? EQS.ROUND] = 3;
        precedence_map[? EQS.POWER] = 4;
        precedence_map[? EQS.LOG] = 5;
        precedence_map[? EQS.ROOT] = 5;
    }
    
    #endregion
    
    #region Evaluation
    
    /// @func   evaluate(args);
    /// @param {Array} args
    /// @desc Returns either a number that is the evaluated expression OR a string if an error occurred.
    static evaluate = function(args)
    {
        var _value = 0;
        
        return _value;
    }
    
    #endregion
    
    if (!initialized)
    {
        init_precedence();
        init_special_constants();
        
        initialized = true;
    }
}