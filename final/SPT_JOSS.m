function [curLoc, curBPM, Trap_count] = SPT_JOSS(SSRsig, ...
Fs, prevLoc, prevBPM, Trap_count)

    N = length(SSRsig);
    
    % SPT paramas
    trig1 = 15;
    trig2 = 25;
    
    % initialization state
    if ( (prevLoc + prevBPM) == -2)
        if (prevLoc == -1)
            curLoc = find(SSRsig == max(SSRsig));
            curBPM = 60 * (curLoc - 1) / N * Fs;
        end
    else
        % set search range
        R1 = (prevLoc - trig1) : (prevLoc + trig1);
        [ ~, MA_locs] = findPksInRange(SSRsig, R1);
        totPeaks = length(MA_locs);
        if (totPeaks >= 1)
            % find closest peak
            curLoc = findClosestPeak(prevLoc, MA_locs);
            curBPM = 60 * (curLoc - 1) / N * Fs;
        else
            % increase search range
            R2 = (prevLoc - trig2) : (prevLoc + trig2);
            % find peaks in range2
            [pks, MA_locs] = findPksInRange(SSRsig, R2);
            totPeaks = length(MA_locs);
            if (totPeaks >= 1)
            % find maximum peak
                [ ~, maxIndex] = max(pks);
                curLoc = MA_locs(maxIndex);
                curBPM = 60 * (curLoc - 1) / N * Fs;
            else
                % choose prev BPM
                curLoc = prevLoc;
                curBPM = prevBPM;
            end
        end
    end
    % validation
    if (curLoc == prevLoc)
        Trap_count = Trap_count + 1;
        if (Trap_count > 2)
            % discover
            curLoc = discoverPeak(SSRsig, prevLoc);
            curBPM = 60 * (curLoc - 1) / N * Fs;
        end
    else
        Trap_count = 0;
    end
end