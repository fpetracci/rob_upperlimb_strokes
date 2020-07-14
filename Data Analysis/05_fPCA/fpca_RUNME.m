% This script aims to extrapulate fPCs from q_task, a structure cointaing
% all joint-angles values of a 10R arm robot reproducing the human motion
% described in the UZH dataset.

%% fpca calculation
clear all; close all; clc;
tic
% const
task_num = 30;
joint_num = 10;
obs_num = 240;
% load dummy struct;
dummy_struct1	= fpca_task(1);
fPCA_task		= repmat(dummy_struct1,1, task_num);

for ntask = 1:task_num
	%compute fpca for current task 
	disp(['Elaborating task num ' num2str(ntask)]);
	struct_task = fpca_task(ntask);
	fPCA_task(ntask) = struct_task;
	
end
toc

%% reconstruct q
tic 

[qmat, qmat_separated] = fpca2q(fPCA_task(1).h_joint(1));
dummy_struct1 = struct('qmat', [], 'qmat_separated', [] );
dummy_struct2 = struct('joint', repmat(dummy_struct1, 1, joint_num));
q_fpca_task = repmat(dummy_struct2, 1, task_num);

q_fpca_task_s = q_fpca_task;
q_fpca_task_h = q_fpca_task;

for i = 1:task_num
	for j = 1:joint_num
		single_struct_h = fPCA_task(i).h_joint(j);
		[qmat, qmat_separated] = fpca2q(single_struct_h);
		q_fpca_task_h(i).joint(j).qmat = qmat;
		q_fpca_task_h(i).joint(j).qmat_separated = qmat_separated;
		
		single_struct_s = fPCA_task(i).h_joint(j);
		[qmat, qmat_separated] = fpca2q(single_struct_s);
		q_fpca_task_s(i).joint(j).qmat = qmat;
		q_fpca_task_s(i).joint(j).qmat_separated = qmat_separated;
		
	end
end

toc

%% load qstacked
tmp_struct = fpca_stacker(ntask);
q_matrix_h = tmp_struct.q_matrix_h;
q_matrix_s = tmp_struct.q_matrix_s;

clearvars -except q_fpca_task_s q_fpca_task_h fPCA_task q_matrix_h q_matrix_s

%% plots

task_chosen = 1;

for j = 1:10
	figure(j)
	title(['Joint number ' num2str(j)]);
	for i = 1:4
		subplot(2,4,i)
		plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,1,i))
		
		subplot(2,4,i+4)
		plot(q_fpca_task_h(task_chosen).joint(j).qmat_separated(:,1,i))
	end
end

