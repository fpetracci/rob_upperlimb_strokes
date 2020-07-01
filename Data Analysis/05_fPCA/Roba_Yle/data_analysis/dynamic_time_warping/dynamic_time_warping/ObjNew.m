function ObjVal = ObjNew(OptPar, Sref1, Swarped)
OptPar;
TShift = OptPar(1);
NShap  = OptPar(2);

%Swarped = Swarped1;
Sref = Sref1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if TShift > 0
    Swarped = [zeros(1, ceil(TShift)) TShift];
elseif TShift < 0
    Sref = [zeros(1, ceil(TShift)) Sref];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time = 1 : length(Swarped);
nel = length(time);
ts = timeseries(Swarped,time);
timenew = linspace(time(1),time(end),ceil(nel*NShap));
ts1 = resample(ts,timenew);
Swarped = ts1.data(:)';

%%%%%%%%%%%%%%%%%%%%%%%%%% Adding  Zeros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LSref = length(Sref);
LSwarped = length(Swarped);
%whos Sref Swarped

Sref    = [Sref    zeros(1,max(LSref,LSwarped)-LSref)];
Swarped = [Swarped zeros(1,max(LSref,LSwarped)-LSwarped)];
%whos Sref Swarped
diff = Sref - Swarped;

ObjVal = norm(diff);
%ObjVal
end

