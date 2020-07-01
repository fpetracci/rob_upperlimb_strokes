function [ s2_new ] = TimeWarpingSingle(s1,s2)


    %s1 reference signal
    %s2 modifiable signal
    
    rapp = length(s2)/length(s1);
    tshtmp = round(length(s2)/2);
    
    
    %TShift = round(linspace(-150,150,50));
    TShift = round(linspace(-tshtmp,tshtmp,100));
    %NShap  = linspace(0.5,2,100);
    NShap  = linspace(0.5,2,100);

    ObjVal = zeros(length(TShift),length(NShap));
    for i = 1:length(TShift)
        for j = 1:length(NShap)
            s1tmp = s1;
            s2tmp = s2;



            %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%
            time = 1 : length(s2tmp);
            nel = length(time);
            ts = timeseries(s2tmp,time);
            timenew = linspace(time(1),time(end),ceil(nel*NShap(j)));
            ts1 = resample(ts,timenew);
            s2tmp = ts1.data(:)';
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%
            if TShift(i) >= 0
                s2tmp = [ones(1, TShift(i))*s2tmp(1) s2tmp];
            elseif TShift(i) < 0
                s2tmp = s2tmp(abs(TShift(i)):end);
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Ls1 = length(s1tmp);
            Ls2 = length(s2tmp);
            %whos s1tmp s2tmp

            if Ls1 > Ls2
                %s1tmp = s1tmp(1:length(s2tmp));
                s2tmp = [s2tmp zeros(1,Ls1-Ls2)];
            elseif Ls1 < Ls2
                s2tmp = s2tmp(1:length(s1tmp));
            end

            diff = s1tmp - s2tmp;
            ObjVal(i,j) = norm(diff);
            %ObjVal(i,j)=dtw(s1tmp,s2tmp,50);
        end
    end

    [~,I] = min(ObjVal(:));
    [I_row, I_col] = ind2sub(size(ObjVal),I);


    %%
TShift(I_row)
NShap(I_col)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    time = 1 : length(s2);
    nel = length(time);
    ts = timeseries(s2,time);
    timenew = linspace(time(1),time(end),ceil(nel*NShap(I_col)));
    ts1 = resample(ts,timenew);
    s2 = ts1.data(:)';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if TShift(I_row) >= 0
        s2 = [ones(1, TShift(I_row))*s2(1) s2];
    elseif TShift(I_row) < 0
        %s2 = s2(-TShift(I_row):end);
        s2 = s2(abs(TShift(I_row)):end);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%% Adding  Zeros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ls1 = length(s1);
    Ls2 = length(s2);
    %whos s1 s2

    if Ls1 > Ls2
        %s1 = s1(1:length(s2));
        s2 = [s2 s2(end)*ones(1,round(Ls1-Ls2))];
    elseif Ls1 < Ls2
        s2 = s2(1:length(s1));
    end
    
    s2_new = s2;
end