% This main script computes the accuracy of individual subjects and stores
% it in matrices 'MaleSubs' and 'FemaleSubs'.

%clear all; close all; clc;
eSz = 600;      % Epoch size
lag = 500;      % Epoch step size
K = 10;         % 10-fold cross validation
addpath('.')
Subjects = 1:17;        % Subject indexes for females to include
N = length(Subjects);
AccTable = zeros(N,6);

for k = 1:N
    tic
    subjidx = strcat('Subj',num2str(Subjects(k)));
    [nts,m,si,sint] = SubjectFind(subjidx);
    
    [TP, FP, TN, FN] = KFoldValidate(nts', m', K, lag, eSz,'new');
    AccTable(k,1) = (TP+TN)/(TP+FP+TN+FN);
    
    [TP, FP, TN, FN] = KFoldValidate(nts', si', K, lag, eSz,'new');
    AccTable(k,2) = (TP+TN)/(TP+FP+TN+FN);
    
    [TP, FP, TN, FN] = KFoldValidate(nts', sint', K, lag, eSz,'new');
    AccTable(k,3) = (TP+TN)/(TP+FP+TN+FN);
    
    [TP, FP, TN, FN] = KFoldValidate(m', si', K, lag, eSz,'new');
    AccTable(k,4) = (TP+TN)/(TP+FP+TN+FN);
    
    [TP, FP, TN, FN] = KFoldValidate(m', sint', K, lag, eSz,'new');
    AccTable(k,5) = (TP+TN)/(TP+FP+TN+FN);
    
    [TP, FP, TN, FN] = KFoldValidate(si', sint', K, lag, eSz,'new');
    AccTable(k,6) = (TP+TN)/(TP+FP+TN+FN);
    
    toc
end

%%  Save results
FemaleSubs = AccTable(1:6,:);
MaleSubs = AccTable(7:end,:);

% Making a matrix including the subgroup mean and standard deviation and
% the overall mean and standard deviation.
TTab = [FemaleSubs; mean(FemaleSubs,1); std(FemaleSubs,[],1); ...
        MaleSubs; mean(MaleSubs,1); std(MaleSubs,[],1); ...
        mean(AccTable,1); std(AccTable,[],1)];

TotalTable = round(TTab,3);   % Round to 3rd decimal

% File type for easy import into table generator:
csvwrite('FemaleMaleTable.csv',TotalTable);