%% description
% this script plots a pareto like graph with variance explained by fPCs for
% each joint for each subjects' group (healthy, less affected and
% affected). 
% There is the possibility of saving graphics into pdf

%% load
clear; clc;
ngroup = 1;
%ngroup = 'all';

fPCA_struct = fpca_hsla(ngroup);
var_test = fPCA_struct.h_joint(1).var;
nfpc = length(var_test);

for j = 1:10
	var_h(j,:) =  fPCA_struct.h_joint(j).var;
	var_s(j,:) =  fPCA_struct.s_joint(j).var;
	var_la(j,:) =  fPCA_struct.la_joint(j).var;
end

%% plot mean
f=figure(1);
f.WindowState = 'maximized';
figure('WindowState', 'maximized')
clf
y = [mean(var_h,1); mean(var_la,1); mean(var_s,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
err = [std(var_h,1); std(var_la,1); std(var_s,1)] * 100;
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [0 255 0]/255;
b(3).FaceColor = [255 0 0]/255;
hold on
%% error bar
% Calculate the number of bars in each group
nbars = 3;
% Get the x coordinate of the bars
x = [];
for i = 1:nbars
    x = [x ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x,y,err,'k','linestyle','none')'
hold off
ylim([0, 100])
grid on
xlabel('Principal Function')
ylabel(' Explained Variance % ')

%% a plot for each joint
for j = 1:10
	figure(j+1)
	set(gcf, 'Position',  [200, 0, 650, 650])
	clf
	y = [var_h(j,:); var_la(j,:); var_s(j,:)] * 100;
	b = bar(1:10, y );%,'FaceColor','flat');
	b(1).FaceColor = [0 0 255]/255;
	b(2).FaceColor = [0 255 0]/255;
	b(3).FaceColor = [255 0 0]/255;
	%ylim([0, max(max(var_h))*100+5])
	ylim([0, 100])
	grid on
	xlabel('Principal Function')
	ylabel(' Explained Variance % ')
end

%% save graphics
if 1
	if ~exist('i')
		i = 1;
	end
	set(gca,'FontSize',13)
	set(gcf, 'Position',  [200, 0, 650, 650]) 

	f = gcf;
	exportgraphics(f,['joint_mean_fpca_var_expl_hsla_dot_1group.pdf'], 'ContentType','vector','BackgroundColor','none')
	i = i + 1;
end