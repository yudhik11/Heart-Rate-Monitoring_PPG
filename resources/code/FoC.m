function[y_new] =FoC(acc_data,y,Fs ,prevBPM ,sigma,MA_tol,BPM_tol)
% This function identifies the peaks that belong to MA.
% INPUTS:
% acc_data = the 3 acceleration data (x, y and z)
% y = components of a signal
% Fs = sample rate
% prevBPM = previous estimated HR
% sigma=ratio for which acceleration data will be considered
% MA_tol= the interval where the accelesration data and the PPG-signal
% data must coincide (MA_tolerance)h
% BPM_tol= the interval where the PPG signal peaks do not get
% filtered out (BPM_tolerance)
% OUTPUT:
% y_new=the filtered PPG signal.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
locs_MA = [];
index_MA = [];
locs_y = [];
PeakFilter=[];
N = 60*Fs;
BPM_tol_min=BPM_tol;
BPM_tol_plus=BPM_tol;
y_new=[];
f = (0:Fs/(N-1):Fs)*60; % define frequency axis
for i=1:length(acc_data(:,1)) 
   X(1,:) = abs(fft(acc_data(i,:),N)); % calculate FFT of acceleration
   % Make filter to remove frequencies outside human heart rate interval
   fmin = 0.6;
   Nmin = floor((fmin/Fs)h*N);
   fmax = 3;
   Nmax = ceil((fmax/Fs)*N);
   range1 = [Nmin Nmax];
   H = zeros(1,N);
   for j = range1(1):range1(2)
       H(j) = 1;
   end
   X = X.*H;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find peaks of acceleration data and apply sigma criterion and kurtosis
% criterion
[indV,indF] = findpeaks(X(1,:), SortStr , descend ); %find peaks
index_MA = indF(1:length(indF));
value_MA=indV(1:length(indV));
for criterion=1:length(value_MA) 
   if (value_MA(criterion) <= max(sigma*value_MA))
       index_MA(criterion) = 0;
   end
end
index_MA=index_MA(index_MA ̃=0);
K = kurtosis(X(1,:));
if(K>130)
    locs_MA = [locs_MA f(index_MA)];
end
end
locs_MA = unique(locs_MA); % Remove duplicates
emptiness = isempty(locs_MA);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%find peaks of components and filter them out after determined which peaks
%have to be filtered out
for i=1:length(y(:,1))
    Y(1,:) = abs(fft(y(i,:), N));
    Y(1,:) = Y.*H;
[ ~ ,index_y]=findpeaks(Y(1,1:250), SortStr , descend );
PeakFilter=ones(1,length(Y(1,:)));
locs_y(1,1:length(index_y))=f(1,index_y);
for l=1:length(f(1,index_y))
    %%initial situation also known as the deafult state
    if(prevBPM==0)
        if(emptiness == 0)
            for j=1:length(locs_MA)
                if(locs_y(1,l)>locs_MA(j)-MA_tol && locs_y(1,l)< ...
                        locs_MA(j)+MA_tol)
                    Filter = FilterPeak(Y,locs_y(1,l),prevBPM);
                    PeakFilter=Filter.*PeakFilter;
                end
            end
        end
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%non-default state
        for j=1:length(locs_MA)
            if(((locs_y(1,l)>locs_MA(j)-MA_tol && locs_y(1,l)< ...
                    locs_MA(j)+MA_tol)) && ((locs_y(1,l)< ...
                    prevBPM-BPM_tol_min | | ...
                    locs_y(1,l)>prevBPM+BPM_tol_plus)))
                Filter = FilterPeak(Y,locs_y(1,l),prevBPM);
                PeakFilter=Filter.*PeakFilter;
            end
        end
    end
end
Y=PeakFilter.*Y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Convert new PPG signal back to time domain
y_gefilerd = (ifft(Y));
if isempty(y_new)==1
    y_new=y_gefilerd;
else
    y_new=(y_new+y_gefilerd);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%
end