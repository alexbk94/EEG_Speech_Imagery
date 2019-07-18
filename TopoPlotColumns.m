function fig = TopoPlotColumns(WA,n,pos)
% n = Number of topomaps per class
% WA = matrixs whose columns is to be plotted. W or A
% Plots topographic maps for the two classes in two seperate columns,
% in order of decreasing importance of components

col_idx(1:2:(2*n-1)) = 1:n;
col_idx(2:2:(2*n)) = 16:-1:(16-n+1);

fig = figure;
word_pos = [0.4848, -0.3939];       % [x, y]
for k = 1:(2*n)
    subplot(n,2,k)
    m = max(abs(WA(:,col_idx(k))));  % Normalization factor
    topoplot(WA(:,col_idx(k))./m,'channel_locations.loc');
    text(word_pos(1),word_pos(2),num2str(col_idx(k)),'FontWeight','bold');
end

% Optional position manipulation
if nargin == 3
    fig.Position = pos;
end

% Colorbar position manipulation
sf = get(subplot(n,2,2*n),'Position');
% colorbar('Position', [sf(1)+sf(3)+0.01,  sf(2),  0.03  sf(2)+sf(3)*2.1]);

% colorbar under figures
c = colorbar('southoutside','Position', [sf(1)-sf(3)*1.3, sf(2)-0.05, 2.3*sf(3), 0.02]);
c.Limits = [-1 1];
c.Ticks =[-1, -0.5, 0, 0.5, 1];
c.FontSize = 12;