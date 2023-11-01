% output:

% - bb_coefs_mat (matrix) - the coefficients of the selected best basis
% nodes in a single row vector, which is the length of the original signal
% - num_bb_nodes (int) - the number of best basis nodes that were selected
% - bb_coefs (cell array) - the best basis coefficients, as their
% individual nodes in a cell array
% - bb_nodes (vector) - the indices of the chosen best basis nodes


% input:

% - wpd_coefs (vector): a vector containing the WPD coefficients, as calculated
% using the signal vector and matrix from WavmatWP()
% - marked (vector, 0s or 1s): the output from get_marked_nodes() or
% mark_bb_nodes()
% - removed (vector): the output from rm_child_marked()
% - signal_size (int): length of the original signal

function [bb_coefs_mat, num_bb_nodes, bb_coefs, bb_nodes] = get_bb_coefs (wpd_coefs, marked, removed, signal_size)

    % the best basis nodes are those which are marked but not removed
    bb_nodes = find(marked == 1 & removed == 0);
    % given the index of a node, return its tree level. 
    % e.g. [1, 2, 3, 4, 5, 6] --> [1, 1, 2, 2, 2, 2]
    bb_levels = ceil(log2(bb_nodes+2)) - 1;
    
    % initialize an empty cell array that will hold the coefficients from
    % the best basis nodes
    bb_coefs = cell(length(bb_levels), 1);
    
    % given a node's index, return its index within its level (i.e. where
    % each level starts at 0).
    bb_lev_nodes = bb_nodes - (2.^bb_levels - 1);
    
    % the unique levels (because we will grab the coefficients
    % level-by-level).
    uniq_levels = unique(bb_levels);
    
    for lev = uniq_levels
        % get the level-wise indices of the nodes in the current level
        this_lev_nodes = bb_lev_nodes(bb_levels == lev); 
        
        % given a level and a list of specific nodes in that level, return 
        % the coefficients for all of those nodes.
        bb_coefs(bb_levels == lev) = get_WavmatWP_coefs(wpd_coefs, signal_size, lev, this_lev_nodes);
    end
    
    % convert the cell array of coefficients to a matrix (in fact, a row
    % vector)
    bb_coefs_mat = cell2mat(bb_coefs);
    num_bb_nodes = length(bb_coefs);

end