% read slopes in and make boxplots of H to compare whether the real data
% had H that were closer to areas where DWT, Wang, or Jones are "better"

% method = "DWT";
method = "Wang";
% method = "Jones";

dataset = "4302";
% dataset = "8702";

%%

tl = tiledlayout(2, 1);
nexttile
real_H_hist("Wang", "4302")
title("Ovarian 4-3-02")
nexttile
real_H_hist("Wang", "8702")
title("Ovarian 8-7-02")
fontsize(gcf, scale=2)

xlabel(tl, "data window")
ylabel(tl, "estimated Hurst exponent")

%% split by Case or Control

% separate plots, one for Case, one for Control

% convert matrix to table, to easily do multi-boxplots 

%% 

function real_H_hist(method, dataset)
    if method == "DWT"
        realdata = readmatrix("DATA/DWT_chosenlevels_" + dataset + "_1024_500_slopes.csv");
    elseif method == "Wang"
        realdata = readmatrix("DATA/WPD_Wang_chosenlevels_" + dataset + "_1024_500_slopes.csv");
    elseif method == "Jones"
        realdata = readmatrix("DATA/Jones_" + dataset + "_sym4_1024_500_slopes.csv");
    end

    y_vec = repmat(realdata(:, end), 29, 1);
    slopelabels = repmat((1:29)', size(realdata, 1), 1);

    % reshape the matrix data to a single vector
    realdata_vec = reshape(realdata(:, 1:(end-1))', [], 1);

    % convert the slope data to Hurst exponent
    % DWT-based calculation
    if method == "DWT"
        realdata_vec = -(realdata_vec + 1)/2;
    elseif method == "Wang"
        % write calc for Wang Hurst exponent
        realdata_vec = -realdata_vec/2;
    elseif method == "Jones"
        realdata_vec = abs(realdata_vec + 1);
    end
    
    % plot
%     histogram(realdata_vec, -.2:.05:1.2);
%     title(method + " - " + dataset)

    boxchart(slopelabels, realdata_vec, GroupByColor=y_vec)
%     title(method + " - " + dataset)
    legend(["Control", "Case"], Location='southeast')
    axis([0 30 -.2 1.2])
    grid on

end