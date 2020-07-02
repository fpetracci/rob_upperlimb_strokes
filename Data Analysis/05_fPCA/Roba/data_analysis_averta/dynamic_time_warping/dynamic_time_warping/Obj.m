function ObjVal = Obj(OptPar, Sref, Swarped)
OptPar;
TShift = OptPar(1);
NShap  = OptPar(2);

Swarped1 = Swarped;
Sref1 = Sref;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ Swarped1 ] = TS_temporal_shift( Swarped, TShift );

%%%%%%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ Swarped1 ] = TS_stretch( Swarped1, NShap );
% a = Sref1.data(:); 
% b = Swarped.data(:);
% c = Sref1.time;
% d = Swarped.time;
% whos a b c d

%%%%%%%%%%%%%%%%%%%%%%% Adding  Zeros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
larger_time = union(Sref1.time, Swarped1.time);
%figure;plot(Sref1.time);hold on;plot(Swarped.time);plot(larger_time,'*g');

%new_time_Sref1    = larger_time; 
%new_time_Swarped = larger_time;
% % Sref1.time(1)
% % Swarped.time(1)
% % Sref1.time
% % Swarped.time

initial_diff = Sref1.time(1)-Swarped1.time(1);
final_diff = Sref1.time(end)-Swarped1.time(end);

if Sref1.time(1) > Swarped1.time(1)
    time = Swarped1.time(1) : Sref1.time(1)-1;
    data = zeros(1,length(time));
    InitZeros = timeseries(data,time);
    %add to Sref1
	Sref1 = append(InitZeros,Sref1);
elseif Sref1.time(1) < Swarped1.time(1)
    time = Sref1.time(1) : Swarped1.time(1)-1;
    data = zeros(1,length(time));
    InitZeros = timeseries(data,time);
    %add to Swarped    
    Swarped1 = append(InitZeros,Swarped1);
end

if Sref1.time(end) > Swarped1.time(end)
    time = Swarped1.time(end) + 1 : Sref1.time(end);
    data = zeros(1,length(time));
    FinalZeros = timeseries(data,time);
    %add to Swarped
    Swarped1 = append(Swarped1,FinalZeros);
elseif Sref1.time(end) < Swarped1.time(end)
    time = Sref1.time(end)+1 : Swarped1.time(end);
    data = zeros(1,length(time));
    FinalZeros = timeseries(data,time);
    %add to Sref1  
    Sref1 = append(Sref1,FinalZeros);
end


% new_data_Sref1    = [zeros(1,max(0,initial_diff))';  Sref1.data(:);    zeros(1,max(0,-initial_diff))';];
% new_data_Swarped = [zeros(1,max(0,-initial_diff))'; Swarped.data(:); zeros(1,max(0,initial_diff))';];
% %whos new_data_Sref1 new_time_Sref1
% 
% Sref1_final    = timeseries(new_data_Sref1,    new_time_Sref1);
% Swarped_final = timeseries(new_data_Swarped, new_time_Swarped);
 t1 = Sref1.time;
 t2 = Swarped1.time;
% whos t1 t2

% numel(Sref1.time)
% numel(Swarped.time)
% numel(Sref1.data(:))
% numel(Swarped.data(:))
% Sref1.data(:)
% Swarped.data(:)
%figure;plot(Sref1.time,'o');hold on;plot(Swarped.time+0.1,'gd')
%figure;plot(Sref1.data(:),'o');hold on;plot(Swarped.data(:),'gd')
size(Sref1.data(:));
size(Swarped1.data(:));

diff = Sref1.data(:) - Swarped1.data(:);
ObjVal = norm(diff);
ObjVal;
end

