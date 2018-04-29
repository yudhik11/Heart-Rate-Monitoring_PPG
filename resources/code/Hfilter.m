function [ H ] = Hfilter( Fs, N )
% Simple bandpass filter that removes every frequency outside 0.6 and 3 Hz.
% INPUTS:
% Fs = sample frequency
% N = length of signal
% OUTPUTS:
% H = filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fmin = 0.6;
    Nmin = floor((fmin/Fs)*N);
    fmax = 3;
    Nmax = ceil((fmax/Fs)*N);
    range1 = [Nmin, Nmax];
    H = zeros(1,N);
    for j = range1(1):range1(2) %Make filter
        H(j) = 1;
    end
end