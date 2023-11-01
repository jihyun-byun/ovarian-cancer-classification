% this is just a convenience function to take WPD coefficients and "mark"
% the nodes according to the best basis algorithm, using the existing
% get_cost_ents() and get_marked_nodes() functions

% output: (same as get_marked_nodes)

% - marked (vector, 1s or 0s): the output from get_marked_nodes; indicates
% which tree nodes are marked

% input: (same as get_cost_ents)

% - wpd_coefs (vector): a vector containing the WPD coefficients, as calculated
% using the signal vector and matrix from WavmatWP()
% - signal_size (vector): the length of the signal vector
% - levels (int): the number of levels of decomposition that are represented by
% wpd_coefs

function marked = mark_bb_nodes(wpd_coefs, signal_size, levels)
    bb_ents = get_cost_ents(wpd_coefs, signal_size, levels);
    marked = get_marked_nodes(bb_ents, levels);
end