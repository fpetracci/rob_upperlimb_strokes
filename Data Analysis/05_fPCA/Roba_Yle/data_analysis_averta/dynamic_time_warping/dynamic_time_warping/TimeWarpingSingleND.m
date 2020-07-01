function [ s2_new ] = TimeWarpingSingleND(s1,s2)

    %s1 s2 7*Nvalues
    %s1 reference signals
    %s2 modifiable signals
    
    rapp = length(s2(1,:))/length(s1(1,:));
    tshtmp = round(length(s2(1,:))/10);
    
    TShift = round(linspace(-tshtmp,tshtmp,10));
    NShap  = linspace(0.4,1.1,10);


    ObjVal = zeros(length(TShift),length(NShap));
    
    for i = 1:length(TShift(1,:))
        for j = 1:length(NShap(1,:))
            s1tmp = s1;
            s2tmp = s2;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%
            time = 1 : length(s2tmp(1,:));
            nel = length(time);
            ts1 = timeseries(s2tmp(1,:),time); ts2 = timeseries(s2tmp(2,:),time); ts3 = timeseries(s2tmp(3,:),time); ts4 = timeseries(s2tmp(4,:),time); ts5 = timeseries(s2tmp(5,:),time); ts6 = timeseries(s2tmp(6,:),time); ts7 = timeseries(s2tmp(7,:),time); 
            timenew = linspace(time(1),time(end),ceil(nel*NShap(j)));
            ts1r = resample(ts1,timenew); ts2r = resample(ts2,timenew); ts3r = resample(ts3,timenew); ts4r = resample(ts4,timenew); ts5r = resample(ts5,timenew); ts6r = resample(ts6,timenew); ts7r = resample(ts7,timenew); 
            %s2tmp(1,:) = ts1r.data(:)'; s2tmp(2,:) = ts2r.data(:)'; s2tmp(3,:) = ts3r.data(:)'; s2tmp(4,:) = ts4r.data(:)'; s2tmp(5,:) = ts5r.data(:)'; s2tmp(6,:) = ts6r.data(:)'; s2tmp(7,:) = ts7r.data(:)'; 
            s2tmp = [ts1r.data(:)'; ts2r.data(:)'; ts3r.data(:)'; ts4r.data(:)'; ts5r.data(:)'; ts6r.data(:)'; ts7r.data(:)';];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%
            if TShift(i) >= 0
                tmpv1 = [ones(1, TShift(i))*s2tmp(1,1) s2tmp(1,:)]; tmpv2 = [ones(1, TShift(i))*s2tmp(2,1) s2tmp(2,:)]; tmpv3 = [ones(1, TShift(i))*s2tmp(3,1) s2tmp(3,:)]; tmpv4 = [ones(1, TShift(i))*s2tmp(4,1) s2tmp(4,:)]; tmpv5 = [ones(1, TShift(i))*s2tmp(5,1) s2tmp(5,:)]; tmpv6 = [ones(1, TShift(i))*s2tmp(6,1) s2tmp(6,:)]; tmpv7 = [ones(1, TShift(i))*s2tmp(7,1) s2tmp(7,:)]; 
                s2tmp = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6; tmpv7];
            elseif TShift(i) < 0
                s2tmp = [s2tmp(1,abs(TShift(i)):end); s2tmp(2,abs(TShift(i)):end); s2tmp(3,abs(TShift(i)):end); s2tmp(4,abs(TShift(i)):end); s2tmp(5,abs(TShift(i)):end); s2tmp(6,abs(TShift(i)):end); s2tmp(7,abs(TShift(i)):end)];
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%% Complete  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Ls1 = length(s1tmp(1,:));
            Ls2 = length(s2tmp(1,:));
            %whos s1tmp s2tmp

            if Ls1 > Ls2
                tmpv1 = [s2tmp(1,:) ones(1,Ls1-Ls2)*s2tmp(1,end)]; tmpv2 = [s2tmp(2,:) ones(1,Ls1-Ls2)*s2tmp(2,end)]; tmpv3 = [s2tmp(3,:) ones(1,Ls1-Ls2)*s2tmp(3,end)]; tmpv4 = [s2tmp(4,:) ones(1,Ls1-Ls2)*s2tmp(4,end)]; tmpv5 = [s2tmp(5,:) ones(1,Ls1-Ls2)*s2tmp(5,end)]; tmpv6 = [s2tmp(6,:) ones(1,Ls1-Ls2)*s2tmp(6,end)]; tmpv7 = [s2tmp(7,:) ones(1,Ls1-Ls2)*s2tmp(7,end)]; 
                s2tmp = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6; tmpv7];
            elseif Ls1 < Ls2
                %s2tmp(1,:) = s2tmp(1,1:Ls1); s2tmp(2,:) = s2tmp(2,1:Ls1); s2tmp(3,:) = s2tmp(3,1:Ls1); s2tmp(4,:) = s2tmp(4,1:Ls1); s2tmp(5,:) = s2tmp(5,1:Ls1); s2tmp(6,:) = s2tmp(6,1:Ls1); s2tmp(7,:) = s2tmp(7,1:Ls1); 
                s2tmp = [s2tmp(1,1:Ls1); s2tmp(2,1:Ls1); s2tmp(3,1:Ls1); s2tmp(4,1:Ls1); s2tmp(5,1:Ls1); s2tmp(6,1:Ls1); s2tmp(7,1:Ls1)];
            end
            
            diff = zeros(7,1);
            diff(1) = norm(s1tmp(1,:)/max(s1tmp(1,:)) - s2tmp(1,:)/max(s2tmp(1,:))); diff(2) = norm(s1tmp(2,:)/max(s1tmp(2,:)) - s2tmp(2,:)/max(s2tmp(2,:))); 
            diff(3) = norm(s1tmp(3,:)/max(s1tmp(3,:)) - s2tmp(3,:)/max(s2tmp(3,:))); diff(4) = norm(s1tmp(4,:)/max(s1tmp(4,:)) - s2tmp(4,:)/max(s2tmp(4,:)));
            diff(5) = norm(s1tmp(5,:)/max(s1tmp(5,:)) - s2tmp(5,:)/max(s2tmp(5,:))); diff(6) = norm(s1tmp(6,:)/max(s1tmp(6,:)) - s2tmp(6,:)/max(s2tmp(6,:))); 
            diff(7) = norm(s1tmp(7,:)/max(s1tmp(7,:)) - s2tmp(7,:)/max(s2tmp(7,:))); 
            %ObjVal(i,j) = norm(diff);
            %ObjVal(i,j) = norm(diff(3));
            A1 = [s1tmp(1,:)' s2tmp(1,:)'];A2 = [s1tmp(2,:)' s2tmp(2,:)'];A3 = [s1tmp(3,:)' s2tmp(3,:)'];
            A4 = [s1tmp(4,:)' s2tmp(4,:)'];A5 = [s1tmp(5,:)' s2tmp(5,:)'];A6 = [s1tmp(6,:)' s2tmp(6,:)'];A7 = [s1tmp(7,:)' s2tmp(7,:)'];
            matrix1 = corrcoef(A1);matrix2 = corrcoef(A2);matrix3 = corrcoef(A3);matrix4 = corrcoef(A4);matrix5 = corrcoef(A5);matrix6 = corrcoef(A6);matrix7 = corrcoef(A7);
            %ObjVal(i,j) = matrix4(1,2);
            %ObjVal(i,j) = norm([matrix1(1,2) matrix2(1,2) matrix3(1,2) matrix4(1,2) matrix5(1,2) matrix6(1,2) matrix7(1,2)]);
            ObjVal(i,j) = max([matrix1(1,2) matrix2(1,2) matrix3(1,2) matrix4(1,2) matrix5(1,2) matrix6(1,2) matrix7(1,2)]);
            %ObjVal(i,j)=dtw(s1tmp,s2tmp,50);
        end
    end

    [~,I] = max(ObjVal(:));
    [I_row, I_col] = ind2sub(size(ObjVal),I);


    %%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    time = 1 : length(s2(1,:));
    nel = length(time);
    ts1 = timeseries(s2(1,:),time); ts2 = timeseries(s2(2,:),time); ts3 = timeseries(s2(3,:),time); ts4 = timeseries(s2(4,:),time); ts5 = timeseries(s2(5,:),time); ts6 = timeseries(s2(6,:),time); ts7 = timeseries(s2(7,:),time); 
    timenew = linspace(time(1),time(end),ceil(nel*NShap(I_col)));
    ts1r = resample(ts1,timenew); ts2r = resample(ts2,timenew); ts3r = resample(ts3,timenew); ts4r = resample(ts4,timenew); ts5r = resample(ts5,timenew); ts6r = resample(ts6,timenew); ts7r = resample(ts7,timenew); 
    %s2(1,:) = ts1r.data(:)'; s2(2,:) = ts2r.data(:)'; s2(3,:) = ts3r.data(:)'; s2(4,:) = ts4r.data(:)'; s2(5,:) = ts5r.data(:)'; s2(6,:) = ts6r.data(:)'; s2(7,:) = ts7r.data(:)';     
    s2 = [ts1r.data(:)'; ts2r.data(:)'; ts3r.data(:)'; ts4r.data(:)'; ts5r.data(:)'; ts6r.data(:)'; ts7r.data(:)';];
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if TShift(I_row) >= 0
        tmpv1 = [ones(1, TShift(I_row))*s2(1,1) s2(1,:)]; tmpv2 = [ones(1, TShift(I_row))*s2(2,1) s2(2,:)]; tmpv3 = [ones(1, TShift(I_row))*s2(3,1) s2(3,:)]; tmpv4 = [ones(1, TShift(I_row))*s2(4,1) s2(4,:)]; tmpv5 = [ones(1, TShift(I_row))*s2(5,1) s2(5,:)]; tmpv6 = [ones(1, TShift(I_row))*s2(6,1) s2(6,:)]; tmpv7 = [ones(1, TShift(I_row))*s2(7,1) s2(7,:)]; 
        s2 = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6; tmpv7];
    elseif TShift(I_row) < 0
        s2 = [s2(1,abs(TShift(I_row)):end); s2(2,abs(TShift(I_row)):end); s2(3,abs(TShift(I_row)):end); s2(4,abs(TShift(I_row)):end); s2(5,abs(TShift(I_row)):end); s2(6,abs(TShift(I_row)):end); s2(7,abs(TShift(I_row)):end)];
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%% Complete %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ls1 = length(s1(1,:));
    Ls2 = length(s2(1,:));

    if Ls1 > Ls2
        tmpv1 = [s2(1,:) ones(1,Ls1-Ls2)*s2(1,end)]; tmpv2 = [s2(2,:) ones(1,Ls1-Ls2)*s2(2,end)]; tmpv3 = [s2(3,:) ones(1,Ls1-Ls2)*s2(3,end)]; tmpv4 = [s2(4,:) ones(1,Ls1-Ls2)*s2(4,end)]; tmpv5 = [s2(5,:) ones(1,Ls1-Ls2)*s2(5,end)]; tmpv6 = [s2(6,:) ones(1,Ls1-Ls2)*s2(6,end)]; tmpv7 = [s2(7,:) ones(1,Ls1-Ls2)*s2(7,end)]; 
        s2 = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6; tmpv7];
    elseif Ls1 < Ls2
        s2 = [s2(1,1:Ls1); s2(2,1:Ls1); s2(3,1:Ls1); s2(4,1:Ls1); s2(5,1:Ls1); s2(6,1:Ls1); s2(7,1:Ls1)];

    end
    
    s2_new = s2;
end