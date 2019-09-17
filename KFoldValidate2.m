function [Xout,Yout,Tout,AUCout,CMout] = KFoldValidate2(data1, data2,k,lag,eSz,Warg)
% This function is a modification of KFoldValidate, so that instead of
% getting out true- and false- -positives and negatives, it outputs
% parameters from individual ROC curves

% Assing data1 and data2 are equally long
len = size(data1,2);
nChl = size(data1,1);
nSamp = floor(len/k);

% Pre allocation
X = zeros(121,k); Y = zeros(121,k); T = zeros(121,k); AUC = zeros(k,1);
CM = zeros(2,2,k);

for II = 1:k
    idx1 = nSamp*(II-1)+1;
    idx2 = nSamp*II;
    
    if II == k
        idx2 = len;
    end
    
    testDat1 = data1(:,idx1:idx2);
    testDat2 = data2(:,idx1:idx2);
    
    trainDat1 = data1; trainDat1(:,idx1:idx2)=[];
    trainDat2 = data2; trainDat2(:,idx1:idx2)=[];
    
    testT = cat(3,testDat1,testDat2);
    trainT = cat(3,trainDat1,trainDat2);
    clear testDat1 testDat2  trainDat1 trainDat2;
    
    [X(:,II),Y(:,II),T(:,II),AUC(II), CM(:,:,II)] = SingleValidate2(trainT,testT,lag,eSz,Warg);
end

Xout = mean(X,2);
Yout = mean(Y,2);
Tout = mean(T,2);
AUCout = mean(AUC);
CMout = sum(CM,3);