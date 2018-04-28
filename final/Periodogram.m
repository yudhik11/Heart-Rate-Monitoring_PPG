function [ testLoc, BMP_test ] = Periodogram( sigWindow, prevLoc, Fs, Lssr )

    acc = sqrt( sigWindow(3,:).^2 + ...
                sigWindow(4,:).^2 + ...
                sigWindow(5,:).^2);
    
    quality = max(acc);
    quality = quality*(rms(acc)^2);
    
    if (quality < 15)
        N = 2^10;
        BPM = 60*Fs/N*((1:N) - 1);
        BPM_max = BPM(end);
        threshold = [10 40];
        
        ppg = (sigWindow(1,:) + sigWindow(2,:))./2;
        ppg = ppg - mean(ppg);
        spec = abs(fft(ppg, N));
        sspec = spec;
        Sspec = size(sspec,1);
        [H] = H_filter(200, BPM_max, N, -1, Sspec);
        spec = spec.*H;
       
        [ ~, ind] = max(spec);
        BMPt_test = BPM(ind);
        BMP_test = BMPt_test
        testLoc = round((BMP_test*Lssr/(60*Fs)) + 1);
        ssr_BPM = 60*Fs/Lssr*((1:Lssr) - 1);
        ssr_BMP1 = ssr_BPM;
        prev_BPM = ssr_BPM(prevLoc);
        BMP_test = ssr_BPM(testLoc);
        
        if (quality < 1)
           TH = threshold(2);
        else
            TH = threshold(1);
        end
        
        difference = abs(BMP_test - prev_BPM);
        
        if (difference > TH)
            testLoc = -1;
            BMP_test = -1;
        end
        
    else
        testLoc = -1;
        BMP_test = -1;
    end
end