function [ESD,f] = PSD(eeg,windowOption)
% First index og eeg is channel number, second index is time index.
% Normalize to trace/electrode sensitivity

L = size(eeg,2);

% Optional windowing of eeg signal

winf = eval(strcat('@',windowOption));  % Create function handle
w = window(winf,L)';                 % Create window of specified length
eeg = eeg.*w;                        % Window EEG signal


f = 0:2*pi/L:pi;            % Frequency axis of 
F = fft(eeg,[],2);          % Fourier transform along second dimension
F = F(:,1:length(f));       % Remove second half of FT

% Power spectrum:
ESD = ((abs(F)).^2)./L;
