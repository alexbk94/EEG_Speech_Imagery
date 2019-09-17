function [X,Y,T,AUC, CM] = SingleValidate2(trainData,testData,lag,eSz,Warg)
% This function computes the accuracy terms given the training- and test
% data and the epoch lag- and size. Last output argument allows to extract
% the computed weightmatrix aswell.
% trainData             : Two matrix array first matrix is the 'Positive'
% classification data, second is 'Negative' in terms of true positive, true
% negative... This is used for training the classifier. Rows =
% channel columns = time of the epoch
% testData               : Same as trainData this used for testing the
% classifier.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This update (SingleValidate2) returns ROC coordinates for plotting in stead
% of the Confusion matrix
W = (CSP_Weight( squeeze(trainData(:,:,1)), ...
                            squeeze(trainData(:,:,2)),Warg)');
% Convert to source space
trainData = eeg2src( trainData , W);
testData = eeg2src( testData , W);

% Epoch extraction
Etrain = epochExtraction(trainData,lag,eSz);
Etest = epochExtraction(testData,lag,eSz);
% First index = channels, second index = epoch samples, third index = other
% epochs, 

nChl = size(Etrain,1);
nTime = size(Etrain,2);
nFeat = size(Etrain,3);

numer1 = var(Etrain,0,2);
numer2 = var(Etest,0,2);
denom1 = repmat(sum(numer1,1),nChl,1,1,1);
denom2 = repmat(sum(numer2,1),nChl,1,1,1);

feat1 = log10(numer1./denom1);
feat2 = log10(numer2./denom2);
% Training data
y1 = squeeze(feat1(:,:,:,1))';
y2 = squeeze(feat1(:,:,:,2))';
% Test data
y3 = squeeze(feat2(:,:,:,1))';
y4 = squeeze(feat2(:,:,:,2))';

%% Train svm
train = [y1;y2];
classIdx = [zeros(nFeat,1);ones(nFeat,1)];

SVM = fitcsvm(train,classIdx);


%% Check prediction model
% Get ROC curves
nFeat2 = size(y3,1);
classIdxTest = [zeros(nFeat2,1);ones(nFeat2,1)];    % Assuming same size y3 and y4
[label,scores] = predict(SVM,[y3;y4]);
[X,Y,T,AUC] = perfcurve(classIdxTest,scores(:,2),1);    % ROC results
CM = confusionmat(classIdxTest,label);                  % Confusion matrix
end
