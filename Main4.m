% This main script computes average covariance matrix across all subjects
% and find the weight matrix, W, for the two classes chosen by the
% variables 'tag1' and 'tag2' (line 19 and 20)

clear all;% close all; clc;
addpath('.')
cd ./recordings/MaleSubjs
K = 10;     % k-fold validation
eSz = 600;
lag = 500;
d = dir;
D = {d.name}; clear d;
N = length(D)-2;

% Preallocation
TP = zeros(N,1);FP = zeros(N,1);TN = zeros(N,1);FN = zeros(N,1);

% Tags deciding which 2 datasets to compare. (1 = nts, 2 = m, 3=smi, 4=mi)
tag1 = 2;
tag2 = 3;

if (tag1==tag2 || tag1>4 || tag2>4 || tag1<1 || tag2<1)
    error('invalid tag options') % options 1 to 4 and not the same value
end

for k = 1:N
    tic
    str = strcat('cd ./Subj',num2str(k));
    eval(str)
    
    [nts,m,smi,mi] = TrialsMerge;
    CCC = [{nts},{m},{smi},{mi}]; % For indexing with tags
    E1 = CCC{tag1}';
    E2 = CCC{tag2}';
    
    % Covariance matrices stacked in 3rd dimension
    C1(:,:,k) = (E1*E1')/(trace(E1*E1'));
    C2(:,:,k) = (E2*E2')/(trace(E2*E2'));
    toc
    cd ..
end

cd ..
cd ./FemaleSubjs/

d = dir;
D = {d.name}; clear d;
M = length(D)-2;


for k = 1:M
    tic
    str = strcat('cd ./Subj',num2str(k));
    eval(str)
    
    [nts,m,smi,mi] = TrialsMerge;
    CCC = [{nts},{m},{smi},{mi}]; % For indexing with tags
    E1 = CCC{tag1}';
    E2 = CCC{tag2}';
    
    % Covariance matrices stacked in 3rd dimension
    C1(:,:,k+N) = (E1*E1')/(trace(E1*E1'));
    C2(:,:,k+N) = (E2*E2')/(trace(E2*E2'));
    toc
    cd ..
end

cd ../..
S1 = mean(C1,3);
S2 = mean(C2,3);

W = CSP_Weight2(S1,S2,'new');
W_plot_temp = [W(:,1),W(:,end),W(:,2),W(:,end-1),W(:,3),W(:,end-2)];

fig1 = figure(1);
for k = 1:6
    subplot(3,2,k)
    topoplot(W_plot_temp(:,k),'channel_locations.loc');
end

% save('Spesen', BothTable)
% save('data_W_t', W_t)