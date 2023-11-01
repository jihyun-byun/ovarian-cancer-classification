clear
clc

%% Options and load data

addpath(genpath("..\scripts"))

load("..\DATA\4302.mat");
load("..\DATA\8702.mat");

% dataname = '4302';
dataname = '8702';
% assign the proper loaded data to variable called raw_data
assignin('base', 'raw_data', evalin('base', ['data_' dataname]));

int_feats = raw_data (:, 1:(end-1));
y_feat = raw_data (:, end);

region_size = 1024;
step_size = 500;
levels = log2(region_size) - 1;

% for WavmatWP
shift = 2;
% Haar
% filt = [sqrt(2)/2 sqrt(2)/2];
% SYMM4 - 
filt = [-0.075765714789502, -0.029635527646003, 0.497618667632775, ...
    0.803738751805133, 0.297857795605306, -0.099219543576634, ...
    -0.012603967262031, 0.032223100604052];

WP = WavmatWP(filt, region_size, levels, shift);
starts = 1:step_size:(size(int_feats, 2) - region_size);
p_slopes = length(starts);

%% Generate features
X_wpd = zeros(size(int_feats, 1), p_slopes);

for samp_i = 1:size(X_wpd, 1)
    % print iteration number for tracking
    if mod(samp_i, 5) == 0
        disp(samp_i);
    end
    
    for start_i = 1:p_slopes

        start = starts(start_i);
        data_region = int_feats(samp_i, start:(start+region_size-1));
        
        reg_coefs_wpd = WP*data_region';

        % WavmatWP method
        bb_coefs_mat = WPD_Jones(reg_coefs_wpd, region_size, levels);
        [H_korcak, Xs, sorted, K_fit] = H_k(bb_coefs_mat);

        X_wpd(samp_i, start_i) = K_fit(1);

    end
end

%% checks

max(X_wpd, [], 1)
min(X_wpd, [], 1)

Xy = [X_wpd, y_feat];

filename = "Jones_" + dataname + "_" + wavelet + "_" + region_size + "_" + step_size + "_slopes.csv"
%%
writematrix(Xy, "../DATA/" + filename);

%% Optional - plot features from different wavelets to compare distribution

% read the calculated slopes from CSV files
% extract only the slopes (remove the final column with Y values)
% convert slopes to H

haar_4302_slopes = readmatrix("Jones_4302_haar_" + region_size + "_" + step_size + "_slopes.csv");
haar_8702_slopes = readmatrix("Jones_8702_haar_" + region_size + "_" + step_size + "_slopes.csv");
SYM8_4302_slopes = readmatrix("Jones_4302_sym4_" + region_size + "_" + step_size + "_slopes.csv");
SYM8_8702_slopes = readmatrix("Jones_8702_sym4_" + region_size + "_" + step_size + "_slopes.csv");

haar_4302_H = abs(haar_4302_slopes(:, 1:p_slopes) + 1);
haar_8702_H = abs(haar_8702_slopes(:, 1:p_slopes) + 1);
SYM8_4302_H = abs(SYM8_4302_slopes(:, 1:p_slopes) + 1);
SYM8_8702_H = abs(SYM8_8702_slopes(:, 1:p_slopes) + 1);

y_feat_4302 = haar_4302_slopes(:, p_slopes+1);
y_feat_8702 = haar_8702_slopes(:, p_slopes+1);
%% reshape into a "tidy" format

rows_4302 = size(haar_4302_slopes, 1);
rows_8702 = size(haar_8702_slopes, 1);

haar_4302_H_T = table(repmat((1:p_slopes)', [rows_4302, 1]), ...
    reshape(haar_4302_H', [], 1), ...
    repelem(y_feat_4302, p_slopes));
SYM8_4302_H_T = table(repmat((1:p_slopes)', [rows_4302, 1]), ...
    reshape(SYM8_4302_H', [], 1), ...
    repelem(y_feat_4302, p_slopes));
haar_8702_H_T = table(repmat((1:p_slopes)', [rows_8702, 1]), ...
    reshape(haar_8702_H', [], 1), ...
    repelem(y_feat_8702, p_slopes));
SYM8_8702_H_T = table(repmat((1:p_slopes)', [rows_8702, 1]), ...
    reshape(SYM8_8702_H', [], 1), ...
    repelem(y_feat_8702, p_slopes));

max_4302 = max([haar_4302_H, SYM8_4302_H], [], "all");
max_8702 = max([haar_8702_H, SYM8_8702_H], [], "all");

%% for all H:
% - calculate quantiles
% - plot box plot and histogram

ps = [0, 0.025, 0.25, 0.5, 0.75, 0.975, 1];

quantile(reshape(haar_4302_H, [], 1), ps)
quantile(reshape(haar_8702_H, [], 1), ps)
quantile(reshape(SYM8_4302_H, [], 1), ps)
quantile(reshape(SYM8_8702_H, [], 1), ps)

t = tiledlayout(2,2)

nexttile
all_boxchart(haar_4302_H_T.Var2, "4302, Haar", max_4302)

nexttile
all_boxchart(SYM8_4302_H_T.Var2, "4302, SYM8", max_4302)

nexttile
all_boxchart(haar_8702_H_T.Var2, "8702, Haar", max_8702)

nexttile
all_boxchart(SYM8_8702_H_T.Var2, "8702, SYM8", max_8702)

title(t, "Region size = " + region_size + ", step size = " + step_size)
ylabel(t, "estimated H")

fontsize(gcf,scale=2)

fig = gcf;
fig.Position = [0, 0, 1280, 1323];
exportgraphics(fig,"realdata_allH_" + region_size + "_" + step_size + "_slopes.png", Resolution = 150)

%% for individual slope columns:
% - calculate quantiles
% - plot box plot and histogram

t = tiledlayout(2, 3)

nexttile
regiongroups_boxchart(haar_4302_H_T, "4302, Haar", max_4302)

nexttile
regiongroups_boxchart(SYM8_4302_H_T, "4302, SYM8", max_4302)

nexttile
regiongroups_boxchart(haar_8702_H_T, "8702, Haar", max_8702)

nexttile
regiongroups_boxchart(SYM8_8702_H_T, "8702, SYM8", max_8702)

title(t, "Region size = " + region_size + ", step size = " + step_size)
ylabel(t, "estimated H")

fontsize(gcf,scale=2)

%%

fig = gcf;
fig.Position = [0, 0, 2560, 1323];
exportgraphics(fig,"realdata_Hbyregiongroups_" + region_size + "_" + step_size + "_slopes.png", Resolution = 150)

%% some functions

function b = all_boxchart(input_data, chart_title, ylim_max)
    b = boxchart(input_data);
    yline(1, 'r-');
    title(chart_title)
    ylim([0, 1.10*ylim_max])
    b.JitterOutliers = 'on';
    b.MarkerStyle = 'o';
end

function b = regiongroups_boxchart(input_data, chart_title, ylim_max)
    b = boxchart(input_data.Var1, input_data.Var2, GroupByColor=input_data.Var3);
    legend
    yline(1, 'r-');
    title(chart_title)
    ylim([0, 1.10*ylim_max])
    legend(b)
end
