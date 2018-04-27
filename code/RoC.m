function [deleteComponents, locs_MA] = RoC(acc_data, y, Fs ,...
    prevBPM)
% This function identifies the components that belong to MA.
%
% INPUTS:
% acc_data = the 3 acceleration data (x, y and z)
% y = components of a signal
% Fs = sample rate
% prevBPM = previous estimated HR
%
% OUTPUTS:
%
% deleteComponents = a list containing the numbers of the components
% that have to be excluded from reconstruction
% locs_MA = locations of the maximum peaks of the acceleration data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
locs_MA = [];
index_MA = [];
locs_y = zeros(1,length(y(:,1)));
deleteComponents = [];
N = 60*Fs;
MA_tol= 5;
BPM_tol = 11;
f = (0:Fs/(N-1):Fs)*60; % define frequency axis

% Find MA peaks

for i=1:length(acc_data(:,1))
    X(1,:) = abs(fft(acc_data(i,:),N)); % calculate FFT of acceleration
    X(1,:) = X(1,:)/max(X(1,:)); % normalize the signal
    H = Hfilter(Fs,N); % create filter
    X = X.*H; % remove frequencies outside humanly possible heart rates
    K = kurtosis(X(1,:));
    % if signal is not noisy, find 3 peaks that are larger than
    % 50% of the maximum peak.
    if(K>130)
        [pks,index_MA] = findpeaks(X, sortStr ,descend );
        for m=1:3
            if pks(m) >= 0.5
                % put the locations of the peaks in a vector
                locs_MA = [locs_MA, f(index_MA(m))];
            end
        end
    end
end
locs_MA = unique(locs_MA); % remove duplicates
emptiness = isempty(locs_MA); % check if there are peaks
k = 1;
max HR = 210;
% Determine the components that have to be removed
for i=1:length(y(:,1))
    Y(1,:) = abs(fft(y(i,:), N)); % calculate FFT of the component
    [something, index y] = max(Y(1,1:max HR)); % find the biggest peak
    locs_y(i) = f(1,index y); % find the frequency of the biggest peak
    % if there is no previous estimate, remove all components that have a
    % peak at the frequencies of the MA peaks
    if(prevBPM<=0)
        if(emptiness == 0)
            for j=1:length(locs_MA)
                if(locs_y(i) > locs_MA(j) - MA_tol && locs_y(i) < ...
                        locs_MA(j) + MA_tol)
                    deleteComponents(k)=0;
                    k=k+1;
                end
            end
        end
    % else remove the components that have a peak at the frequencies of the
    % MA peaks, except when they re near the frequency of the previous
    % estimate of the HR
    else
        if(locs_y(i) < (prevBPM-(BPM_tol*4)) | | locs_y(i) > ...
                (prevBPM+(BPM_tol*4)))
            deleteComponents(k)=i;
            k=k+1;
        else
            for j=1:length(locs_MA)
                if(locs_y(i) > locs_MA(j) - MA_tol && locs_y(i) < locs_MA(j)...
                        + MA_tol && (locs_y(i) < prevBPM -(BPM_tol) | | ...
                        locs_y(i) > prevBPM + (BPM_tol)))
                    deleteComponents(k)=i;
                    k=k+1;
                end
            end
        end
    end
end
deleteComponents = unique(deleteComponents); % remove duplicates
end