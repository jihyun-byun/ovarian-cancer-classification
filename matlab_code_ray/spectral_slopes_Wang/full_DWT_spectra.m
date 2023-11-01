function dwt_spectra = full_DWT_spectra (wpd_coefs, sig_len, levels)

    dwt_spectra = [];
    
    for lev = 1:levels
        % only need to get one node of coefficients, the first detail region,
        % which is index 1 in each level
        node_coefs = get_WavmatWP_coefs(wpd_coefs, sig_len, lev, 1);
        % spectra value is the base 2-log of the mean of squared coefficients
        dwt_spectra = [log2(mean(node_coefs{1}.^2)) dwt_spectra];
    end

end