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

data_rPCA_hdnd = rpca_all_subj_d_nd(ngroup);
mean_posture = mean_post(ngroup, flag_mean);
nsamples = size(data_rPCA_hdnd.h.var_expl,2);

%% extrapulate angles one at a time

% how many "single" rPC I want to compare to the "single" mean_posture
rPCs_num = 3;
rPCsangles_h = zeros(rPCs_num, nsamples);

rPCsangles_a_d		= zeros(rPCs_num, nsamples);
rPCsangles_la_d		= zeros(rPCs_num, nsamples);
rPCsangles_a_nd		= zeros(rPCs_num, nsamples);
rPCsangles_la_nd	= zeros(rPCs_num, nsamples);

for sel_rPC = 1 : rPCs_num
	angles  = rPC_angle_group(data_rPCA_hdnd, sel_rPC, mean_posture);
	
	rPCsangles_h(sel_rPC,:)		= angles.h;
	rPCsangles_a_d(sel_rPC,:)	= angles.a_d;
	rPCsangles_la_d(sel_rPC,:)	= angles.la_d;
	rPCsangles_a_nd(sel_rPC,:)	= angles.a_nd;
	rPCsangles_la_nd(sel_rPC,:)	= angles.la_nd;
	
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
plot(rPCsangles_a_d')
grid on	
title(['Subspace angle of Dominant Stroke group between each rPCs and mean PC'])
legend(legend_msg)	
xlim([1 size(rPCsangles_a_d,2)])
ylim([0 93])

figure(3)
clf
plot(rPCsangles_la_d')
grid on	
title(['Subspace angle of Dominant Less Affected group between each rPCs and mean PC'])
legend(legend_msg)	
xlim([1 size(rPCsangles_la_d,2)])
ylim([0 93])
xlabel('Time samples')
ylabel('Angle [grad]')

figure(4)
clf
plot(rPCsangles_a_nd')
grid on	
title(['Subspace angle of Non Dominant Stroke group between each rPCs and mean PC'])
legend(legend_msg)	
xlim([1 size(rPCsangles_a_nd,2)])
ylim([0 93])

figure(5)
clf
plot(rPCsangles_la_nd')
grid on	
title(['Subspace angle of Non Dominant Less Affected group between each rPCs and mean PC'])
legend(legend_msg)	
xlim([1 size(rPCsangles_la_nd,2)])
ylim([0 93])
xlabel('Time samples')
ylabel('Angle [grad]')