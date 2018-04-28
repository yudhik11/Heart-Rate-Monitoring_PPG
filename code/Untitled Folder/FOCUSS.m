function s = FOCUSS(y,Phi)

iterations = 2;
% resolution of spectrum
N = size(Phi,2);
% initialization of x
x = ones(N,1);
for it = 1:iterations
W_pk = diag(x);
q_k = MPinverse(Phi*W_pk)*y;
x = W_pk*q_k;

end
s = abs(x).^2;
end