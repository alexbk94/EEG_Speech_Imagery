% This script is supposed to generate curves demonstrating accuracy from
% epoch length.

clear all; close all; clc;
addpath('.')
cd ./recordings/MaleSubjs
K = 10;     % k-fold validation
eSz = [50:50:1500];
lag = 500;
d = dir;
D = {d.name}; clear d;

CEL = {' ','non','new','new2'};
for JJ = 1:length(eSz)   % repeat for epoch sizes
    tic
    N = length(D)-2;
    % Preallocation
    TP = zeros(N,1);FP = zeros(N,1);TN = zeros(N,1);FN = zeros(N,1);
    for k = 1:N
        str = strcat('cd ./Subj',num2str(k));
        eval(str)
        
        [nts,m,smi,mi] = TrialsMerge;
        [TP(k),FP(k),TN(k),FN(k),W] = KFoldValidate(nts', m',K,lag,eSz(JJ),'new');
        cd ..
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
        str = strcat('cd ./Subj',num2str(k));
        eval(str)
        
        [nts,m,smi,mi] = TrialsMerge;
        [TP(k),FP(k),TN(k),FN(k),W] = KFoldValidate(nts',m',K,lag,eSz(JJ),'new');
        cd ..
        
    end
    
    % Append data for specificity and sensitivity analysis
    FemaleTable = [TP,FP,TN,FN];
    
    cd ../MaleSubjs
    
    accur(JJ,1) = mean(sum(FemaleTable(:,[1,3]),2));
    accur(JJ,2) = mean(sum(MaleTable(:,[1,3]),2));
    accur(JJ,3) = mean(sum([MaleTable(:,[1,3]);FemaleTable(:,[1,3])],2));
    varian(JJ,1) = var(sum(FemaleTable(:,[1,3]),2));
    varian(JJ,2) = var(sum(MaleTable(:,[1,3]),2));
    varian(JJ,3) = var(sum([MaleTable(:,[1,3]);FemaleTable(:,[1,3])],2));
    toc
end

% figure
% subplot(3,1,1)
% errorbar(eSz,accur(:,1),varian(:,1))
% subplot(3,1,2)
% errorbar(eSz,accur(:,2),varian(:,2))
% subplot(3,1,3)
% errorbar(eSz,accur(:,3),varian(:,3))

%% Save data
cd ../..

save('EpochVSAccuracy.mat','eSz','accur')

%% Make and save figures
lwfactor = 1.5;
fsfactor = 16;

fig1 = figure(1);
errorbar(eSz,accur(:,1),varian(:,1),'LineWidth',lwfactor)
hold on
errorbar(eSz,accur(:,2),varian(:,2),'LineWidth',lwfactor)
legend('Female group','Male group','location','southeast')
ylabel('Classification accuracy')
xlabel('Epoch size [samples]')
xticks([100:100:1500])
fig1.Position = [39.6667 278.3333 1.2227e+03 339.6667];
set(gca,'FontSize',16)
xlim([0,1550])

fig2 = figure(2);
errorbar(eSz,accur(:,3),varian(:,3),'LineWidth',lwfactor)
ylabel('Classification accuracy')
xlabel('Epoch size [samples]')
xticks([100:100:1500])
fig2.Position = [39.6667 278.3333 1.2227e+03 339.6667];
set(gca,'FontSize',16)
xlim([0,1550])

saveas(fig1,'MaleFemaleAcc.png')
saveas(fig2,'BothAcc.png')