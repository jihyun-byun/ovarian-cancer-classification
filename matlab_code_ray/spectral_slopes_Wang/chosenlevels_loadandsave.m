% load and save slopes as CSV

load("..\DATA\DWT_chosenlevels_4302_1024_500_slopes.mat")
load("..\DATA\DWT_chosenlevels_8702_1024_500_slopes.mat")
load("..\DATA\WPD_Wang_chosenlevels_4302_1024_500_slopes.mat")
load("..\DATA\WPD_Wang_chosenlevels_8702_1024_500_slopes.mat")

writematrix(slope_chosenlevels_DWT_4302, "..\DATA\DWT_chosenlevels_4302_1024_500_slopes.csv")
writematrix(slope_chosenlevels_DWT_8702, "..\DATA\DWT_chosenlevels_8702_1024_500_slopes.csv")
writematrix(slope_chosenlevels_WPD_Wang_4302, "..\DATA\WPD_Wang_chosenlevels_4302_1024_500_slopes.csv")
writematrix(slope_chosenlevels_WPD_Wang_8702, "..\DATA\WPD_Wang_chosenlevels_8702_1024_500_slopes.csv")