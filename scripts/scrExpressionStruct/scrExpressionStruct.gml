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
        tree.cleanup();
        delete tree;
        
        ds_map_destroy(precedence_map);
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