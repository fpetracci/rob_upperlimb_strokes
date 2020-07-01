close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1 = 0:0.01:pi;

s1 = [sin(t1)];
s2 = [sin(2*t1(1:floor(end/2)))];
s1 = [zeros(1,100) sin(t1) zeros(1,500)];
s2 = [zeros(1,300) sin(2*t1(1:floor(end/2))) zeros(1,100)];

Ls1 = length(s1);
Ls2 = length(s2);

figure;
plot(s1,'d');
hold on
plot(s2,'r*');
legend('s1','s2')

%%%%%%%%%%%%%%%%%%%%%%%%%% Adding Zeros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SIGN1 = [s1 zeros(1,max(Ls1,Ls2)-Ls1)];
SIGN2 = [s2 zeros(1,max(Ls1,Ls2)-Ls2)];


figure;
plot(SIGN1,'d');
hold on
plot(SIGN2,'r*');
legend('s1NEW','s2NEW')

%%

TShift0 = 1;

NShap0 = 1;

OptPar0 = [TShift0 NShap0];
LB = [-Inf 0];
UB = [Inf Inf];
options = optimoptions('fmincon','MaxIter',Inf,'MaxFunEvals',Inf,'FunctionTolerance',10^-12,'Display','iter');%,'Algorithm','active-set')

%[OptPar, fval] = fmincon(@(OptPar) Obj(OptPar, times1, s1NEW, times2, s2NEW),OptPar0,[],[],[],[],[],[],[],options);
[OptPar, fval] = fmincon(@(OptPar) ObjNew(OptPar, SIGN1, SIGN2),OptPar0,[],[],[],[],LB,UB,[],options);
OptPar
TShift = OptPar(1);
NShap  = OptPar(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if TShift > 0
    SIGN2 = [zeros(1, ceil(TShift)) TShift];
elseif TShift < 0
    SIGN1 = [zeros(1, ceil(TShift)) SIGN1];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time = 1 : length(SIGN2);
nel = length(time);
ts = timeseries(SIGN2,time);
timenew = linspace(time(1),time(end),ceil(nel*NShap));
ts1 = resample(ts,timenew);
SIGN2 = ts1.data(:)';
%%%%%%%%%%%%%%%%%%%%%%%%%% Adding  Zeros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LSIGN1 = length(SIGN1);
LSIGN2 = length(SIGN2);
%whos SIGN1 SIGN2

SIGN1    = [SIGN1    zeros(1,max(LSIGN1,LSIGN2)-LSIGN1)];
SIGN2 = [SIGN2 zeros(1,max(LSIGN1,LSIGN2)-LSIGN2)];

figure;
plot(SIGN1,'d');
hold on
plot(SIGN2,'r*');
legend('s1NEW','s2NEW')


