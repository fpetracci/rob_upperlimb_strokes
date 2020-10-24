%% description
% for each subjects' group (h, a, la) this script plots:
% 1.		cumulative sum of variance explained
% 2.		cumulative sum of variance explained for joints specified in r


%% intro and variance extraction
clear; clc;

% load fpca struct
fPCA_struct = fpca_hsla;

% allocating variances
var_test = fPCA_struct.h_joint(1).var;
nfpc = length(var_test);

for j = 1:10
	var_h(j,:) =  fPCA_struct.h_joint(j).var;
	var_s(j,:) =  fPCA_struct.s_joint(j).var;
	var_la(j,:) =  fPCA_struct.la_joint(j).var;
end


%% stupid test
sbiggerh = var_s(:,1) > var_h(:,1)
sbiggerh = mean(var_s(:,1)) > mean(var_h(:,1));

sbiggerh = cumsum(var_s, 2) > cumsum(var_h, 2)

%% plot cumulative sum of variance explained for joints 4:7
figure(1)
clf
plot(cumsum(mean(var_h,1),2)')
hold on
plot(cumsum(mean(var_la,1),2)','g')
plot(cumsum(mean(var_s,1),2)', 'r')
grid on
title('Cumulative Sum of mean var')

%% plot cumulative sum of variance explained

r = 4:10;	% range of joints that we want to analyze

figure(2)
clf
plot(cumsum(mean(var_h(r,:)	,1),2)')
hold on
plot(cumsum(mean(var_la(r,:),1),2)','g')
plot(cumsum(mean(var_s(r,:)	,1),2)', 'r')
grid on
title(['Cumulative Sum of mean of ' num2str(r) ' joints var'])

