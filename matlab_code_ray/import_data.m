%% Options

% Define the root directories
root_dir_4302 = '..\DATA\OvarianDataset4-3-02';
root_dir_8702 = '..\DATA\OvarianDataset8-7-02';

% Define the case and control directories for each dataset
data_dirs_4302_case = fullfile(root_dir_4302, 'cancer');
data_dirs_4302_control = fullfile(root_dir_4302, 'control');
data_dirs_8702_case = fullfile(root_dir_8702, 'Ovarian Cancer');
data_dirs_8702_control = fullfile(root_dir_8702, 'Control');

%% read data

case_4302 = read_csv_directory_with_label(data_dirs_4302_case, 1);
control_4302 = read_csv_directory_with_label(data_dirs_4302_control, 0);
data_4302 = [case_4302; control_4302];

case_8702 = read_csv_directory_with_label(data_dirs_8702_case, 1);
control_8702 = read_csv_directory_with_label(data_dirs_8702_control, 0);
data_8702 = [case_8702; control_8702];

%% save data
save('..\DATA\4302.mat', 'data_4302');
save('..\DATA\8702.mat', 'data_8702');

%% plot example 4302 data

x = 1:(size(data, 2) - 1);

figure;
subplot(2, 1, 1);
plot(x, data_4302(1, 1:(end-1)));
title(['Sample 4302 Data, label = ' num2str(data_4302(1, end))]);

subplot(2, 1, 2);
plot(x, data_4302(end, 1:(end-1)));
title(['Sample 4302 Data, label = ' num2str(data_4302(end, end))]);

%% plot example 8702 data

figure;
subplot(2, 1, 1);
plot(x, data_8702(1, 1:(end-1)));
title(['Sample 8702 Data, label = ' num2str(data_8702(1, end))]);

subplot(2, 1, 2);
plot(x, data_8702(end, 1:(end-1)));
title(['Sample 8702 Data, label = ' num2str(data_8702(end, end))]);
%% define function for reading data

function data = read_csv_directory_with_label(directory_path, label)
% List all CSV files in the directory
csv_files = dir(fullfile(directory_path, '*.csv'));

% Preallocate a matrix to hold the data and labels
num_files = length(csv_files);
csv_data = readmatrix(fullfile(directory_path, csv_files(1).name), 'Range', [2, 2]); % Read the second column of the first CSV file
num_rows = size(csv_data, 1);
data = NaN(num_files, num_rows + 1); % +1 for the label column

% Loop over the CSV files and read the second column
for i = 1:num_files
    file_path = fullfile(directory_path, csv_files(i).name);
    csv_data = readmatrix(file_path, 'Range', [2, 2]); % Read only the second column
    data(i, 1:(end-1)) = csv_data(:, 1)';
end

% Add the label column
data(:, end) = label;

end