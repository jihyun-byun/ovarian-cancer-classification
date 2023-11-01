function node_coefs = get_WavmatWP_coefs (wp_coefs, sig_len, level, nodes)
% inputs: 
% - wp_coefs, vector containing all the coefficients from the wavelet packet
% decomposition
% - sig_len, length of the original signal
% - level, the level of the desired node, starting from 1
% - nodes, the indices of the desired nodes within the level, where the
% index of the first node is 0
% NOTE: nodes are numbered in natural ordering, not sequency ordering

% output:
% node_coefs, a cell array containing the coefficients from each selected node

    assert(length(nodes) <= 2^level, ...
        "Requested %u nodes, but the number of nodes in level %u is %u.", length(nodes), level, 2^level)
    assert(max(nodes) <= 2^level - 1, ...
        "Requesting max node %u, but the max node index in level %u is %u.", max(nodes), level, 2^level - 1)

    lev_start = (sig_len*(level-1) + 1);
    node_len = sig_len/(2^(level));
    
    node_coefs = cell(1, length(nodes));
    for i = 1:length(nodes)
        node = nodes(i);
        
        node_start = lev_start + node*node_len;
        node_end = node_start + (node_len-1);
    
        node_coefs{i} = wp_coefs(node_start:node_end);
    end
end