%% function for conveniently getting best basis coefficients

function bb_coefs_mat = WPD_Jones(wpd_coefs, signal_size, levels)
    marked = mark_bb_nodes(wpd_coefs, signal_size, levels);
    removed = rm_child_marked(marked, levels);
    bb_coefs_mat = get_bb_coefs(wpd_coefs, marked, removed, signal_size);
end