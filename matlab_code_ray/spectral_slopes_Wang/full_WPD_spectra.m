function wpd_spectra = full_WPD_spectra (wpd_coefs, sig_len, levels)

    wpd_spectra = [];
    
    for lev = 1:levels
    %     node_power = [];
        % node index starts at 0.
        % start at first detail node, 1, and then go to every other node, i.e.
        % all detail nodes. See Wang et al. 2006.
        
        det_nodes = 1:2:(2^lev - 1);
        node_coefs = get_WavmatWP_coefs(wpd_coefs, sig_len, lev, det_nodes);
        node_power = cellfun(@(x) mean(x.^2), node_coefs);
        
        % spectra value is the base 2-log of the mean of node powers in the
        % level
        wpd_spectra = [log2(mean(node_power)) wpd_spectra];
    end

end