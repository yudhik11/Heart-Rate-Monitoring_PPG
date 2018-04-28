function [BPM, SSRsig, S, C] = SSR_JOSS(y, Fs, N)

    if (nargin == 2)
        % resolution is set to 1 BPM
        N = 60*Fs;
    end
    
    sigY = signal(y);
    Y = [sigY.ppg1; sigY.x; sigY.y; sigY.z];
    % Y must be M x L
    Y = transpose(Y);
    L = size(Y,2);
    S = zeros(N,L);
    for i = 1:L
        [BPM, SS] = SSR(Y(:,i), Fs, N);
        % normalize spectra
        SS = SS / max(SS);
        S(:,i) = SS;
    end
    aggression = 0.99;
    C = zeros(1,N);
    SSRsig = S(:,1);
    for i = 1:length(BPM)
        % max of acceleration at f_i
        C(i) = max([S(i,2),S(i,3),S(i,4)]);
        % spectral subtraction
        SSRsig(i) = SSRsig(i) - aggression*C(i);
    end
    % set values smaller than 1/5-th of the max to 0
    p_max = max(SSRsig);
    SSRsig(SSRsig < p_max / 5) = 0;
end