/// @func   BinaryTree(data, left_child, right_child);
/// @param {Any} data The data this tree's node holds
/// @param {Struct.BinaryTree} left_child
/// @param {Struct.BinaryTree} right_child
/// @desc A binary tree data structure, where every tree is also a node.
function BinaryTree(_data=undefined, _left_child=undefined, _right_child=undefined) constructor
{
    data = _data;
    left_child = _left_child;
    right_child = _right_child;
    
    #region Events
    
    /// @func   cleanup();
    /// @desc Cleans up any memory before getting deleted.
    static cleanup = function()
    {
        destroy(self);
    }
    
    #endregion
    
    #region Properties
    
    /// @func   toString();
    /// @desc Returns the string representation of the tree.
    static toString = function()
    {
        var _data_str = string(data), _left_str = "undefined", _right_str = "undefined";
        if (is_instanceof(left_child, BinaryTree))
        {
            _left_str = string(left_child);
        }
        if (is_instanceof(right_child, BinaryTree))
        {
            _right_str = string(right_child);
        }
        return $"[{_data_str} (<{_left_str})(>{_right_str})]";
    }
    
    #endregion
    
    #region Applied Operations
    
    /// @func   destroy(tree);
    /// @param {Struct.BinaryTree} tree
    /// @desc Destroys the tree and its children.
    static destroy = function(_tree)
    {
        if (is_instanceof(_tree, BinaryTree))
        {
            destroy(_tree.left_child);
            delete _tree.left_child;
            
            destroy(_tree.right_child);
            delete _tree.right_child;
            
            if (is_struct(data) && variable_struct_exists(data, "cleanup"))
            {
                data.cleanup();
                delete data;
            }
        }
    }
    
    /// @func   clear();
    /// @desc Clears the tree's children and data so that it can be reused.
    static clear = function()
    {
        destroy(self);
    }
    
    #endregion
}