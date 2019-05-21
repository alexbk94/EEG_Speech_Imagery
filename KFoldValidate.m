function [TP,FP,TN,FN, W] = KFoldValidate(data1, data2,k,lag,eSz,Warg)
% Takes the parameter k, do the k-fold cross validation and determine
% average true positive, false positive, true negative and false negative

% Assing data1 and data2 are equally long
len = size(data1,2);
nChl = size(data1,1);
nSamp = floor(len/k);

% Pre allocation
TP = zeros(k,1);FP = zeros(k,1);TN = zeros(k,1);FN = zeros(k,1);
W = zeros(nChl,nChl,k);

for II = 1:k
    idx1 = nSamp*(II-1)+1;
    idx2 = nSamp*II;
    
    if II == k
        idx2 = len;
    end
    
    trainDat1 = data1(:,idx1:idx2);
    trainDat2 = data2(:,idx1:idx2);
    trainT = cat(3,trainDat1,trainDat2);
    
    testDat1 = data1; testDat1(:,idx1:idx2)=[];
    testDat2 = data2; testDat2(:,idx1:idx2)=[];
    testT = cat(3,testDat1,testDat2);
    clear testDat1 testDat2  trainDat1 trainDat2;
    
    [TP(II),FP(II),TN(II),FN(II), W(:,:,II)] = SingleValidate(trainT,testT,lag,eSz,Warg);
end
total = sum([TP(1),FP(1),TN(1),FN(1)]);
TP = mean(TP)/total; 
FP = mean(FP)/total;
TN = mean(TN)/total;
FN = mean(FN)/total;