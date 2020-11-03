%% description
% for each subjects' group (h, a_d, a_nd, la_d, la_nd) this script plots:
% 1.	cumulative sum of variance explained
% 2.	cumulative sum of variance explained for joints specified in r

%% intro and variance extraction
clear; clc;
ngroup = 1;
% load fpca struct
fPCA_struct = fpca_hdnd(ngroup);

% allocating variances
var_test = fPCA_struct.h_joint(1).var;
nfpc = length(var_test);

for j = 1:10
	var_h(j,:)		=  fPCA_struct.h_joint(j).var;
	var_a_d(j,:)	=  fPCA_struct.a_d_joint(j).var;
	var_la_d(j,:)	=  fPCA_struct.la_d_joint(j).var;
	var_a_nd(j,:)	=  fPCA_struct.a_nd_joint(j).var;
	var_la_nd(j,:)	=  fPCA_struct.la_nd_joint(j).var;
end

%% stupid test
sbiggerh = (var_a_d(:,1)+var_a_nd(:,1)) > var_h(:,1);
sbiggerh = mean(var_a_d(:,1)+var_a_nd(:,1)) > mean(var_h(:,1));
sbiggerh = cumsum((var_a_d(:,1)+var_a_nd(:,1)), 2) > cumsum(var_h, 2);

%% plot cumulative sum of variance explained for all joints
figure(1)
clf
plot(cumsum(mean(var_h,1),2)')
hold on
plot(cumsum(mean(var_la_d, 1), 2)','g')
plot(cumsum(mean(var_a_d, 1), 2)', 'r')
plot(cumsum(mean(var_la_nd, 1), 2)','c')
plot(cumsum(mean(var_a_nd, 1), 2)', 'm')
grid on
title('Cumulative Sum of mean var')

figure(2)
clf
plot(cumsum(mean(var_h,1),2)')
hold on
plot(cumsum(mean(var_la_nd, 1), 2)','c')
plot(cumsum(mean(var_a_nd, 1), 2)', 'm')
grid on
title('Cumulative Sum of mean var')

figure(3)
clf
plot(cumsum(mean(var_h,1),2)')
hold on
plot(cumsum(mean(var_la_d, 1), 2)','g')
plot(cumsum(mean(var_a_d, 1), 2)', 'r')
grid on
title('Cumulative Sum of mean var')

figure(4)
clf
plot(cumsum(mean(var_h,1),2)')
hold on
plot(cumsum(mean(var_la_d, 1), 2)','g')
plot(cumsum(mean(var_la_nd, 1), 2)','c')
grid on
title('Cumulative Sum of mean var')

figure(5)
clf
plot(cumsum(mean(var_h,1),2)')
hold on
plot(cumsum(mean(var_a_d, 1), 2)', 'r')
plot(cumsum(mean(var_a_nd, 1), 2)', 'm')
grid on
title('Cumulative Sum of mean var')

%% plot cumulative sum of variance explained

r = 4:10;	% range of joints that we want to analyze

figure(6)
clf
plot(cumsum(mean(var_h(r,:), 1), 2)')
hold on
plot(cumsum(mean(var_la_d(r,:), 1), 2)','g')
plot(cumsum(mean(var_a_d(r,:), 1), 2)', 'r')
plot(cumsum(mean(var_la_nd(r,:), 1), 2)','c')
plot(cumsum(mean(var_a_nd(r,:), 1), 2)', 'm')

grid on
title(['Cumulative Sum of mean of ' num2str(r) ' joints var'])