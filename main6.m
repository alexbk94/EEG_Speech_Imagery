% This main script computes average ROC-curves, confusion matrix and AUCs
% for all subjects

clear all; close all; clc;
% eSz = 600;      % Epoch size
% lag = 500;      % Epoch step size
% K = 10;         % 10-fold cross validation
% addpath('.')
% 
% Subjects = 1:17;
% M = length(Subjects);
% 
% for k = 1:M
%     tic
%     subjidx = strcat('Subj',num2str(Subjects(k)));
%     [nts,m,si,sint] = SubjectFind(subjidx);
%     
%     E1 = nts';
%     E2 = m';
%     E3 = si';
%     E4 = sint';
%     
%     [X(:,k),Y(:,k),T(:,k),AUC(k), CM(:,:,k)] = KFoldValidate2(E1, E2, K, lag, eSz,'new');
%     
%     [X2(:,k),Y2(:,k),T2(:,k),AUC2(k), CM2(:,:,k)] = KFoldValidate2(E1, E3, K, lag, eSz,'new');
%     
%     [X3(:,k),Y3(:,k),T3(:,k),AUC3(k), CM3(:,:,k)] = KFoldValidate2(E1, E4, K, lag, eSz,'new');
%     
%     [X4(:,k),Y4(:,k),T4(:,k),AUC4(k), CM4(:,:,k)] = KFoldValidate2(E2, E3, K, lag, eSz,'new');
%     
%     [X5(:,k),Y5(:,k),T5(:,k),AUC5(k), CM5(:,:,k)] = KFoldValidate2(E2, E4, K, lag, eSz,'new');
%     
%     [X6(:,k),Y6(:,k),T6(:,k),AUC6(k), CM6(:,:,k)] = KFoldValidate2(E3, E4, K, lag, eSz,'new');
%     
%     toc
% end
% 
%% Save result
% save('ROCandConfusionmatrix2.mat','X','Y','T','AUC','CM', ...
%                                 'X2','Y2','T2','AUC2','CM2', ...
%                                 'X3','Y3','T3','AUC3','CM3', ...
%                                 'X4','Y4','T4','AUC4','CM4', ...
%                                 'X5','Y5','T5','AUC5','CM5', ...
%                                 'X6','Y6','T6','AUC6','CM6')
                            
%% load result to make plot
% This data is saved and loaded to save extensive computational time
load('ROCandConfusionmatrix.mat');

%% Confusion matrix result (Only for NTS vs M) - Should be repeated if included
CMall = sum(CM,3);
CMallpct = CMall ./ sum(CM(:));
%% Single ROC plot - OBSOLETE This has been moved into a function ROCplotter
% quant = [0, 0.25, 0.5, 0.75, 1];
% mY = mean(Y,2);
% mX = mean(X,2);
% 
% % Using quantiles for demonstrating deviation
% qY = quantile(Y,quant,2);f
% 
% XCell = {mX,mX};
% YCell = {qY(:,2),qY(:,4)};  % 0.25 and 0.75 quantiles
% pgon = polyshape(XCell,YCell);
% fig1 = figure(1);
% pg = plot(pgon);
% pg.FaceColor = [0.2, 0.2, 0.2];         % Color of polyshape
% pg.FaceAlpha = 0.1;                     % Transparency of polyshape
% pg.EdgeColor = 'w';                     % Removing edge
% hold on;
% plot(mX,qY(:,3),'LineWidth',1.4)        % Median (of each point) ROC
% plot(mX,mY,'LineWidth',1.4)             % Mean ROC
% 
% axis('image')
% xlim([0,1])
% ylim([0,1])
% legend('25% and 75% quantile','Median ROC','Mean ROC','Location','east')
%%
% aucs = [mean(AUC),mean(AUC2),mean(AUC3),mean(AUC4),mean(AUC5),mean(AUC6)];
% aucs3 should be approximately the same as aucs
[fig1,aucs3] = ROCplotter2(X,X2,X3,X4,X5,X6,Y,Y2,Y3,Y4,Y5,Y6,'mean');
%% Save figures
cd ./plotsAndFigures
    saveas(fig1,'ROC_means','epsc')   % Subject mean ROC median cross subject
cd ..