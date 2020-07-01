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

% figure;
% plot(s1,'d');
% hold on
% plot(s2,'r*');
% legend('s1','s2')

%%%%%%%%%%%%%%%%%%%%%%%%%% Adding Zeros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s1NEW = [s1 zeros(1,max(Ls1,Ls2)-Ls1)];
s2NEW = [s2 zeros(1,max(Ls1,Ls2)-Ls2)];

Range = length(s2NEW);

%s1NEW = [s1 zeros(1,max(Ls1,Ls2)-Ls1)] + 0.05*rand(1,Range);
%s2NEW = [s2 zeros(1,max(Ls1,Ls2)-Ls2)] + 0.05*rand(1,Range);


times1 = 0 : Range-1;
times2 = 0 : Range-1;

SIGN1 = timeseries(s1NEW,times1);
SIGN2 = timeseries(s2NEW,times2);
%SIGN1.Time = SIGN1.Time -50;

figure;
plot(SIGN1,'d');
hold on
plot(SIGN2,'r*');
legend('s1NEW','s2NEW')



% SIGN3 = resample(SIGN1,times1-100);
% SIGN4 = SIGN1;
% SIGN4.Time = times1-100;
% figure;
% plot(SIGN3,'y*');
% hold on
% plot(SIGN4,'k*');
% 
% 
% 
% figure
% diff = SIGN1-SIGN2;
% plot(diff,'g*');

%%

TShift0 = 0;

NShap0 = 1;

OptPar0 = [TShift0 NShap0];
LB = [-Inf 0];
UB = [Inf Inf];
options = optimoptions('fmincon','MaxIter',Inf,'MaxFunEvals',Inf,'FunctionTolerance',10^-12,'Display','iter');%,'Algorithm','active-set')

%[OptPar, fval] = fmincon(@(OptPar) Obj(OptPar, times1, s1NEW, times2, s2NEW),OptPar0,[],[],[],[],[],[],[],options);
[OptPar, fval] = fmincon(@(OptPar) Obj(OptPar, SIGN1, SIGN2),OptPar0,[],[],[],[],LB,UB,[],options);


Swarped = TS_temporal_shift(SIGN2, OptPar(1));

figure;
plot(SIGN1,'d');
hold on
plot(Swarped,'r*');
legend('s1NEW','s2NEW')

Swarped = TS_stretch( Swarped, OptPar(2) );

figure;
plot(SIGN1,'d');
hold on
plot(Swarped,'r*');
legend('s1NEW','s2NEW')

%%
% % % % % % % % % close all
% % % % % % % % % clear all
% % % % % % % % % clc
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % dat = [1 1 2 2 3 3 4 4 5 5];
% % % % % % % % % time = 1:10;
% % % % % % % % % ts = timeseries(dat,time);
% % % % % % % % % ts_sh = ts;
% % % % % % % % % ts_sh.time = ts_sh.time-3;
% % % % % % % % % figure;plot(ts,'*');hold on;plot(ts_sh,'r*')
% % % % % % % % % 
% % % % % % % % % larger_time = union(ts.time, ts_sh.time);
% % % % % % % % % 
% % % % % % % % % ts1 = ts;
% % % % % % % % % new_time_ts = larger_time; 
% % % % % % % % % 
% % % % % % % % % initial_diff = ts.time(1)-ts_sh.time(1);
% % % % % % % % % final_diff = ts.time(end)-ts_sh.time(end);
% % % % % % % % % 
% % % % % % % % % new_data_ts = [zeros(1,max(0,initial_diff))'; ts.data(:); zeros(1,max(0,-initial_diff))';];
% % % % % % % % % new_data_ts_sh = [zeros(1,max(0,-initial_diff))'; ts.data(:); zeros(1,max(0,initial_diff))';];
% % % % % % % % % 
% % % % % % % % % disp('aaa')
% % % % % % % % % 
% % % % % % % % % %ts1.time = larger_time; 
% % % % % % % % % disp('aaa')
% % % % % % % % % 
% % % % % % % % % whos new_data_ts new_data_ts_sh larger_time
% % % % % % % % % ts_final = timeseries(new_data_ts,larger_time);
% % % % % % % % % 
% % % % % % % % % ts_sh_final = timeseries(new_data_ts_sh,larger_time);
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % figure;plot(ts_final,'*');hold on;plot(ts_sh_final,'r*')
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % diff = ts_final - ts_sh_final;
% % % % % % % % % 
% % % % % % % % % figure;plot(diff,'g*')



