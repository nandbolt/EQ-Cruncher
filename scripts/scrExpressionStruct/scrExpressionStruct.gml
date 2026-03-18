/// @func   Expression();
/// @desc A mathematical expression that can be evaluated into a number.
function Expression() constructor
{
    symbols = [];
    postfix_symbols = [];
    
    tree = new BinaryTree();
    
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
        return "";
    }
    
    /// @func   is_valid();
    /// @desc Returns whether the expression is valid without any errors.
    static is_valid = function()
    {
        return error_message == "";
    }
    
    #endregion
    
    #region Symbols
    
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
    
    #endregion
    
    #region Tree
    
    /// @func   update_tree();
    /// @desc Generates the tree based on the current postfix symbols.
    static update_tree = function()
    {
        tree.clear();
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
}