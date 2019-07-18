function [fig,f2,pNTS,pM,pSI,pSInt] = PSDPlotter(Subjects,W,Widx,M,winOpt)
% This function plots the topographic maps of the weight matrix W specified
% by index Widx. The corresponding Energy Spectral Density is plottet next
% to it for the four cases.
% winOpt is an optional built-in matlab windowing function,
% Subjects is a vector of the subject index(es) to average over
K = length(Subjects);
% This is an average spectrum of all trials of all individuals
% M is number of subdivisions of the dataset (High M = low resolution
%                                             ,Low M = high noise)
N = length(Widx);
A = inv(W)';
Wnew = W(:,Widx);
Anew = A(:,Widx);
% k = 1;
for k = 1:K % excluding subject 12, because of weirdly strong gain on nts
    % Extract data from subject index
    subjidx = strcat('Subj',num2str(Subjects(k)));
    [nts,m,si,sint] = SubjectFind(subjidx);
    
    % Normalizing to trace
    nts = nts./trace((nts')*nts);
    m = m./trace((m')*m);
    si = si./trace((si')*si);
    sint = sint./trace((sint')*sint);
    
    for n = 1:M
        % Subsegment index
        idx1 = (n-1)*floor(length(nts)/M)+1;
        idx2 = n*floor(length(nts)/M);
        
        sNTS = (nts(idx1:idx2,:)');
        sM = (m(idx1:idx2,:)');
        sSI = (si(idx1:idx2,:)');
        sSInt = (sint(idx1:idx2,:)');
                
        % Normalizing to trace of covariance
%         sNTS = sNTS./trace(sNTS'*sNTS);
%         sM = sM./trace(sM'*sM);
%         sSI = sSI./trace(sSI'*sSI);
%         sSInt = sSInt./trace(sSInt'*sSInt);
        
        % Using our function to get Power Spectrum
        pNTS(:,:,1+(k-1)*M+(n-1)) = PSD(Wnew'*sNTS,winOpt);
        pM(:,:,1+(k-1)*M+(n-1)) = PSD(Wnew'*sM,winOpt);
        pSI(:,:,1+(k-1)*M+(n-1)) = PSD(Wnew'*sSI,winOpt);
        pSInt(:,:,1+(k-1)*M+(n-1)) = PSD(Wnew'*sSInt,winOpt);
    end
end
% Creating average spectra
pNTS = squeeze(mean(pNTS,3));
pM = squeeze(mean(pM,3));
pSI = squeeze(mean(pSI,3));
pSInt = squeeze(mean(pSInt,3));

% Converting radian frequency to sampling
[~,f] = PSD(sNTS,winOpt);
f2 = f.*(512/(2*pi));

fig = figure;
word_pos = [0.4848, -0.3939];       % [x, y]
lw = 2;                             % Linewidth
for n = 1:N
    % Topographic map
    subplot(N,4,n*4-3)
    m = max(abs(Anew(:,n)));  % Normalization factor
    topoplot(Anew(:,n)./m,'channel_locations.loc');
    %text(word_pos(1),word_pos(2),num2str(Widx(n)),'FontWeight','bold');
    % Spectrum
    subplot(N,4,n*4+(-2:0))
    hold on
    plot(f2,pNTS(n,:),'b','LineWidth',lw)
    plot(f2,pM(n,:),'k','LineWidth',lw)
    plot(f2,pSI(n,:),'r','LineWidth',lw)
    plot(f2,pSInt(n,:),'g','LineWidth',lw)
    
    xlabel('Frequency [Hz]')
    ylabel('Amplitude')
    xlim([0,40])
    legend('NTS','M','SI','SInt','Location','Northeast')
    set(gcf,'WindowState','maximized')
    set(gca,'FontSize',22)
end