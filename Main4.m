% This main script computes average covariance matrix across all subjects
% and find the weight matrix, W, for the two classes then plots a selected
% number of topographic plots

clear all; close all; clc;
addpath('.')
Subjects = [1:11,13:17];%[2:3,5:6,9,11,13,17];        % Subject indexes for females to include
N = length(Subjects);
for k = 1:N
    tic
    subjidx = strcat('Subj',num2str(Subjects(k)));
    [nts,m,si,sint] = SubjectFind(subjidx);
    
    nts = nts./trace((nts')*nts);
    m = m./trace((m')*m);
    si = si./trace((si')*si);
    sint = sint./trace((sint')*sint);
    
    E1 = nts';
    E2 = m';
    E3 = si';
    E4 = sint';
    
    % Covariance matrices stacked in 3rd dimension
    C1(:,:,k) = (E1*E1')/(trace(E1*E1'));
    C2(:,:,k) = (E2*E2')/(trace(E2*E2'));
    C3(:,:,k) = (E3*E3')/(trace(E3*E3'));
    C4(:,:,k) = (E4*E4')/(trace(E4*E4'));
    toc
end


%% Save data
save('TopoData2.mat', 'C1', 'C2', 'C3', 'C4')

%% Load data to save time
load('TopoData2.mat')
S1 = mean(C1,3);
S2 = mean(C2,3);
S3 = mean(C3,3);
S4 = mean(C4,3);
%%


Q = 3;      % Number of filters/patterns to display per class
pos = [488.2000   41.8000  349.6000  740.8000]; % suitable for 8 per class plots

% Non-task specific vs Motor action
[W,~] = CSP_Weight2(S1,(S2+S3+S4)./3,'new');
fig1 = TopoPlotColumns(W,Q);
A1 = inv(W)';

% Non-task specific vs Speech Imagery
[W,~] = CSP_Weight2(S1,S3,'new');
fig2 = TopoPlotColumns(W,Q);
A2 = inv(W)';

% Non-task specific vs Motor intention
[W,~] = CSP_Weight2(S1,S4,'new');
fig3 = TopoPlotColumns(W,Q);
A3 = inv(W)';

% Motor action vs SInt
[W,~] = CSP_Weight2(S2,S4,'new');
fig4 = TopoPlotColumns(W,Q);
A4 = inv(W)';

%% Looking for sources
fig5 = TopoPlotColumns(A1,Q);
fig6 = TopoPlotColumns(A2,Q);
fig7 = TopoPlotColumns(A3,Q);
fig8 = TopoPlotColumns(A4,Q);

%% Figure reposition
screen_size = get(groot, 'ScreenSize');
w_d_4 = (screen_size(3) / 4);
h_d_4 = (screen_size(4)/2);
lpos = [0:3,0:3]*w_d_4;  % Figure distances from left side
bpos = [0,0,0,0,1,1,1,1]*h_d_4; % Figure distances from bottom

for k = 1:8
    substr1 = num2str(k);
    substr2 = num2str(lpos(k));
    substr3 = num2str(bpos(k));
    substr4 = num2str(w_d_4);
    substr5 = num2str(h_d_4);
    str = strcat('fig',substr1,'.Position = [',substr2,',',substr3,',',substr4,',',substr5,'];');
    eval(str);
end

    %% Save to file
% % Uncomment for saving the figures
% % Make folder if it doesn't exist
% if(~exist('topoplots', 'dir'))
%     mkdir 'topoplots'
% end
% 
% cd .\topoplots
% % Looping through the figures and saving them one by one
% for k = 1:8
%     substr1 = num2str(k);
%     str = strcat('saveas(fig',substr1,', ''topoplot_',substr1,''',''epsc'');');
%     eval(str)
% end
% 
% cd ..