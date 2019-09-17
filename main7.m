% This main function computes frequency plots of estimated source activity
% by using filters computed from loaded covariance matrices from Main4

%% Load data to save time
close all; clear all; clc;
addpath('.')

% The loaded data is from script 'Main4.m' containing covariance matrices
% based only on subjects: [1:3,5:7,9:11,13:15,17]. Make sure these saved
% matrices haven't been overwritten by matrices using other subjects
load('TopoData.mat')
S1 = mean(C1,3);            % Average population covariance matrices
S2 = mean(C2,3);
S3 = mean(C3,3);
S4 = mean(C4,3);
% Non-task specific vs Motor intention
[W,~] = CSP_Weight2(S1,(S2+S3+S4)/3,'new');
subs = [1:3,5:7,9:11,13:15,17]; 
%% PSD individuals - trace normalized NTS vs Everything
% Demonstrate spectra of the individual filters, to visually examine if any
% of the filters have spectra of interest
% fig = PSDPlotter(subs, ...
%                 W,[1:6], 100,'rectwin');
% 
% fig = PSDPlotter(subs, ...
%                 W,[7:11], 100,'rectwin');
% 
% fig = PSDPlotter(subs, ...
%                 W,[12:16], 100,'rectwin');
%% PSD average of selected filters
fig1 = PSDPlotter(subs, ... 
                W, [1, 16], 100,'rectwin');
% Manually adjust xlabel position to stay inside the figure
fig1.Children(2).XLabel.Position(2) = -0.47;

fig2 = PSDPlotter(subs, ...
                W, [2,3,15], 100,'rectwin');
% Manually adjust xlabel position to stay inside the figure
fig2.Children(2).XLabel.Position(2) = -0.029;

%% PSD average - trace normalized MT vs SInt 
[W,~] = CSP_Weight2(S2,S4,'new');
% % Figures for manually scanning for interesting filters
% fig = PSDPlotter(subs, ...
%                 W,[1:6], 100,'rectwin');
% 
% fig = PSDPlotter(subs, ...
%                 W,[7:11], 100,'rectwin');
% 
% fig = PSDPlotter(subs, ...
%                 W,[12:16], 100,'rectwin');
% % 1, 3, 12 and 16 are interesting
%% PSD
fig3 = PSDPlotter(subs, ... 
                W, [1, 3], 100,'rectwin');
% Manually adjust xlabel position to stay inside the figure
fig3.Children(2).XLabel.Position(2) = -0.08;

fig4 = PSDPlotter(subs, ...
                W, [12, 16], 100,'rectwin');
% Manually adjust xlabel position to stay inside the figure
fig4.Children(2).XLabel.Position(2) = -0.3;
%%
cd ./periodograms
    for k = 1:4     
        saveas( eval(strcat('fig',num2str(k))), ...
            strcat('newPeriodograms',num2str(k)),'epsc');
    end
cd ..
