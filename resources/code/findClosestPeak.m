function curLoc = findClosestPeak(prevLoc, locs)

    dif = abs(prevLoc - locs);
    % find the closest peak
    [ ~, index] = min(dif);
    % return bin of closest peak
    curLoc = locs(index);
end