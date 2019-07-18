% This main function computes frequency plots of estimated source activity
% by using filters computed from loaded covariance matrices from Main4

%% Load data to save time
close all; clear all; clc;
addpath('.')

load('TopoData2.mat')
S1 = mean(C1,3);
S2 = mean(C2,3);
S3 = mean(C3,3);
S4 = mean(C4,3);
% Non-task specific vs Motor intention
[W,~] = CSP_Weight2(S1,(S2+S3+S4)./3,'new');

%% PSD individuals - trace normalized
% for k = 1:17
% fig = PSDPlotter(k, ...
%                 W,[1,2,15,16], 100,'rectwin');
% end
%% PSD average - trace normalized
fig = PSDPlotter([1:17], ... %[1:3,5:7,9:11,13:17], ...
                W,[2,16], 100,'rectwin');

%% Normalized to covariance trace
cd ./periodograms
saveas(fig,'NormalizedMeanTendencyPlots','epsc')
cd ..