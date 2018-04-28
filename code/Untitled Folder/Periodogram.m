function [ testLoc, testBPM ] = Periodogram( sigWindow, prevLoc, Fs, Lssr )

acc = sqrt( sigWindow(4,:).^2 + sigWindow(5,:).^2 + sigWindow(6,:).^2);
quality = (rms(acc)^2)*max(acc);

if (quality < 15)
%Initialize parameters
%=========================
threshold = [10 40];
N = 2^10;
BPM = 60*Fs/N*((1:N) - 1);
BPM_max = BPM(end);
%=========================
%Get the PPG signal and its spectrum
%============================================
ppg = sigWindow(2,:);
ppg = ppg - mean(ppg);
spec = abs(fft(ppg, N));
Sspec = size(spec,1);
[ H ] = H_filter( 200, BPM_max, N, -1, Sspec );
spec = spec.*H;
%============================================
%Determine the previous and current BPM
%============================================
[ ~, ind] = max(spec);
testBPM = BPM(ind);
testLoc = round(testBPM*Lssr/(60*Fs) + 1);
BPMssr = 60*Fs/Lssr*((1:Lssr) - 1);
testBPM = BPMssr(testLoc);
prevBPM = BPMssr(prevLoc);
%============================================
%Range test
%============================================
difference = abs(testBPM - prevBPM);
if quality < 1
TH = threshold(2);
else
TH = threshold(1);
end
if difference > TH
testLoc = -1;
testBPM = -1;
end
%============================================
else
testLoc = -1;
testBPM = -1;
end
end