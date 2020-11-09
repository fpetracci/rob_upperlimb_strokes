%% Script description
% This script computes and plots angle between each rPCs and the mean 
% posture computed as the mean of each rPC among all subjects.
% It requires the choice of ngroup.

%% intro
clear all; clc;

ngroup = 1;		
%		- ngroup: number between 1, 2 and 3. it selects which group of task
%		we want to analyze. (1 = int, 2 = tr, 3 = tm, 'all' = all tasks)
% load data

flag_mean = 0;
% if flag_mean = 0 mean posture is computed as PCA of mean postures of each
% subject
% if flag_mean = 1 mean posture is computed as MEAN of mean postures of each
% subject


data_rPCA_hsla = rpca_hsla(ngroup);
mean_posture = mean_post(ngroup, flag_mean);
nsamples = size(data_rPCA_hsla.h.var_expl,2);

%% extrapulate angles one at a time

% how many "single" rPC I want to compare to the "single" mean_posture
rPCs_num = 3;
rPCsangles_h = zeros(rPCs_num, nsamples);

rPCsangles_s = zeros(rPCs_num, nsamples);
rPCsangles_la = zeros(rPCs_num, nsamples);

for sel_rPC = 1 : rPCs_num
	angles  = rPC_angle_group(data_rPCA_hsla, sel_rPC, mean_posture);
	
	rPCsangles_h(sel_rPC,:)		= angles.h;
	rPCsangles_s(sel_rPC,:)		= angles.s;
	rPCsangles_la(sel_rPC,:)	= angles.la;
	
end
%% plot

%legend msg
legend_msg = [];
for i = 1:rPCs_num
	msg_tmp = ['rPC' num2str(i)];
	legend_msg = cat(1, legend_msg, msg_tmp);
end

figure(1)
clf
plot(rPCsangles_h')
grid on
title(['Subspace angle of Healthy group between each rPCs and mean PC'])
legend(legend_msg)
xlim([1 size(rPCsangles_h,2)])
ylim([0 93])
xlabel('Time samples')
ylabel('Angle [grad]')

figure(2)
clf
plot(rPCsangles_s')
grid on	
title(['Subspace angle of Stroke group between each rPCs and mean PC'])
legend(legend_msg)	
xlim([1 size(rPCsangles_s,2)])
ylim([0 93])

figure(3)
clf
plot(rPCsangles_la')
grid on	
title(['Subspace angle of Less Affected group between each rPCs and mean PC'])
legend(legend_msg)	
xlim([1 size(rPCsangles_la,2)])
ylim([0 93])
xlabel('Time samples')
ylabel('Angle [grad]')