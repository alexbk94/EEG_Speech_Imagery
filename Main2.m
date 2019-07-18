% % This script is supposed to generate curves demonstrating accuracy from
% % epoch length.
% 
clear all; close all; clc;
% addpath('.')
% 
% K = 10;                 % k-fold validation
% eSz = [50:50:1500];     % Epoch sizes to test
% lag = 500;              % Sample shift between epochs
% Subjects = 1:17;        % Subject indexes for females to include
% N = length(Subjects);
% 
% %CEL = {' ','non','new','new2'};
% accurTable = zeros(length(eSz),N);
% 
% for k = 1:N
%     tic
%     subjidx = strcat('Subj',num2str(Subjects(k)));
%     [nts,m,si,sint] = SubjectFind(subjidx);
%     for JJ = 1:length(eSz)
%         [TP,FP,TN,FN] = KFoldValidate(nts', sint',K,lag,eSz(JJ),'new');
%         accurTable(JJ,k) = (TP+TN)/(TP+FP+TN+FN);
%     end
%     toc
% end


%% Save data
% save('EpochVSAccuracySInt.mat','eSz','accurTable')

%% Make and save figures
lwfactor = 1.5;
fsfactor = 25;

fig1 = figure;
load('EpochVSAccuracySI.mat');
errorbar(eSz,mean(accurTable,2),var(accurTable,[],2),'LineWidth',lwfactor)
hold on
%
load('EpochVSAccuracySInt.mat')
%
errorbar(eSz,mean(accurTable,2),var(accurTable,[],2),'LineWidth',lwfactor)
ylabel('Accuracy')
xlabel('Epoch size [samples]')
xticks([100:200:1500])
fig1.Position = [39.6667 278.3333 1.2227e+03 339.6667];
set(gca,'FontSize',fsfactor)
xlim([0,1550])
ylim([0.76 0.94])
legend('NTS vs SI','NTS vs SInt','location','southeast')

%% Saving figure
cd ./plotsAndFigures
    saveas(fig1,'NTSvsSIandSInt','epsc')
cd ..