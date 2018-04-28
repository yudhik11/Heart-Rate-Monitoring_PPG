function [ clean_signal ] = LMS_sig(signal,acc_data,k,step_size)
    temp = zeros(1,length(signal))';
    mu = step_size; % step size
    lms2 = dsp.LMSFilter('Length',k, ...
    'Method','Normalized LMS',...
    'StepSizeSource','Input port', ...
    'WeightsOutputPort',false);
    for i = 1:3
    x = acc_data(i,:)';
    d = signal';
    [~, err] = step(lms2,x,d,mu);
    temp = temp+err;
    end
    clean_signal = temp;
end