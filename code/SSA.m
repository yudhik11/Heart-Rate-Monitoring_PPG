function [yrecon, locs_MA] = SSA(x1, Fs, prevBPM, s)
    % This function decomposes a signal using SSA.
    %
    % INPUTS:
    %   x1 = input signal (including acceleration data)
    %   Fs = sample rate
    %   prevBPM = previous estimated HR
    %   s = number of PPG signal
    %
    % OUTPUTS:
    %   yrecon = reconstructed signal
    %   locs_MA = locations of the maximum peaks of the acceleration data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initialization
    L = 215; %window length
    N = length(x1(1,:)); %length of signal
    K = N-L+1;
    X = zeros(L,K);
    I = 9; % Amount of eigenvalues taken
    X_group = cell(I,L,K);
    % Put the PPG signal in x
    x = x1(s,:);
    % Step1 : Build trayectory matrix
    for i=1:L
        X(i,1:K) = x(1,i:i+K-1); % trajectory matrix
    end
    % Step 2: SVD
    S = X*X' ;
    [U,autoval] = eig(S);
    [d,i] = sort(-diag(autoval)); % sort eigenvalues to descending order
    d = -d;
    U = U(:,i); % sort left-singular vectors according to the eigenvalues
    V = (X ) * U; % calculate right-singular vectors
    % Step 3: Grouping
    Vt = V ;
    i = 1;
    groupnumber = 1;
    while(i <= I)
        % if two eigenvalues are close to each other, group them together
        if abs((d(i)-d(i+1))/sum_eig) < 0.02
            X_group{groupnumber} = U(:,i)*Vt(i,:) + U(:,i+1)*Vt(i+1,:);
            i = i+1;
        else
            X_group{groupnumber} = U(:,i)*Vt(i,:);
        end
        groupnumber = groupnumber+1;
        i = i+1;
    end
    % Step 4: Reconstruction
    Lp = min(L,K);
    Kp = max(L,K);
    % diagonal averaging
    y = zeros((groupnumber-1), N);
    for i=1:(groupnumber-1)
    y(i,:) = hankelize(X_group{i}, Lp, Kp, N);
    end
    % Remove MA
    % put acceleration data into a new matrix
    acc = x1(s+2:s+4, :);
    % determine components that have to be excluded from reconstruction
    [deleteComponents, locs_MA] = RoC(acc, y, Fs, prevBPM);
    yrecon = zeros(1,N);
    % Recontruct the signal without the MA components
    if(length(deleteComponents) == (groupnumber-1))
        deleteComponents = 0;
    end
    for i=1:(groupnumber-1)
        if( any(i == deleteComponents))
            yrecon = yrecon + y(i,:);
        end
    end
    %Temporal Difference
    % don t do temporal difference if the signal is still the original
    if(length(deleteComponents) >= (groupnumber-3))
        yrecon=diff(yrecon);
        yrecon=diff(yrecon);
    end
end