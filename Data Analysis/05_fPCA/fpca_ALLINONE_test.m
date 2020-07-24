clear; clc;
%% 
fPCA_struct = fpca_ALLINONE;


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

%% plot 
figure(1)
clf
plot(cumsum(mean(var_h([4:7],:),1),2)')
hold on
plot(cumsum(mean(var_la([4:7],:),1),2)','g')
plot(cumsum(mean(var_s([4:7],:),1),2)', 'r')
grid on
%% plot 2
figure(1)
clf
plot(cumsum(mean(var_h,1),2)')
hold on
plot(cumsum(mean(var_la,1),2)','g')
plot(cumsum(mean(var_s,1),2)', 'r')
grid on
