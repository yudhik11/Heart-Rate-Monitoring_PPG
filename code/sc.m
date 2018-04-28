load ../Project/Data/DATA_06_TYPE02.mat
L = length(sig);
for i=1:1%floor((x-1000)/250+1)
    x = sig(:,(i-1)*250+1:((i-1)*250) + 1000);
    figure; 
    plot(x(2,:));
    figure;
    plot(abs(fft(x(2,:))));
    y = x;
    y(2,:) = BP(x(2,:), 125, 0);
    [y1, locs] = SSA(y, 125, 68.7, 2);
    figure;plot(y1); 
    figure;plot(abs(fft(y1)));
    [curloc, curBPM, Trap] = SPT_JOSS(y1, 125, -1, -1, 0);
    curBPM
%     figure;  plot(y1);
end