%%%%%%%%%%%%%%%%%%%%%%%%%% REFERENCES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "Exact indexing of dynamic time warping" Eamonn Keogh, Chotirat Ann Ratanamahatana
% "Multi-Dimensional Dynamic Time Warping for Gesture Recognition" G.A. ten Holt M.J.T. Reinders E.A. Hendriks

close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1 = 0:0.01:5*pi;

s1 = cos(t1)';

%s2 = chirp(t1,0.1,5*pi,0.3)';  
 
s2 = resample(s1,1,3);


% %s22 = resample(s1,3,2);
% %s2 = [s21(1:11) ;s22(25:end)];
% 
% s1 = [ones(200,1); s1];
% 
% s1 = [s1;zeros(200,1)];
% s2 = [s2;zeros(200,1)];
% 
% s2 = s2 + rand(length(s2),1)*0.1;
% s1 = s1 + rand(length(s1),1)*0.1;

%s1 = [s1; zeros(100,1)+s1(end)]; 
%s2 = [s2; zeros(100,1)+s1(end)]; 
 
%s2 = s2 + [0:length(s2)-1]'/(3*length(s2));


% % % % % % % % % EstimatedQTask9 = load('EstimatedAngles/EstimatedQArmGiuseppe4.mat');
% % % % % % % % % EstimatedQTask10 = load('EstimatedAngles/EstimatedQArmGiuseppe9.mat');
% % % % % % % % % EstimatedQTask9 = EstimatedQTask9.EstimatedQ;
% % % % % % % % % EstimatedQTask10 = EstimatedQTask10.EstimatedQ;
% % % % % % % % % 
% % % % % % % % % s1 = EstimatedQTask9(3,1:end)';
% % % % % % % % % s2 = EstimatedQTask10(3,1:end)';
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % s2 = s2(390:end)';
% % % % % % % % % s1 = s1(390:end)';
% % % % % % % % % 
% % % % % % % % % s1 = s1/max(s1);
% % % % % % % % % s2 = s2/max(s2);
% % % % % % % % % 
% % % % % % % % % s1 = smooth(s1,100);
% % % % % % % % % s2 = smooth(s2,100);


% % % s2 = diff(s2);
% % % s1 = diff(s1);
% % % 
% % % s1 = smooth(s1,100);
% % % s2 = smooth(s2,100);
% s1 = [s1(1)*ones(100,1) ; s1];
% s1 = resample(s1,3,1);

figure;
plot(s1,'d');
hold on
plot(s2,'r*');
legend('s1','s2')

%s2 = s2/max(s2);
%s1 = s1/max(s1);

%s1 = [s1; zeros(500,1)]; 
%s2 = [s2; zeros(500,1)]; 


%s1 = [zeros(300,1); s1];
%s1 = resample(s1,2,1);

% s1 = [s1; zeros(300,1)+s1(end)]; 
% s2 = [s2; zeros(300,1)+s1(end)]; 
figure;
plot(s1,'d');
hold on
plot(s2,'r*');
legend('s1','s2')

alpha0 = [1 1];

options = optimoptions('fmincon','MaxIter',Inf,'MaxFunEvals',10000,'Display','iter')%,'Algorithm','active-set')
[alpha, fval] = fmincon(@(alpha) ObjAlpha(alpha, s1, s2),alpha0,[],[],[],[],[],[],[],options);

num = alpha(1);
den = alpha(2);

s2_opt = resample(s2,num,den);

figure;
plot(s1,'d');
hold on
plot(s2_opt,'r*');
legend('s1','s2_opt')