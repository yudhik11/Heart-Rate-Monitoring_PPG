function [BPM, s] = SSR(y, Fs, N)

    if (nargin == 2)
        % resolution is set to 1 BPM
        N = 60*Fs;
    end
    M = length(y);
    % construct fourier matrix
    Phi = zeros(M,N);
    complex_factor = 1i*2*pi/N;
    for m = 1:M
        for n = 1:N
            Phi(m,n) = exp(complex_factor*(m-1)*(n-1));
        end
    end
    % calculate BPM-axis
    BPM = 60*Fs/N*((1:N)-1);
    % construct sparse spectrum
    s = FOCUSS(y,Phi);
    % Band-pass frequencies in BPM
    BPM_bp = [40 200];
    % Band-pass spectrum
    s = BP(s, Fs, BPM_bp);
end