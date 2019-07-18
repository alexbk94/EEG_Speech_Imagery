function [fig,AUCs] = ROCplotter2(X,X2,X3,X4,X5,X6,Y,Y2,Y3,Y4,Y5,Y6,flag)
% This function takes in multiple X and multiple Y and plots the median ROC
% of each Y
quant = [0, 0.25, 0.5, 0.75, 1];
if strcmp(flag,'mean')
    mY = mean(Y,2);
    mY2 = mean(Y2,2);
    mY3 = mean(Y3,2);
    mY4 = mean(Y4,2);
    mY5 = mean(Y5,2);
    mY6 = mean(Y6,2);
    mX = mean(X,2);
    mX2 = mean(X2,2);
    mX3 = mean(X3,2);
    mX4 = mean(X4,2);
    mX5 = mean(X5,2);
    mX6 = mean(X6,2);
elseif strcmp(flag,'median')
    mY = median(Y,2);
    mY2 = median(Y2,2);
    mY3 = median(Y3,2);
    mY4 = median(Y4,2);
    mY5 = median(Y5,2);
    mY6 = median(Y6,2);
    mX = median(X,2);
    mX2 = median(X2,2);
    mX3 = median(X3,2);
    mX4 = median(X4,2);
    mX5 = median(X5,2);
    mX6 = median(X6,2);
else
    error('Not recognized flag')
end

% Using quantiles for demonstrating deviation
% qY = quantile(Y,quant,2);
% 
% XCell = {mX,mX};
% YCell = {qY(:,2),qY(:,4)};              % 0.25 and 0.75 quantiles
% pgon = polyshape(XCell,YCell);
fig = figure;
% pg = plot(pgon);
% pg.FaceColor = [0.2, 0.2, 0.2];         % Color of polyshape
% pg.FaceAlpha = 0.1;                     % Transparency of polyshape
% pg.EdgeColor = 'w';                     % Removing edge
hold on;
plot(mX,mY,'LineWidth',1.4)                 % Median (of each point) ROC
plot(mX2,mY2,'LineWidth',1.4)                 % Median (of each point) ROC
plot(mX3,mY3,'LineWidth',1.4)                 % Median (of each point) ROC
plot(mX4,mY4,'LineWidth',1.4)                 % Median (of each point) ROC
plot(mX5,mY5,'LineWidth',1.4)                 % Median (of each point) ROC
plot(mX6,mY6,'LineWidth',1.4)                 % Median (of each point) ROC

axis('image')                           % fix axes to equal length
xlim([0,1])
ylim([0,1])
legend('NTS vs M','NTS vs SI', ...
        'NTS vs SInt','M vs SI', ...
        'M vs SInt', 'SI vs SInt', ...
        'Location','southeast')
fig.Position = [629 115.4000 678.4000 592.8000];
xlabel('False positive rate')
ylabel('True positive rate')
set(gca,'FontSize',20)                  % Textsize
grid on;
dmX = diff(mX);
dmX = [0; dmX]*(length(mX));    % Accounting for width of the point (starting at point 0
dmX2 = diff(mX2);
dmX2 = [0; dmX2]*(length(mX2));
dmX3 = diff(mX3);
dmX3 = [0; dmX3]*(length(mX3));
dmX4 = diff(mX4);
dmX4 = [0; dmX4]*(length(mX4));
dmX5 = diff(mX5);
dmX5 = [0; dmX5]*(length(mX5));
dmX6 = diff(mX6);
dmX6 = [0; dmX6]*(length(mX6));
AUCs = [mean(mY.*dmX), mean(mY2.*dmX2), ...
        mean(mY3.*dmX3), mean(mY4.*dmX4), ...
        mean(mY5.*dmX5), mean(mY6.*dmX6)];