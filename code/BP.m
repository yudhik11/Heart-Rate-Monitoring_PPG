function [ y ] = BP( x, fs, BPM )
    %BP Summary of this function goes here
    % Detailed explanation goes here
    x = x;
    N = length(x);
    dt = 1/fs;
    t = dt*(0:(N-1));
    count1 = timeseries(x,t);
    %countmean = mean(count1);
    if BPM == 0
        interval = [0.6 3.5];
    else
        fbpm = BPM/60;
        interval = [fbpm - 0.3, fbpm + 0.3];
    end
    filteredSig = idealfilter(count1,interval, pass );
    y = filteredSig.data;
    % y=y ;
end