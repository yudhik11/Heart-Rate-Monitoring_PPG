function [curLoc, curBPM, Trap_count] = SPT_JOSS(SSRsig, Fs, ...
prevLoc, prevBPM, Trap_count)

    % parameters SPT
    delta1 = 15;
    delta2 = 25;
    N = length(SSRsig);
    % initialization state
    if ((prevLoc == -1 && prevBPM == -1))
        curLoc = find(SSRsig == max(SSRsig));
        curBPM = 60 * (curLoc - 1) / N * Fs;
    else
        % set search range
        R1 = (prevLoc - delta1) : (prevLoc + delta1);
        [ ~, locs] = findPksInRange(SSRsig, R1);
        numOfPks = length(locs);
    if (numOfPks >= 1)
        % find closest peak
        curLoc = findClosestPeak(prevLoc, locs);
        curBPM = 60 * (curLoc - 1) / N * Fs;
    else
        % increase search range
        R2 = (prevLoc - delta2) : (prevLoc + delta2);
        % find peaks in range2
        [pks, locs] = findPksInRange(SSRsig, R2);
        numOfPks = length(locs);
        if (numOfPks >= 1)
        % find maximum peak
            [ ~, maxIndex] = max(pks);
            curLoc = locs(maxIndex);
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