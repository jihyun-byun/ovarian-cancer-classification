% given a vector of marked nodes, return a vector that indicates which of
% the child marked nodes should be removed, since the best basis should
% only use the top-most "marked" nodes.

% ouput:

% - final_removed (vector, 0s or 1s): indicates whether, if the node is 
% marked, it should be included or removed from the best basis. same length 
% as number of nodes in the tree.

% input:

% - marked (vector, 0s or 1s): the output from get_marked_nodes() or
% mark_bb_nodes(); indicates whether each node was "marked" according to
% the best basis algorithm (i.e. that node has a lower cost than its child
% nodes)
% - levels (int): the number of levels of decomposition that are represented by
% wpd_coefs

function final_removed = rm_child_marked(marked, levels)
    
    % number of nodes in the tree, not including the root node (which
    % represents the signal)
    num_nodes = 2^(levels+1) - 2;

    % a num_nodes x 2 matrix, where each row represents one node, and
    % contains the indices of its child nodes.
    % the final level has no child nodes, so 
    children = [reshape(3:(num_nodes), 2, [])'; zeros(2^levels, 2)];

    % initialize the output vector
    final_removed = zeros(1, num_nodes);

    % go through all nodes except for the last level
    for node = 1:(2^levels - 2)
        % basically: if a node is marked, then remove all its child nodes
        % (but we don't need to do this if the node itself has already been
        % removed, hence the && part of the condition)
        if marked(node) && ~final_removed(node)
            final_removed = remove_nodes(children(node, 1), final_removed, children, levels);
            final_removed = remove_nodes(children(node, 2), final_removed, children, levels);
        end
    end

end

%% remove node function

% given a node, remove it and all of its children.

% output: 
% 
% - removed (vector): similar use/meaning to final_removed in above.

% input:

% - node (int): index of the node to remove
% - removed (vector): similar use/meaning to the output removed.
% - children (matrix): as described within the function rm_child_marked() above
% - levels (int): as described for the input to rm_child_marked() above


function removed = remove_nodes(node, removed, children, levels)    
    % the index of the first node of the last level
    last_lev_node = 2^levels - 1;

    % final recursion step
    % if the node is in the last level, then simply remove it.
    if node >= last_lev_node
        removed(node) = 1;
    % main recursion step
    % remove the current node, and then recursively remove the children of
    % the current node.
    else
        removed(node) = 1;
        removed = remove_nodes(children(node, 1), removed, children, levels);
        removed = remove_nodes(children(node, 2), removed, children, levels);
    end
end