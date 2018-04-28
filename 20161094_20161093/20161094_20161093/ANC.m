function [ testLoc, testBPM ] = ANC( sigWindow, prevLoc, Fs, Lssr )
    %=======================================================================%
    % FUNCTION DESCRIPTION
    %
    %=======================================================================%
    %ANC is a determines the heart rate using adaptive noise cancellation
    %  , if the tests of quality and range are not met it returns 
    %   the values -1.
    %==========================================================%
    % INPUT/OUTPUT PARAMETERS
    %
    %==========================================================%
    % - Sigwindow is a matrix with the signal in its rows:
    %
    %   SigWindow[ECG, PPG1; PPG2; Ac1; Ac2; Ac3].
    %
    % - prevLoc is the location of the previous BPM value 
    % - Fs is the sampling rate.
    %
    % - Lssr is the length of the spectrum calculated by JOSS %
    % - testLoc and testBPM are the bin and value of the HR
    %
    % respectively.
    %
    %==========================================================%
    %Determine parameters
    %========================

    threshold = 7;
    filterorder = 74;
    step_size = 0.045;
    N = Lssr;
    BPM = 60*Fs/N*((1:N) - 1);
    BPM_max = BPM(end);
    %========================
    %Get the PPG signal and its spectrum
    %============================================
    ppg = (sigWindow(2,:) + sigWindow(1,:))./2;
    ppg = ppg - mean(ppg);
    spec = abs(fft(ppg, N));
    Sspec = size(spec,1);
    [ H ] = H_filter( 200, BPM_max, N, -1, Sspec );
    spec = spec.*H;

    %============================================
    % Calculate the quality of spec after H_filtering using kurtosis
    quality = kurtosis(spec);


    %====================================================================%
    %If the value of quality is over 20 it is categorized as being good enough
    %  for calculating the HR with ANC.
    %====================================================================%
    if quality > 20
        acc_data = sigWindow(3:5,:);
        [ clean_signal ] = LMS_sig(ppg,acc_data,filterorder,step_size);
        specLMS = abs(fft(clean_signal,N));
        StLi = size(specLMS, 1);
        H = H_filter( 14, BPM_max, N, prevLoc, StLi );
        specLMS = specLMS.*H;

        [ ~, testLoc] = max(specLMS);
        testBPM = BPM(testLoc);
        prevBPM = BPM(prevLoc);
    %============================================
    %Range test
    %============================================
        difference = abs(testBPM - prevBPM);
        if difference > threshold
            testLoc = -1;
            testBPM = -1;
        end
    %============================================
    else
        testLoc = -1;
        testBPM = -1;
    end
    %====================================================================%
end