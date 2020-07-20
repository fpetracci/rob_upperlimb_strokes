%% fpca calculation
clear all; close all; clc;
tic
% const
task_num = 30;
subj_num = 24;
joint_num = 10;
obs_num = 240;
% load dummy struct;
dummy_struct1	= fpca_task(1);
fPCA_subj		= repmat(dummy_struct1,1, subj_num);

for nsubj = 1:subj_num
	%compute fpca for current task 
	disp(['Elaborating subj num ' num2str(nsubj)]);
	struct_task = fpca_subj(nsubj);
	if nsubj <6
		fPCA_subj(nsubj).h_joint = struct_task.h_joint;
		fPCA_subj(nsubj).s_joint = [];
		fPCA_subj(nsubj).la_joint = [];
	else
		fPCA_subj(nsubj).h_joint = [];
		fPCA_subj(nsubj).s_joint = struct_task.s_joint;
		fPCA_subj(nsubj).la_joint = struct_task.la_joint;
	end
end
toc