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


data_rPCA_all = rpca_all_subj(ngroup);
mean_posture = mean_post(ngroup);

%% selected subject e rPCs
nsubj = 5;		% selected subject

%% parameters load
nsamples = size(data_rPCA_all(1).h.mean,2);

%% extrapulate angles one at a time

% how many "single" rPC I want to compare to the "single" mean_posture
rPCs_num = 3;
rPCsangles_h = zeros(rPCs_num, nsamples);

rPCsangles_s = zeros(rPCs_num, nsamples);
rPCsangles_la = zeros(rPCs_num, nsamples);

for sel_rPC = 1 : rPCs_num
	[angles, dom] = rPC_angle(data_rPCA_all, nsubj, sel_rPC, mean_posture);
	if dom == -1
		rPCsangles_h(sel_rPC,:)	= angles;
	else
		rPCsangles_s(sel_rPC,:)		= angles(:,:,1);
		rPCsangles_la(sel_rPC,:)	= angles(:,:,2);
	end
end
%% plot

%legend msg
legend_msg = [];
for i = 1:rPCs_num
	msg_tmp = ['rPC' num2str(i)];
	legend_msg = cat(1, legend_msg, msg_tmp);
end

if dom == -1
	figure(1)
	clf
	plot(rPCsangles_h')
	grid on
	title(['Subspace angle of Healthy subj ' num2str(nsubj) ' between each rPCs and mean PC'])
	legend(legend_msg)
	xlim([1 size(rPCsangles_h,2)])
	ylim([0 93])
	xlabel('Time samples')
	ylabel('Angle [grad]')
else
	figure(1)
	clf
	plot(rPCsangles_s')
	grid on	
	if dom
		title(['Subspace angle of A_d subj ' num2str(nsubj) ' between each rPCs and mean PC'])
		legend(legend_msg)	
	else
		title(['Subspace angle of A_{nd} subj ' num2str(nsubj) 'between each rPCs and mean PC'])
		legend(legend_msg)
	end
	xlim([1 size(rPCsangles_s,2)])
	ylim([0 93])
	
	figure(2)
	clf
	plot(rPCsangles_la')
	grid on	
	if dom
		title(['Subspace angle of LA_d subj ' num2str(nsubj) 'between each rPCs and mean PC'])
		legend(legend_msg)
	else
		title(['Subspace angle of LA_{nd} subj ' num2str(nsubj) ' between each rPCs and mean PC'])
		legend(legend_msg)
	end
	xlim([1 size(rPCsangles_la,2)])
	ylim([0 93])
	xlabel('Time samples')
	ylabel('Angle [grad]')
end