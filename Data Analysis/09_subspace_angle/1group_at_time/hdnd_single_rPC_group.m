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
% if flag_mean = 0 mean posture is computed as PCA of first posture of 
% each subject

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
ylabel('Angle [deg]')

figure(2)
clf
plot(rPCsangles_a_d')
grid on	
title(['Subspace angle of Dominant Stroke group between each rPCs and mean PC'])
legend(legend_msg)	
xlim([1 size(rPCsangles_a_d,2)])
ylim([0 93])
xlabel('Time samples')
ylabel('Angle [deg]')

figure(3)
clf
plot(rPCsangles_la_d')
grid on	
title(['Subspace angle of Dominant Less Affected group between each rPCs and mean PC'])
legend(legend_msg)	
xlim([1 size(rPCsangles_la_d,2)])
ylim([0 93])
xlabel('Time samples')
ylabel('Angle [deg]')

figure(4)
clf
plot(rPCsangles_a_nd')
grid on	
title(['Subspace angle of Non Dominant Stroke group between each rPCs and mean PC'])
legend(legend_msg)	
xlim([1 size(rPCsangles_a_nd,2)])
ylim([0 93])
xlabel('Time samples')
ylabel('Angle [deg]')


figure(5)
clf
plot(rPCsangles_la_nd')
grid on	
title(['Subspace angle of Non Dominant Less Affected group between each rPCs and mean PC'])
legend(legend_msg)	
xlim([1 size(rPCsangles_la_nd,2)])
ylim([0 93])
xlabel('Time samples')
ylabel('Angle [deg]')
%% Saving Plot
if 0
	set(gca,'FontSize',10)
    set(findall(gcf,'type','text'),'FontSize',10)
    %set(gcf, 'Position',  [200, 0, 650, 650])
    grid on
    f = gcf;
    f.WindowState = 'maximize';%se si vuole a schermo intero
    %exportgraphics(f,['Subspace_angle_H_between_each_rPCs_and_mean_PC_single_1group.pdf'], 'ContentType','vector') %num2str(i)
	%exportgraphics(f,['Subspace_angle_DS_between _each_rPCs_and_mean_PC_single_1group.pdf'], 'ContentType','vector') %num2str(i)
	%exportgraphics(f,['Subspace_angle_DLA_between_each_rPCs_and_mean_PC_single_1group.pdf'], 'ContentType','vector') %num2str(i)
	%exportgraphics(f,['Subspace_angle_NDS_between_each_rPCs_and_mean_PC_single_1group.pdf'], 'ContentType','vector') %num2str(i)
	exportgraphics(f,['Subspace_angle_NDLA_between_each_rPCs_and_mean_PC_single_1group.pdf'], 'ContentType','vector') %num2str(i)
end