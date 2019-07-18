function fig = ROCplotter(X,Y)

quant = [0, 0.25, 0.5, 0.75, 1];
mY = mean(Y,2);
mX = mean(X,2);

% Using quantiles for demonstrating deviation
qY = quantile(Y,quant,2);

XCell = {mX,mX};
YCell = {qY(:,2),qY(:,4)};              % 0.25 and 0.75 quantiles
pgon = polyshape(XCell,YCell);
fig = figure;
pg = plot(pgon);
pg.FaceColor = [0.2, 0.2, 0.2];         % Color of polyshape
pg.FaceAlpha = 0.1;                     % Transparency of polyshape
pg.EdgeColor = 'w';                     % Removing edge
hold on;
plot(mX,qY(:,3),'LineWidth',1.4)        % Median (of each point) ROC
plot(mX,mY,'LineWidth',1.4)             % Mean ROC

axis('image')                           % fix axes to equal length
xlim([0,1])
ylim([0,1])
legend('25% and 75% quantile','Median ROC','Mean ROC','Location','southeast')
fig.Position = [629 115.4000 678.4000 592.8000];
xlabel('False positive rate')
ylabel('True positive rate')
set(gca,'FontSize',20)                  % Textsize
grid on;