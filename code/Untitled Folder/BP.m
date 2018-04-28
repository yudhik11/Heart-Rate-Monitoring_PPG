function [ SSRsig ] = BP( SSRsig, Fs, BPM_bp )

    N = length(SSRsig);
    f_lo = BPM_bp(1) / 60;
    f_hi = BPM_bp(2) / 60;
    R = floor(f_lo/Fs*N+1) : ceil(f_hi/Fs*N+1);
    H = zeros(N,1);
    H(R) = 1;
    SSRsig = SSRsig .* H;

end