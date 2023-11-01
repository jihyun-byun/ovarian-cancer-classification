%% calculate H_korcak

function [H_korcak, Xs, sorted, K_fit] = H_k(bb_coefs_mat)

    [sorted, s_ind] = sort(abs(bb_coefs_mat), 'descend');
    Xs = 1:length(sorted);
    K_fit = polyfit(log(Xs), log(sorted), 1);
    slope = K_fit(1);
    H_korcak = abs(slope + 1);

end