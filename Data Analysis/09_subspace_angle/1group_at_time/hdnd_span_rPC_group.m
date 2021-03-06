%% Script description
% This script computes and plots angle between the subspace generated by the
% selected rPCs and the one generated by the mean_posture PCs.


% posture computed as the mean of each rPC among all subjects.
% It requires the choice of ngroup.


% How we obtained mean_posture PCs? Follow the steps:
% 1.	Mean at each time step between all selected trial for each subject 
%		(njoints x nsample) for each subject.
% 2.	For each subject, we compute the "temporal" mean for each joint 
%		angle. We get a (njoints x 1) for each subject. We lose this way
%		the temporal information
% (3.)	We stack each subject to his own group (h, la, a)
% 3.	We stack together all subjects
% 4.	autovettori = PCA(njoints x subjects)^T
%% intro
clear all; clc;

ngroup = 1;		
%		- ngroup: number between 1, 2 and 3. it selects which group of task
%		we want to analyze. (1 = int, 2 = tr, 3 = tm, 'all' = all tasks)
% load data

flag_mp = 0;


data_rPCA_hdnd = rpca_all_subj_d_nd(ngroup);
mean_posture = mean_post(ngroup, flag_mp);
nsamples = size(data_rPCA_hdnd.h.var_expl,2);

%% extrapulate angles one at a time

sel_rPC = [1 2 3];
[angles] = rPC_angle_group(data_rPCA_hdnd, sel_rPC, mean_posture);

%% plot

%legend msg
legend_msg = [];
for i = 1:length(sel_rPC)
	msg_tmp = ['principal angle ' num2str(i)];
	legend_msg = cat(1, legend_msg, msg_tmp);
end

figure(1)
clf
plot(angles.h')
hold on
plot(vecnorm(angles.h, 2, 1)','k--')
grid on
title(['Subspace angles of Healthy group between span rPCs and span mean PCs'])
legend(legend_msg)
xlim([1 nsamples])
ylim([0 max(vecnorm(angles.h, 2, 1))+3])
xlabel('Time samples')
ylabel('Angle [deg]')

figure(2)
clf
plot(angles.a_d')
hold on
plot(vecnorm(angles.a_d, 2, 1)','k--')
grid on
title(['Subspace angles of Dominant Stroke group between span rPCs and span mean PCs'])
legend(legend_msg)
xlim([1 nsamples])
ylim([0 max(vecnorm(angles.a_d, 2, 1))+3])
xlabel('Time samples')
ylabel('Angle [deg]')

figure(3)
clf
plot(angles.la_d')
hold on
plot(vecnorm(angles.la_d, 2, 1)','k--')
grid on
title(['Subspace angles of Dominant Less Affected group between span rPCs and span mean PCs'])
legend(legend_msg)
xlim([1 nsamples])
ylim([0 max(vecnorm(angles.la_d, 2, 1))+3])
xlabel('Time samples')
ylabel('Angle [deg]')

figure(4)
clf
plot(angles.a_nd')
hold on
plot(vecnorm(angles.a_nd, 2, 1)','k--')
grid on
title(['Subspace angles of Non Dominant Stroke group between span rPCs and span mean PCs'])
legend(legend_msg)
xlim([1 nsamples])
ylim([0 max(vecnorm(angles.a_nd, 2, 1))+3])
xlabel('Time samples')
ylabel('Angle [deg]')

figure(5)
clf
plot(angles.la_nd')
hold on
plot(vecnorm(angles.la_nd, 2, 1)','k--')
grid on
title(['Subspace angles of Non Dominant Less Affected group between span rPCs and span mean PCs'])
legend(legend_msg)
xlim([1 nsamples])
ylim([0 max(vecnorm(angles.la_nd, 2, 1))+3])
xlabel('Time samples')
ylabel('Angle [deg]')
%% Plot
if 1
	set(gca,'FontSize',10)
    set(findall(gcf,'type','text'),'FontSize',10)
    %set(gcf, 'Position',  [200, 0, 650, 650])
    grid on
    f = gcf;
    f.WindowState = 'maximize';%se si vuole a schermo intero
    %exportgraphics(f,['Subspace_angle_H_between_span_rPCs_and_span_mean_PC_1group.pdf'], 'ContentType','vector') %num2str(i)
	%exportgraphics(f,['Subspace_angle_DS_between _span_rPCs_and_span_mean_PC_1group.pdf'], 'ContentType','vector') %num2str(i)
	%exportgraphics(f,['Subspace_angle_DLA_between_span_rPCs_and_span_mean_PC_1group.pdf'], 'ContentType','vector') %num2str(i)
	%exportgraphics(f,['Subspace_angle_NDS_between_span_rPCs_and_span_mean_PC_1group.pdf'], 'ContentType','vector') %num2str(i)
	%exportgraphics(f,['Subspace_angle_NDLA_between_span_rPCs_and_span_mean_PC_1group.pdf'], 'ContentType','vector') %num2str(i)
end