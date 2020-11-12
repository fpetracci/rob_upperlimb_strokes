%% description
% this script plots a pareto like graph with variance explained by fPCs for
% each joint for each subjects' group (healthy, less affected and
% affected). 
% There is the possibility of saving graphics into pdf

%% load
clear; clc;
ngroup		= 1;
% ngroup		= ['all'];
fPCA_struct = fpca_hdnd(ngroup);
var_test	= fPCA_struct.h_joint(1).var;
nfpc		= length(var_test);

for j = 1:10
	var_h(j,:)		=  fPCA_struct.h_joint(j).var;
	var_a_d(j,:)	=  fPCA_struct.a_d_joint(j).var;
	var_la_d(j,:)	=  fPCA_struct.la_d_joint(j).var;
	var_a_nd(j,:)	=  fPCA_struct.a_nd_joint(j).var;
	var_la_nd(j,:)	=  fPCA_struct.la_nd_joint(j).var;
end

%% a plot for each joint
for j = 1:10
	figure(j)
	set(gcf, 'Position',  [200, 0, 650, 650])

	clf
	y = [var_h(j,:); var_a_d(j,:); var_la_d(j,:); var_a_nd(j,:); var_la_nd(j,:)] * 100;
	b = bar(1:10, y );%,'FaceColor','flat');
	b(1).FaceColor = [0 0 255]/255;
	b(2).FaceColor = [255 0 0]/255;
	b(3).FaceColor = [0 255 0]/255;
	b(4).FaceColor = [255 0 255]/255; % magent
	b(5).FaceColor = [0 255 255]/255; % cian
	%ylim([0, max(max(var_h))*100+5])
	ylim([0, 100])
	grid on
	xlabel('Principal Function')
	ylabel(' Explained Variance % ')
end
%% plot mean
figure(j+1)
set(gcf, 'Position',  [200, 0, 650, 650])

clf
y = [mean(var_h,1); mean(var_la_d,1); mean(var_la_nd,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [0 255 0]/255;
b(3).FaceColor = [0 255 255]/255; % cian
ylim([0, 100])
xlabel('Principal Function')
ylabel(' Explained Variance % ')
grid on

figure(j+2)
set(gcf, 'Position',  [200, 0, 650, 650])
clf
y = [mean(var_h,1); mean(var_a_d,1); mean(var_a_nd,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [255 0 0]/255;
b(3).FaceColor = [255 0 255]/255; % magent
ylim([0, 100])
xlabel('Principal Function')
ylabel(' Explained Variance % ')
grid on


figure(j+3)
set(gcf, 'Position',  [200, 0, 650, 650])
clf
y = [mean(var_h,1); mean(var_a_d,1); mean(var_la_d,1); mean(var_a_nd,1); mean(var_la_nd,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [255 0 0]/255;
b(3).FaceColor = [0 255 0]/255;
b(4).FaceColor = [255 0 255]/255; % magent
b(5).FaceColor = [0 255 255]/255; % cian
hold on
%% error bar
% Calculate the number of bars in each group
nbars = 5;
% Get the x coordinate of the bars
x = [];
for i = 1:nbars
    x = [x ; b(i).XEndPoints];
end
% Plot the errorbars
err = [std(var_h,1); std(var_a_d,1);  std(var_la_d,1); std(var_a_nd,1);std(var_la_nd,1)] *100;
errorbar(x,y,err,'k','linestyle','none')';
ylim([0, 100])
xlabel('Principal Function')
ylabel(' Explained Variance % ')
grid on


figure(j+4)
set(gcf, 'Position',  [200, 0, 650, 650])
clf
y = [mean(var_h,1); mean(var_a_d,1); mean(var_la_d,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [255 0 0]/255;
b(3).FaceColor = [0 255 0]/255;
ylim([0, 100])
xlabel('Principal Function')
ylabel(' Explained Variance % ')
grid on


figure(j+5)
set(gcf, 'Position',  [200, 0, 650, 650])
clf
y = [mean(var_h,1); mean(var_a_nd,1); mean(var_la_nd,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [255 0 255]/255; % magent
b(3).FaceColor = [0 255 255]/255; % cian
ylim([0, 100])
xlabel('Principal Function')
ylabel(' Explained Variance % ')
grid on


%% save graphics
if 0
	if ~exist('i')
		i = 1;
	end
	set(gca,'FontSize',13)
	set(findall(gcf,'type','text'),'FontSize',13)

	f = gcf;
	%exportgraphics(f,['joint' num2str(i) '_fpca_var_expl_hdnd_1group.pdf'], 'ContentType','vector') %num2str(i) 
	%exportgraphics(f,['jointmean_HLA_D_fpca_var_expl_hdnd_1group.pdf'], 'ContentType','vector') %num2str(i) 
% 	exportgraphics(f,['jointmean_HA_D_fpca_var_expl_hdnd_1group.pdf'], 'ContentType','vector') %num2str(i) 
 	exportgraphics(f,['jointmean_HALA_DND_fpca_var_expl_hdnd_1group.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
% 	exportgraphics(f,['jointmean_HALA_D_fpca_var_expl_hdnd_1group.pdf'], 'ContentType','vector') %num2str(i) 
% 	exportgraphics(f,['jointmean_HALA_ND_fpca_var_expl_hdnd_1group.pdf'], 'ContentType','vector') %num2str(i) 

	i = i + 1;
end