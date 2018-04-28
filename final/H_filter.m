function [ H ] = H_filter( delta, BPM_max, N, oldLoc, StLi )

if oldLoc > 0
    Ndelta = (delta/BPM_max)*N;
    Ndelta = ceil(Ndelta);
    Nmin = oldLoc - Ndelta;
    Nmax = oldLoc + Ndelta;
    if Nmin <= 0 && Nmax > N
        range1 = 1:N;
    elseif Nmin <= 0
        range1 = 1:Nmax;
    elseif Nmax > N
        range1 = Nmin:N;
    else
        range1 = Nmin:Nmax;
    end
    
    if StLi == 1
        H = zeros(1,N);
    else
        H = zeros(N,1);
    end
    
    H(range1) = 1;
else %Just band pass from 40 to 190
    Lmin = floor((40/BPM_max)*N + 1);
    Lmax = ceil((190/BPM_max)*N + 1);
    range1 = Lmin:Lmax;
    if StLi == 1
        H = zeros(1,N);
    else
        H = zeros(N,1);
    end
    H(range1) = 1;
end
end