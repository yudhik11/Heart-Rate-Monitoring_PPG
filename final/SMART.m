function [cur_location, BPM_cur, Trap_count, Lssr] = ...
SMART(sigWindow, prevLoc, prevBPM, Trap_count, N, Fs, Lssr)

    if (prevLoc > 0)
        [test_loc, test_BPM] = Periodogram(sigWindow, prevLoc, Fs, Lssr);
        if (test_loc == -1)
            [test_loc, test_BPM] = ANC( sigWindow, prevLoc, Fs, Lssr);
        end
    end

    if (prevLoc == -1 || test_loc == -1)
        % SSR
        [ ~, SSRsig] = SSR_JOSS(sigWindow, Fs, N);
        Lssr = length(SSRsig);
        % SPT
        [cur_location, BPM_cur, Trap_count] = ...
            SPT_JOSS(SSRsig, Fs, prevLoc, prevBPM, Trap_count);
    else
        BPM_cur = test_BPM;
        cur_location = test_loc;
    end
end