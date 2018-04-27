function[y new] =FoC(acc data,y,Fs ,prevBPM ,sigma,MA tol,BPM tol)
% This function identifies the peaks that belong to MA.
%
INPUTS:
% acc data = the 3 acceleration data (x, y and z)
% y = components of a signal
% Fs = sample rate
% prevBPM = previous estimated HR
% sigma=ratio for which acceleration data will be considered
% MA tol= the interval where the acceleration data and the PPG−signal
% data must coincide (MA tolerance)
% BPM tol= the interval where the PPG signal peaks do not get
% filtered out (BPM tolerance)
%
OUTPUT:
%
y new=the filtered PPG signal.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
locs MA = [];
index MA = [];
locs y = [];
PeakFilter=[];
N = 60∗Fs;
BPM tol min=BPM tol;
BPM tol plus=BPM tol;
y new=[];
f = (0:Fs/(N−1):Fs)∗60; % define frequency axis
for i=1:length(acc data(:,1))
X(1,:) = abs(fft(acc data(i,:),N)); % calculate FFT of acceleration
% Make filter to remove frequencies outside human heart rate interval
fmin = 0.6;
Nmin = floor((fmin/Fs)∗N);
fmax = 3;
Nmax = ceil((fmax/Fs)∗N);
range1 = [Nmin Nmax];
H = zeros(1,N);
for j = range1(1):range1(2)
H(j) = 1;
end
X = X.∗H;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find peaks of acceleration data and apply sigma criterion and kurtosis
% criterion
[indV,indF] = findpeaks(X(1,:), SortStr , descend ); %find peaks
index MA = indF(1:length(indF));
value MA=indV(1:length(indV));
for criterion=1:length(value MA)
if (value MA(criterion) <= max(sigma∗value MA))
index MA(criterion) = 0;
end
end
index MA=index MA(index MA ̃=0);
K = kurtosis(X(1,:));
if(K>130)
locs MA = [locs MA f(index MA)];
end
end
locs MA = unique(locs MA); % Remove duplicates
emptiness = isempty(locs MA);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%find peaks of components and filter them out after determined which peaks
%have to be filtered out
for i=1:length(y(:,1))
Y(1,:) = abs(fft(y(i,:), N));
Y(1,:) = Y.∗H;
[ ̃,index y]=findpeaks(Y(1,1:250), SortStr , descend );
PeakFilter=ones(1,length(Y(1,:)));
locs y(1,1:length(index y))=f(1,index y);
for l=1:length(f(1,index y))
%%initial situation also known as the deafult state
if(prevBPM==0)
if(emptiness == 0)
for j=1:length(locs MA)
if(locs y(1,l)>locs MA(j)−MA tol && locs y(1,l)< ...
locs MA(j)+MA tol)
Filter = FilterPeak(Y,locs y(1,l),prevBPM);
PeakFilter=Filter.∗PeakFilter;
end
end
end
else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%non−default state
for j=1:length(locs MA)
if(((locs y(1,l)>locs MA(j)−MA tol && locs y(1,l)< ...
locs MA(j)+MA tol)) && ((locs y(1,l)< ...
prevBPM−BPM tol min | | ...
locs y(1,l)>prevBPM+BPM tol plus)))
Filter = FilterPeak(Y,locs y(1,l),prevBPM);
PeakFilter=Filter.∗PeakFilter;
end
end
end
end
Y=PeakFilter.∗Y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Convert new PPG signal back to time domain
y gefilterd = (ifft(Y));
if isempty(y new)==1
y new=y gefilterd;
else
y new=(y new+y gefilterd);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%