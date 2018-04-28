classdef signal 
    properties
        x;
        y;
        z;
        ppg2;
        ppg1;
    end
    methods
        function signalObj = signal(sig)
            signalObj.x = sig(3,:);
            signalObj.y = sig(4,:);
            signalObj.z = sig(5,:);
            signalObj.ppg1 = sig(1,:);
            signalObj.ppg2 = sig(2,:);
        end
    end
end