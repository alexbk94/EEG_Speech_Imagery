% This main script is used for generating a figure demonstrating
% the location of electrodes.

zer = zeros(16,1);
figure
% NOTICE: This line will produce error. An error has been found in the
% 'topoplot' script. This has to be manually corrected. A temporary
% solution: write 'edit topoplot' in the command window. Go to line 616 and
% replace the input to the 'if-statement' with 'false'.
topoplot(zer,'channel_locations.loc','electrodes','labels','style','blank','efontsize',10)
%% Figure adjustment prior to saving
% Get figure- and axes handle
f = gcf; a = gca;
% Adjusting window size to avoid include to much blank space
f.Position = [359.6667 41.6667 629.3333 599.3333];
% Change color of figure from light blue to white
f.Color = [1,1,1];
% Adjusting axes limits to include nose and ears in plot
lim = 0.58;     % Manually determined
a.XLim = [-lim, lim];
a.YLim = [-lim, lim];

%% Save figure

saveas(f,'BlankTopoplot.png')