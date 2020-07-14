% This script aims to extrapulate fPCs from q_task, a structure cointaing
% all joint-angles values of a 10R arm robot reproducing the human motion
% described in the UZH dataset.

%% fpca calculation
clear all; close all; clc;
tic

% load dummy struct;
dummy_struct	= fpca_task(1);
fpca_task		= repmat(dummy_struct,1, 30);

for ntask = 1:30
	%compute fpca for current task 
	struct_task = fpca_task(ntask);
	fpca_task(ntask) = struct_task;
end
toc