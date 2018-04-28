classdef signal
    
    properties
ppg1;
ppg2;
x;
y;
z;
end
methods
function signalObj = signal(sig)
signalObj.ppg1 = sig(1,:);
signalObj.ppg2 = sig(2,:);
signalObj.x = sig(3,:);
signalObj.y = sig(4,:);
signalObj.z = sig(5,:);
end
end
end