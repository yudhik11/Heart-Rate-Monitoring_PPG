function [curLoc] = discoverPeak(SSRsig, prevLoc)

    R3 = 40:200;
    [ ~, locs] = findPksInRange(SSRsig, R3);
    curLoc = findClosestPeak(prevLoc, locs);
end