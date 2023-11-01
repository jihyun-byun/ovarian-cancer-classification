% Purpose: plot the wavelet spectra for all data regions for some randomly 
% selected observations

addpath(genpath("..\scripts"))

load("..\DATA\4302.mat")
load("..\DATA\8702.mat")

alldata = dictionary(["4302", "8702"], {data_4302, data_8702});

n_obs_Y = 4;
 
s = RandStream('mt19937ar','Seed',1);

%% generate a table of random observations from both datasets

table_indices = table();
rand_data_table = table();

for key = keys(alldata)'
    d_mat = cell2mat(alldata(key));
        for Y = [0, 1]
            idx = find(d_mat(:, end) == Y);
            rand_idx = idx(randperm(s, length(idx), n_obs_Y));
            rand_obs = d_mat(rand_idx, :);
            dataset_labels = repmat(key, [n_obs_Y, 1]);
            table_indices = [table_indices; table(dataset_labels, rand_idx, 'VariableNames', {'Label', 'Index'})];
            rand_data_table = [rand_data_table; array2table(rand_obs)];
        end
end

rand_table = [table_indices, rand_data_table];

%% Options 

% given a row and a region, calculate the wavelet spectra and plot it

wav_method = "WPD_Wang";
% wav_method = "DWT";

region_size = 1024;
step_size = 500;
levels = log2(region_size);

% for WavmatWP
shift = 2;
% Haar wavelet
filt=[sqrt(2)/2 sqrt(2)/2];

WP = WavmatWP(filt, region_size, levels, shift);
starts = 1:step_size:(size(rand_table(:, 3:(end-1)), 2) - region_size);
p_slopes = length(starts);

%% plot and save the wavelet spectra for all regions for all observations

for start_i = 1:p_slopes
    t = tiledlayout(height(rand_table)/4, 4);
    
    start = starts(start_i);
    % samp_i = 1;
    for samp_i = 1:height(rand_table)
        
        data = rand_table{samp_i, 3:(end-1)};
        data_region = data(1, start:(start+region_size-1));
        
        reg_coefs_wpd = WP*data_region';
        
        if wav_method == "WPD_Wang"
            reg_spectra_wpd = full_WPD_spectra(reg_coefs_wpd, region_size, levels);
        elseif wav_method == "DWT"
            reg_spectra_wpd = full_DWT_spectra(reg_coefs_wpd, region_size, levels);
        end
        
        nexttile;
        plot(reg_spectra_wpd, 'r-o', 'markeredgecolor', 'black', 'MarkerFaceColor', 'black', 'LineWidth', 1.5);
        title(sprintf('%s: idx=%u, y=%u', rand_table{samp_i, 1}, rand_table{samp_i, 2}, rand_table{samp_i, end}))
    
    end
    
    title(t, sprintf('Region %u (%s)', start_i, wav_method), interpreter = 'none')
    fig = gcf;
    fig.Position = [10, 10, 900, 1800];
    filename = "level_choice_plots\" + wav_method + "_reg_" + num2str(start_i) + ".png";
    exportgraphics(fig, filename, Resolution = 300);
end