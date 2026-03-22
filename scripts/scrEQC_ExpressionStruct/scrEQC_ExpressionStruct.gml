/*
 * EQ Cruncher (v1.0.1) - An equation evaluator for GameMaker.
 * 
 * created by nandbolt
 * 
 * The code falls under the MIT Licence, meaning you're welcome
 * to use it in your own commercial projects to your heart's content!
*/

/// @func   Expression();
/// @desc A mathematical expression that can "hopefully" evaluate into a number.
function Expression() constructor
{
    static initialized = false;
    
    symbols = [];
    postfix_symbols = [];
    static precedence_map = ds_map_create();
    static special_constants_map = ds_map_create();
    static symbol_string_map = ds_map_create();
    static operation_func_map = ds_map_create();
    
    tree = undefined;
    
    error_message = "";
    
    #region Setters
    
    /// @func   set(symbols);
    /// @param {Array<Constant.EQS>} symbols
    /// @desc Sets the equation using the given symbols.
    static set = function(_symbols)
    {
        error_message = validate(_symbols);
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
        destroy_tree();
    }
    
    #endregion
    
    #region General
    
    /// @func   clear();
    /// @desc Clears the expression so that it can be reused.
    static clear = function()
    {
        symbols = [];
        destroy_tree();
        error_message = "";
    }
    
    /// @func   symbols_get_string(symbols);
    /// @param {Array<Constant.EQS>} symbols
    /// @desc Returns the string representation of the given symbols.
    static symbols_get_string = function(_symbols)
    {
        var _str = "", _symbol_count = array_length(_symbols);
        for (var _i = 0; _i < _symbol_count; _i++)
        {
            var _symbol = _symbols[_i];
            if (is_array(_symbol))
            {
                _str += string(_symbol[0]);
            }
            else
            {
            	_str += symbol_string_map[? _symbol];
            }
        }
        return _str;
    }
    
    /// @func   toString();
    /// @desc Returns a string representation of the expression.
    static toString = function()
    {
        return symbols_get_string(symbols);
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
        	return _exception;
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
    
    /// @func   init_symbol_strings();
    /// @desc Initializes the symbol string map.
    static init_symbol_strings = function()
    {
        symbol_string_map[? EQS.ZERO] = "0";
        symbol_string_map[? EQS.ONE] = "1";
        symbol_string_map[? EQS.TWO] = "2";
        symbol_string_map[? EQS.THREE] = "3";
        symbol_string_map[? EQS.FOUR] = "4";
        symbol_string_map[? EQS.FIVE] = "5";
        symbol_string_map[? EQS.SIX] = "6";
        symbol_string_map[? EQS.SEVEN] = "7";
        symbol_string_map[? EQS.EIGHT] = "8";
        symbol_string_map[? EQS.NINE] = "9";
        symbol_string_map[? EQS.DECIMAL] = ".";
        symbol_string_map[? EQS.OPEN_PARENTHESIS] = "(";
        symbol_string_map[? EQS.CLOSE_PARENTHESIS] = ")";
        symbol_string_map[? EQS.PLUS] = "+";
        symbol_string_map[? EQS.MINUS] = "-";
        symbol_string_map[? EQS.MULTIPLY] = "*";
        symbol_string_map[? EQS.DIVIDE] = "/";
        symbol_string_map[? EQS.POWER] = "^";
        symbol_string_map[? EQS.ROOT] = "root";
        symbol_string_map[? EQS.LOG] = "log";
        symbol_string_map[? EQS.SINE] = "sin";
        symbol_string_map[? EQS.COSINE] = "cos";
        symbol_string_map[? EQS.TANGENT] = "tan";
        symbol_string_map[? EQS.X1] = "x1";
        symbol_string_map[? EQS.X2] = "x2";
        symbol_string_map[? EQS.X3] = "x3";
        symbol_string_map[? EQS.X4] = "x4";
        symbol_string_map[? EQS.X5] = "x5";
        symbol_string_map[? EQS.X6] = "x6";
        symbol_string_map[? EQS.X7] = "x7";
        symbol_string_map[? EQS.X8] = "x8";
        symbol_string_map[? EQS.PI] = "pi";
        symbol_string_map[? EQS.E] = "e";
        symbol_string_map[? EQS.MOD] = "mod";
        symbol_string_map[? EQS.ABSOLUTE_VALUE] = "abs";
        symbol_string_map[? EQS.ROUND] = "round";
    }
    
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
                array_insert(_symbols, _i, EQS.ONE);
                _i++;
            }
            // Log with single operand
            else if (_symbol == EQS.LOG && implied_operator_number(_symbols, _i))
            {
                // Add implied log base 10
                array_insert(_symbols, _i, EQS.ZERO);
                array_insert(_symbols, _i, EQS.ONE);
                _i += 2;
            }
            // Root with single operand
            else if (_symbol == EQS.ROOT && implied_operator_number(_symbols, _i))
            {
                // Add implied square root
                array_insert(_symbols, _i, EQS.TWO);
                _i++;
            }
            // Positive/negative number
            else if ((_symbol == EQS.PLUS || _symbol == EQS.MINUS) && implied_operator_number(_symbols, _i))
            {
                // Add implied zero
                array_insert(_symbols, _i, EQS.ZERO);
                _i++;
            }
            // Constant OR variable OR closing parenthesis with special constant OR opening parenthesis
            else if (_i < (array_length(_symbols) - 1) &&
                (symbol_is_constant(_symbol) || symbol_is_variable(_symbol) || _symbol == EQS.CLOSE_PARENTHESIS) &&
                (symbol_is_special_constant(_symbols[_i+1]) || symbol_is_variable(_symbols[_i+1]) || _symbols[_i+1] == EQS.OPEN_PARENTHESIS))
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
        
        // Scan infix equation
        var _operator_stack = [], _symbol_count = array_length(symbols);
        for (var _i = 0; _i < _symbol_count; _i++)
        {
            var _symbol = symbols[_i];
            if (is_array(_symbol) || (!symbol_is_operator(_symbol) && !symbol_is_parenthesis(_symbol)))
            {
                array_push(postfix_symbols, _symbol);
            }
            else if (_symbol == EQS.OPEN_PARENTHESIS)
            {
                array_push(_operator_stack, _symbol);
            }
            else if (_symbol == EQS.CLOSE_PARENTHESIS)
            {
                // Pop stack until openning parenthesis is removed, appending
                // each operator to the end of the symbols.
                var _top_symbol = array_pop(_operator_stack);
                while (_top_symbol != EQS.OPEN_PARENTHESIS)
                {
                    array_push(postfix_symbols, _top_symbol);
                    _top_symbol = array_pop(_operator_stack);
                }
            }
            else
            {
            	// Remove any operators in the stack that have higher or equal precedence
                // and append them to the symbols, then push the symbol to the stack.
                while (array_length(_operator_stack) > 0 &&
                    precedence_map[? _operator_stack[array_length(_operator_stack)-1]] >= precedence_map[? _symbol])
                {
                    array_push(postfix_symbols, array_pop(_operator_stack));
                }
                array_push(_operator_stack, _symbol);
            }
        }
        
        // Add remaining stack operators
        while (array_length(_operator_stack) > 0)
        {
            array_push(postfix_symbols, array_pop(_operator_stack));
        }
        
        _operator_stack = -1;
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
    
    /// @func   destroy_tree();
    /// @desc Destroys the tree.
    static destroy_tree = function()
    {
        if (is_instanceof(tree, BinaryTree))
        {
            tree.cleanup();
            delete tree;
        }
    }
    
    /// @func   update_tree();
    /// @desc Generates the tree based on the current postfix symbols.
    static update_tree = function()
    {
        destroy_tree();
        
        var _tree_stack = [], _postfix_symbol_count = array_length(postfix_symbols);
        for (var _i = 0; _i < _postfix_symbol_count; _i++)
        {
            var _symbol = postfix_symbols[_i];
            if (!symbol_is_operator(_symbol))
            {
                array_push(_tree_stack, new BinaryTree(_symbol));
            }
            else
            {
            	var _right = array_pop(_tree_stack);
                var _left = array_pop(_tree_stack);
                array_push(_tree_stack, new BinaryTree(_symbol, _left, _right));
            }
        }
        
        tree = array_pop(_tree_stack);
        
        _tree_stack = -1;
    }
    
    /// @func   evaluate_tree(tree, vars);
    /// @param {Struct.BinaryTree} tree The expression tree
    /// @param {Array<Real>} vars
    /// @desc Evaluates the operations within the tree and returns a real number OR throws an error.
    static evaluate_tree = function(_tree, _vars)
    {
        if (is_undefined(_tree))
        {
            return 0;
        }
        
        var _symbol = _tree.data;
        
        // Constant
        if (is_array(_symbol))
        {
            return _tree.data[0];
        }
        
        // Variable
        if (symbol_is_variable(_symbol))
        {
            var _idx = _symbol - EQS.X1;
            if (_idx >= array_length(_vars))
            {
                throw("Evaluation error: variable not found in input!");
            }
            return _vars[_idx];
        }
        
        var _left_value = evaluate_tree(_tree.left_child, _vars);
        var _right_value = evaluate_tree(_tree.right_child, _vars);
        return evaluate_operation(_symbol, _left_value, _right_value);
    }
    
    #endregion
    
    #region Evaluation
    
    /// @func   evaluate(vars);
    /// @param {Array<Real>} vars   The set of independent variables corresponding to [x1, x2, ..., x8]
    /// @desc Returns the evaluated expression based on the independent variables as a real number OR
    /// a string if an error occurred.
    static evaluate = function(_vars=[])
    {
        var _value = 0;
        
        try
        {
            if (is_valid())
            {
                _value = evaluate_tree(tree, _vars);
            }
            else
            {
            	throw("Evaluation error: invalid expression!");
            }
        }
        catch (_exception)
        {
            if (is_struct(_exception))
            {
                if (variable_struct_exists(_exception, "message"))
                {
                    _value = _exception.message;
                }
                else
                {
                	_value = "Evaluation error: unknown!";
                }
            }
            else
            {
            	_value = _exception;
            }
        }
        
        return _value;
    }
    
    #endregion
    
    #region Operators
    
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
    
    /// @func   init_operation_functions();
    /// @desc Initializes the symbol string map.
    static init_operator_functions = function()
    {
        operation_func_map[? EQS.PLUS] = evaluate_operation_addition;
        operation_func_map[? EQS.MINUS] = evaluate_operation_subtraction;
        operation_func_map[? EQS.MULTIPLY] = evaluate_operation_multiplication;
        operation_func_map[? EQS.DIVIDE] = evaluate_operation_division;
        operation_func_map[? EQS.POWER] = evaluate_operation_power;
        operation_func_map[? EQS.ROOT] = evaluate_operation_root;
        operation_func_map[? EQS.LOG] = evaluate_operation_log;
        operation_func_map[? EQS.SINE] = evaluate_operation_sine;
        operation_func_map[? EQS.COSINE] = evaluate_operation_cosine;
        operation_func_map[? EQS.TANGENT] = evaluate_operation_tangent;
        operation_func_map[? EQS.MOD] = evaluate_operation_mod;
        operation_func_map[? EQS.ABSOLUTE_VALUE] = evaluate_operation_absolute_value;
        operation_func_map[? EQS.ROUND] = evaluate_operation_round;
    }
    
    /// @func   evaluate_tree_operation(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single math operation, returning the output.
    static evaluate_operation = function(_symbol, _left_value, _right_value)
    {
        var _value = 0;
        var _operator_func = operation_func_map[? _symbol];
        if (is_callable(_operator_func))
        {
            _value = _operator_func(_symbol, _left_value, _right_value);
        }
        return _value;
    }
    
    /// @func   evaluate_operation_addition(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single addition operation, returning the output.
    static evaluate_operation_addition = function(_symbol, _left_value, _right_value)
    {
        return _left_value + _right_value;
    }
    
    /// @func   evaluate_operation_subtraction(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single subtraction operation, returning the output.
    static evaluate_operation_subtraction = function(_symbol, _left_value, _right_value)
    {
        return _left_value - _right_value;
    }
    
    /// @func   evaluate_operation_multiplication(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single multiplication operation, returning the output.
    static evaluate_operation_multiplication = function(_symbol, _left_value, _right_value)
    {
        return _left_value * _right_value;
    }
    
    /// @func   evaluate_operation_division(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single division operation, returning the output.
    static evaluate_operation_division = function(_symbol, _left_value, _right_value)
    {
        var _quotient = _left_value / _right_value;
        if (is_infinity(_quotient))
        {
            throw("Evaluation error: division by zero!");
        }
        else if (is_nan(_quotient))
        {
            throw("Evaluation error: undefined division!");
        }
        return _quotient;
    }
    
    /// @func   evaluate_operation_power(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single exponential operation, returning the output.
    static evaluate_operation_power = function(_symbol, _left_value, _right_value)
    {
        var _power = power(_left_value, _right_value);
        if (is_nan(_power))
        {
            throw("Evaluation error: negative base + fractional exponent!");
        }
        return _power;
    }
    
    /// @func   evaluate_operation_sine(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single sine operation, returning the output.
    static evaluate_operation_sine = function(_symbol, _left_value, _right_value)
    {
        return _left_value * sin(_right_value);
    }
    
    /// @func   evaluate_operation_cosine(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single cosine operation, returning the output.
    static evaluate_operation_cosine = function(_symbol, _left_value, _right_value)
    {
        return _left_value * cos(_right_value);
    }
    
    /// @func   evaluate_operation_tangent(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single tangent operation, returning the output.
    static evaluate_operation_tangent = function(_symbol, _left_value, _right_value)
    {
        var _tan = _left_value * tan(_right_value);
        if (is_infinity(_tan))
        {
            throw("Evaluation error: infinite tangent!");
        }
        return _tan;
    }
    
    /// @func   evaluate_operation_log(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single logarithmic operation, returning the output.
    static evaluate_operation_log = function(_symbol, _left_value, _right_value)
    {
        var _log = logn(_left_value, _right_value);
        if (is_nan(_log))
        {
            throw("Evaluation error: negative log!");
        }
        return _log;
    }
    
    /// @func   evaluate_operation_root(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single root operation, returning the output.
    static evaluate_operation_root = function(_symbol, _left_value, _right_value)
    {
        var _root = logn(_left_value, _right_value);
        if (is_nan(_root))
        {
            throw("Evaluation error: negative root!");
        }
        return _root;
    }
    
    /// @func   evaluate_operation_mod(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single modulo operation, returning the output.
    static evaluate_operation_mod = function(_symbol, _left_value, _right_value)
    {
        var _mod = _left_value % _right_value;
        if (is_infinity(_mod))
        {
            throw("Evaluation error: mod zero!");
        }
        else if (is_nan(_mod))
        {
            throw("Evaluation error: mod not working!");
        }
        return _mod;
    }
    
    /// @func   evaluate_operation_absolute_value(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single absolute value operation, returning the output.
    static evaluate_operation_absolute_value = function(_symbol, _left_value, _right_value)
    {
        return _left_value * abs(_right_value);
    }
    
    /// @func   evaluate_operation_round(symbol, left_value, right_value);
    /// @param {Constant.EQS} symbol
    /// @param {Real} left_value
    /// @param {Real} right_value
    /// @desc Evaluates a single rounding operation, returning the output.
    static evaluate_operation_round = function(_symbol, _left_value, _right_value)
    {
        return _left_value * round(_right_value);
    }
    
    #endregion
    
    if (!initialized)
    {
        init_symbol_strings();
        init_precedence();
        init_special_constants();
        init_operator_functions();
        
        initialized = true;
    }
}