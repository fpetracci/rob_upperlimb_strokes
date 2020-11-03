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
	clf
	y = [var_h(j,:); var_a_d(j,:); var_la_d(j,:); var_a_nd(j,:); var_la_nd(j,:)] * 100;
	b = bar(1:10, y );%,'FaceColor','flat');
	b(1).FaceColor = [0 0 255]/255;
	b(2).FaceColor = [255 0 0]/255;
	b(3).FaceColor = [0 255 0]/255;
	b(4).FaceColor = [255 0 255]/255; % magent
	b(5).FaceColor = [0 255 255]/255; % cian
	ylim([0, max(max(var_h))*100+5])
	xlabel('Principal Function')
	ylabel(' Explained Variance % ')
end
%% plot mean
figure(j+1)
clf
y = [mean(var_h,1); mean(var_la_d,1); mean(var_la_nd,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [0 255 0]/255;
b(3).FaceColor = [0 255 255]/255; % cian
ylim([0, 100])
xlabel('Principal Function')
ylabel(' Explained Variance % ')

figure(j+2)
clf
y = [mean(var_h,1); mean(var_a_d,1); mean(var_a_nd,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [255 0 0]/255;
b(3).FaceColor = [255 0 255]/255; % magent
ylim([0, 100])
xlabel('Principal Function')
ylabel(' Explained Variance % ')

figure(j+3)
clf
y = [mean(var_h,1); mean(var_a_d,1); mean(var_la_d,1); mean(var_a_nd,1); mean(var_la_nd,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [255 0 0]/255;
b(3).FaceColor = [0 255 0]/255;
b(4).FaceColor = [255 0 255]/255; % magent
b(5).FaceColor = [0 255 255]/255; % cian
ylim([0, 100])
xlabel('Principal Function')
ylabel(' Explained Variance % ')

figure(j+4)
clf
y = [mean(var_h,1); mean(var_a_d,1); mean(var_la_d,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [255 0 0]/255;
b(3).FaceColor = [0 255 0]/255;
ylim([0, 100])
xlabel('Principal Function')
ylabel(' Explained Variance % ')

figure(j+5)
clf
y = [mean(var_h,1); mean(var_a_nd,1); mean(var_la_nd,1)] * 100;
b = bar(1:10, y );%,'FaceColor','flat');
b(1).FaceColor = [0 0 255]/255;
b(2).FaceColor = [255 0 255]/255; % magent
b(3).FaceColor = [0 255 255]/255; % cian
ylim([0, 100])
xlabel('Principal Function')
ylabel(' Explained Variance % ')

%% save graphics
if 0
	if ~exist('i')
		i = 1;
	end
	set(gca,'FontSize',20)
	set(findall(gcf,'type','text'),'FontSize',20)

	f = gcf;
	exportgraphics(f,['joint' num2str(i) '_fpca_var_expl.pdf'], 'ContentType','vector')
	i = i + 1;
end