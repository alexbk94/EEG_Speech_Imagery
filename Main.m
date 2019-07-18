clear all; close all; clc;

addpath('.')

K = 10;     % k-fold validation
eSz = 600;
lag = 500;
Subjects = 1:17;        % Subject indexes
N = length(Subjects);
% Preallocation
TP = zeros(N,1);FP = zeros(N,1);TN = zeros(N,1);FN = zeros(N,1);

% CEL = {' ','non','new','new2'};
for k = 1:17
    tic
    subjidx = strcat('Subj',num2str(Subjects(k)));
    [nts,m,si,sint] = SubjectFind(subjidx);

    [TP(k),FP(k),TN(k),FN(k),W] = KFoldValidate(nts', si',K,lag,eSz,'new');
    toc
end
    
% Put results in tables
FemaleTable = [TP(1:6),FP(1:6),TN(1:6),FN(1:6)];
MaleTable = [TP(7:end),FP(7:end),TN(7:end),FN(7:end)];
BothTable = [MaleTable;FemaleTable];

save('MaleTable.mat','MaleTable')
save('FemaleTable.mat','FemaleTable')
save('BothTable.mat','BothTable')
% save('Spesen', BothTable)
