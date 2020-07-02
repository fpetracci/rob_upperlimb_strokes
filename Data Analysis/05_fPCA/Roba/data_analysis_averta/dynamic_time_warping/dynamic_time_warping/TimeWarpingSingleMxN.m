function [ outSignals ] = TimeWarpingSingleMxN(refSignals,inSignals)

    %s1 s2 M*Nvalues
    %s1 reference signals
    %s2 modifiable signals
    
    s1      = refSignals;
    s2      = inSignals; 
    rapp    = length(s2(1,:))/length(s1(1,:));
    tshtmp  = round(length(s2(1,:))/10);
    TShift  = round(linspace(-tshtmp,tshtmp,10));
    NShap   = linspace(0.4,1.1,10);
    ObjVal  = zeros(length(TShift),length(NShap));
    
    for i = 1:length(TShift(1,:))
        for j = 1:length(NShap(1,:))
            s1tmp = s1;
            s2tmp = s2;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%
            time     = 1 : length(s2tmp(1,:));
            nel      = length(time);
            timenew  = linspace(time(1),time(end),ceil(nel*NShap(j)));
            [M,~]    = size(s2tmp);
            s2tmptmp = s2tmp;
            s2tmp    = [];
            for k = 1:M
                tsr   = resample(timeseries(s2tmptmp(k,:),time),timenew);
                s2tmp = [s2tmp; tsr.data(:)'];
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%
            s2tmptmp = s2tmp;
            s2tmp = [];
            if TShift(i) >= 0
                for k = 1:M
                    s2tmp     = [s2tmp; [ones(1, TShift(i))*s2tmptmp(k,1) s2tmptmp(k,:)]];
                end
            elseif TShift(i) < 0
                for k = 1:M
                    s2tmp = [s2tmp; s2tmptmp(k,abs(TShift(i)):end)];
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%% Complete  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Ls1      = length(s1tmp(1,:));
            Ls2      = length(s2tmp(1,:));
            s2tmptmp = s2tmp;
            s2tmp    = [];
            if Ls1 > Ls2
                for k = 1:M
                    s2tmp     = [s2tmp; [s2tmptmp(k,:) ones(1,Ls1-Ls2)*s2tmptmp(k,end)]];
                end
            elseif Ls1 < Ls2
                for k = 1:M
                    s2tmp = [s2tmp; s2tmptmp(k,1:Ls1)];
                end
            else
                s2tmp = s2tmptmp;
            end
            matrix = zeros(1,M);
            for k = 1:M
                A 			= corrcoef([s1tmp(k,:)' s2tmp(k,:)']);
                matrix(1,k) = A(1,2);
            end
            ObjVal(i,j) = max(matrix);
        end
    end
    [~,I] = max(ObjVal(:));
    [I_row, I_col] = ind2sub(size(ObjVal),I);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    time     = 1 : length(s2(1,:));
    nel      = length(time);
    timenew  = linspace(time(1),time(end),ceil(nel*NShap(I_col)));
    [M,~]    = size(s2);
    s2tmp 	 = s2;
    s2       = [];
    for k = 1:M
        tsr   = resample(timeseries(s2tmp(k,:),time),timenew);
        s2    = [s2; tsr.data(:)'];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    s2tmp = s2;
    s2    = [];
    if TShift(I_row) >= 0
        for k = 1:M
            s2 = [s2; [ones(1, TShift(I_row))*s2tmp(k,1) s2tmp(k,:)]];
        end
    elseif TShift(I_row) < 0
        for k = 1:M
            s2 = [s2; s2tmp(k,abs(TShift(I_row)):end)];
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%% Complete %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ls1   = length(s1(1,:));
    Ls2   = length(s2(1,:));
    s2tmp = s2;
    s2    = [];
    if Ls1 > Ls2
        for k = 1:M
            s2     = [s2; [s2tmp(k,:) ones(1,Ls1-Ls2)*s2tmp(k,end)]];
        end
    elseif Ls1 < Ls2
        for k = 1:M
            s2 = [s2; s2tmp(k,1:Ls1)];
        end
    else
        s2 = s2tmp;
    end
    outSignals = s2;
end