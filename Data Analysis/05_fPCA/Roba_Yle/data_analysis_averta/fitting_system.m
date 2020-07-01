close all
clear all
clc

load Savings/Warped_Datasets.mat     

data = Warped_Datasets{1}';data = data(1:7:end,:);
IDdata = iddata(data,rand(size(data,1),7));

%modelOrder = 8*ones(7,1);
% Fit an AR model to represent the system
%sys = arx(IDdata,[4*eye(7) 1*eye(7) 0*eye(7)])

sys = arx(IDdata,[4*eye(7) 1*eye(7) 0*eye(7)])




% A = [1  -1.5  0.7];
% B = [0 1 0.5];
% m0 = idpoly(A,B);
u = iddata([],randn(1,7));
e = iddata([],randn(1,7));
y = sim(sys,[u e]);
% z = [y,u];
% m = arx(z,[2 2 1]);+

save sys_ok sys