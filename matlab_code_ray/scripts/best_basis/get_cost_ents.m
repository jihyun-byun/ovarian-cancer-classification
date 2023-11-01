% get_cost_ents()

% output:
% 
% - bb_ents (vector): the information cost for each node of the input wavelet packet
% decomposition (WPD) tree, as a vector with one element for each node of the
% tree. In this case, the cost is the non-normalized Shannon entropy.

% input:
%
% - wpd_coefs (vector): a vector containing the WPD coefficients, as calculated
% using the signal vector and matrix from WavmatWP()
% - signal_size (vector): the length of the signal vector
% - levels (int): the number of levels of decomposition that are represented by
% wpd_coefs

function bb_ents = get_cost_ents(wpd_coefs, signal_size, levels)
    % an empty vector that will hold the costs for output
    bb_ents = [];

    % calculate the costs one level at a time
    for lev = 1:levels
        % get coefficients for all of the nodes at this level, as a cell
        % array
        lev_coefs = get_WavmatWP_coefs(wpd_coefs, signal_size, lev, 0:(2^(lev)-1));
        % for each node, square the coefficients; the result is another
        % cell array with one element for each node
        lev_energies = cellfun(@(x) x.^2, lev_coefs, UniformOutput=false);
        
        % NOTE that we do not normalize the energies, as per Wickerhauser
        % Ch 8 p. 276; this way, it is a valid information cost functional.
        
        % calculate the "Shannon entropy" with the energies. This returns a
        % vector of scalars, with one value for each node in the level.
        % -sum(p_ijk .* log(p_ijk))
        lev_ents = cellfun( @(x) -sum(x .* log(x)), lev_energies );
        % append the newest entropies at the end of the existing list of
        % entropies
        bb_ents = [bb_ents, lev_ents];
    end
end