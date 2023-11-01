% Purpose: calculate slopes using specifically chosen levels

% these are the spectra levels chosen by examining results from
% confirm_slopes_by_regions.m
DWT_levels = containers.Map;
WPD_Wang_levels = containers.Map;

% Define the levels you want to use for each data region.
% for example, the vector in the comment below chooses levels 7-10 for the
% first 11 data regions, then levels 6-9 for the remaining data regions.
% DWT_levels("4302") = [num2cell(repmat(7:10, [11, 1]), 2); 
%     num2cell(repmat(6:9, [18, 1]), 2)];

DWT_levels("4302") = [num2cell(repmat(7:10, [11, 1]), 2); 
    num2cell(repmat(6:9, [18, 1]), 2)];
DWT_levels("8702") = [num2cell(repmat(8:10, [11, 1]), 2); 
    num2cell(repmat(7:10, [18, 1]), 2)];

WPD_Wang_levels("4302") = [num2cell(repmat(7:10, [10, 1]), 2); 
    num2cell(repmat(6:9, [19, 1]), 2)];
WPD_Wang_levels("8702") = [num2cell(repmat(8:10, [15, 1]), 2); 
    num2cell(repmat(6:10, [14, 1]), 2)];

level_choices = containers.Map;
level_choices("DWT") = DWT_levels;
level_choices("WPD_Wang") = WPD_Wang_levels;

%% Options and load data

load("..\DATA\4302.mat");
load("..\DATA\8702.mat");

% raw_data = data_4302;
% dataname = '4302';
raw_data = data_8702;
dataname = '8702';

% wav_method = "DWT";
wav_method = "WPD_Wang";

int_feats = raw_data (:, 1:(end-1));
y_feat = raw_data (:, end);

region_size = 1024;
step_size = 500;
levels = log2(region_size);

% for WavmatWP
shift = 2;
% Haar wavelet
filt=[sqrt(2)/2 sqrt(2)/2];

WP = WavmatWP(filt, region_size, levels, shift);
starts = 1:step_size:(size(int_feats, 2) - region_size);
p_slopes = length(starts);
newvarname = char(strjoin([wav_method, '_chosenlevels_', dataname, '_', region_size, '_', step_size, '_slopes'], ''));
savename = string(['..\DATA\', newvarname, '.mat']);

%% Generate features for chosen dataset

method_levels = level_choices(wav_method);
dataset_levels = method_levels(dataname);

X_wpd = zeros(size(int_feats, 1), p_slopes);

for samp_i = 1:size(X_wpd, 1)
    disp(samp_i);
    for start_i = 1:p_slopes

        xs_slope = dataset_levels{start_i};
%         disp(xs_slope);

        start = starts(start_i);
        data_region = int_feats(samp_i, start:(start+region_size-1));
        
        reg_coefs_wpd = WP*data_region';

        if wav_method == "WPD_Wang"
            reg_spectra_wpd = full_WPD_spectra(reg_coefs_wpd, region_size, levels);
        elseif wav_method == "DWT"
            reg_spectra_wpd = full_DWT_spectra(reg_coefs_wpd, region_size, levels);
        end
        
        linfit_wpd = polyfit(xs_slope, reg_spectra_wpd(xs_slope), 1);

        X_wpd(samp_i, start_i) = linfit_wpd(1);

    end
end

%% save slope_cands
Xy = [X_wpd, y_feat];
assignin('base', newvarname, Xy);
save(savename, newvarname);

%% All the remaining block are optional, load slope_cands_*

% change to choose which slope set to load
% loadname = [newvarname(1:(end-4)), '8702'];
loadname = newvarname

load(['..\DATA\', loadname])
assignin('base', 'slope_cands', evalin('base', loadname));

%% plot summaries of features and linear fits

X_wpd_all = reshape(slope_cands(:, 1:(end-1)), [], 1);

quantile(X_wpd_all, [0, 0.025, .25, .5, .75, 0.975, 1])

t = tiledlayout(1, 2);

nexttile
histogram(X_wpd_all);
nexttile
boxchart(X_wpd_all);
title(t, sprintf("%s, %s", wav_method, dataname), Interpreter = 'none')

%%
boxchart(slope_cands(:, 1:(end-1)));
title(sprintf("%s, %s", wav_method, dataname), Interpreter = 'none')
fig = gcf;
fig.Position = [10, 10, 1800, 900];
exportgraphics(fig, "level_choice_boxsum\" + newvarname + "chosen_box.png", Resolution = 300)

%% plot histogram of all slopes

quantiles = 0:0.25:1;

t_slopes = tiledlayout(1,1);

slope_table = table();
level_names = repmat("", [1, 1]);

for slopes_i = 1:1

    all_slopes = reshape(slope_cands{slopes_i}{2}, [], 1);
    slope_title = [num2str(slope_cands{slopes_i}{1}(1)), ':', num2str(slope_cands{slopes_i}{1}(end))];

    nexttile
    histogram(all_slopes);
    title(slope_title);
    nexttile
    boxchart(all_slopes);
    title(slope_title);

    slope_table = [slope_table; array2table(quantile(all_slopes, quantiles))];
    level_names(slopes_i) = slope_title;
end
title(t_slopes, ['Slopes for ', loadname], interpreter = 'none')

slope_table.levels = level_names;
slope_table.Properties.VariableNames = [string(quantiles), "levels"];

disp(slope_table);

%% plot histogram of all R2

t_R2 = tiledlayout(ceil(n_cands/2), 4);

R2_table = table();
level_names = repmat("", [n_cands, 1]);

for slopes_i = 1:n_cands

    all_R2 = reshape(slope_cands{slopes_i}{3}, [], 1);
    slope_title = [num2str(slope_cands{slopes_i}{1}(1)), ':', num2str(slope_cands{slopes_i}{1}(end))];

    nexttile
    histogram(all_R2);
    title(slope_title);
    nexttile
    boxchart(all_R2);
    title(slope_title);
    ylim([0, 1]);

    R2_table = [R2_table; array2table(quantile(all_R2, quantiles))];
    level_names(slopes_i) = slope_title;
end
title(t_R2, ['R^2 for ', loadname], interpreter = 'none')

R2_table.levels = level_names;
R2_table.Properties.VariableNames = [string(quantiles), "levels"];

disp(R2_table);

%% combine summaries

slope_table.dataset = repmat("8702", n_cands, 1);
slope_table.method = repmat("WPD_Wang", n_cands, 1);
slope_table.metric = repmat("slope", n_cands, 1);

R2_table.dataset = repmat("8702", n_cands, 1);
R2_table.method = repmat("WPD_Wang", n_cands, 1);
R2_table.metric = repmat("R2", n_cands, 1);

disp([slope_table; R2_table])

%% 

writetable([slope_table; R2_table], [loadname, '_sum.csv']);