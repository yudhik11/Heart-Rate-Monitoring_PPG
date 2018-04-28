function [pks,locs] = findPksInRange(SSRsig, R)

    N = length(SSRsig);
    H = zeros(N,1);
    % filter for search range, handles cases when search range is negative
    H(R(R > 0)) = 1;
    % Band-pass filters spectrum to match search range
    SSRsig = SSRsig.*H;
    % returns peak values and locations
    [pks,locs] = findpeaks(SSRsig);
end