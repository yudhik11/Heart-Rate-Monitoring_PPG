function [ Sig_filtered ] = PeakBandpassFilter( Sig,loc )
% This function is written in order to filter indexwise the peaks out
% INPUTS:
% Sig:Signal in the frequency domain
% Loc:location of the peak
%
% OUTPUTS:
% Sig_filtered: indices that need to be zero 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z=zeros(1,length(Sig));
rechterSchuiver=loc;
while(Sig(rechterSchuiver) >Sig(rechterSchuiver+1) ...
        && rechterSchuiver <= length(Sig))
    rechterSchuiver=rechterSchuiver+1;
end
linkerSchuiver = loc;
while(Sig(linkerSchuiver) >Sig(linkerSchuiver+1) && rechterSchuiver >= 0)
    Z(linkerSchuiver)=1;
    linkerSchuiver=linkerSchuiver-1;
end
Sig=Z.*Sig;
Sig_filtered=Sig;
end