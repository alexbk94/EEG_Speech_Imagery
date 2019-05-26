clear all; close all; clc;
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

% Append data to save
W_t = [];
% W_t_struct = []

CEL = {' ','non','new','new2'};
for JJ = 3:3   % three cases of weight matrix
    for k = 1:N
        tic
        str = strcat('cd ./Subj',num2str(k));
        eval(str)
        
        [nts,m,smi,mi] = TrialsMerge;
        [TP(k),FP(k),TN(k),FN(k),W] = KFoldValidate(nts', m',K,lag,eSz,CEL{JJ});
        cd ..
        W2 = mean(W,3);
        W3 = W2(:,[1:3,14:16]);
        W_t = cat(3,W_t,W3);
        figure
        for II = 1:6
            subplot(3,2,II)
            topoplot(W3(:,II),'channel_locations.loc');
        end
        toc
        
        
    end
    
    % Append data for specificity and sensitivity analysis
    cd ..
    MaleTable = [TP,FP,TN,FN];
    
    cd ./FemaleSubjs/
    
    d = dir;
    D = {d.name}; clear d;
    N = length(D)-2;
    
    % Preallocation
    TP = zeros(N,1);FP = zeros(N,1);TN = zeros(N,1);FN = zeros(N,1);
    
    
    for k = 1:N
        tic
        str = strcat('cd ./Subj',num2str(k));
        eval(str)
        
        [nts,m,smi,mi] = TrialsMerge;
        [TP(k),FP(k),TN(k),FN(k),W] = KFoldValidate(nts',m',K,lag,eSz,CEL{JJ});
        cd ..
        W2 = mean(W,3);
        W3 = W2(:,[1:3,14:16]);
        W_t = cat(3,W_t,W3);
        figure
        for II = 1:6
            subplot(3,2,II)
            topoplot(W3(:,II),'channel_locations.loc');
        end
        toc
        
    end
    
    % Append data for specificity and sensitivity analysis
    FemaleTable = [TP,FP,TN,FN];
    
    cd ../MaleSubjs
    
    accur(JJ,1) = mean(sum(FemaleTable(:,[1,3]),2));
    accur(JJ,2) = mean(sum(MaleTable(:,[1,3]),2));
end
% BothTable = [MaleTable;FemaleTable];

% save('Spesen', BothTable)
% save('data_W_t', W_t)