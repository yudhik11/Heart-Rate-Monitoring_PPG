function [ curLoc, curBPM, Trap_count, Lssr ] = SMART( sigWindow, ...
prevLoc, prevBPM, Trap_count, N, Fs, Lssr )112.5000  112.5000  112.5000  112.5000  112.5000  112.5000  112.5000  112.5000

  Columns 37 through 48


    if prevLoc > 0
        [ testLoc, testBPM ] = Periodogram( sigWindow, prevLoc, ...
            Fs, Lssr );
    end

    if prevLoc > 0 && testLoc == -1
        [ testLoc, testBPM ] = ANC( sigWindow, prevLoc, Fs, Lssr);
    end

    if prevLoc == -1 || testLoc == -1
        %====================================================%
        % JOSS
        %====================================================%
        % SSR
        [ ~, SSRsig] = SSR_JOSS(sigWindow, Fs, N);
        Lssr = length(SSRsig);
        % SPT
        [curLoc, curBPM, Trap_count] = SPT_JOSS(SSRsig, ...
        Fs, prevLoc, prevBPM, Trap_count);
        %=====================================================%
    else
        curLoc = testLoc;
        curBPM = testBPM;
    end
end