function y = hankelize(X_group, Lp, Kp, N )
% This function calculates a time signal from a matrix
% INPUTS:
% X_group = grouped matrices
% Lp = minimum of L and K
% Kp = maximum of L and K
% N = length of signal
% OUTPUTS:
%
% y = reconstructed time signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    y=zeros(N,1);
    for k=0:Lp-2
        for m=1:k+1
            y(k+1)=y(k+1)+(1/(k+1))*X_group(m,k-m+2);
        end
    end
    
    for k=Lp-1:Kp-1
        for m=1:Lp
            y(k+1)=y(k+1)+(1/(Lp))*X_group(m,k-m+2);
        end
    end
    
    for k=Kp:N
        for m=k-Kp+2:N-Kp+1
            y(k+1)=y(k+1)+(1/(N-k))*X_group(m,k-m+2);
        end
    end
end