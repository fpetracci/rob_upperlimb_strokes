function [fPCA_subj, q_stacked_subj] = loader_subj(ngroup) 
% fpca computation
if exist('loader_subj_mat_1group.mat') == 2 && sum(ngroup == 1) == 1 
	load('loader_subj_mat_1group.mat');
elseif exist('loader_subj_mat_2group.mat') == 2 && sum(ngroup == 2) == 1
	load('loader_subj_mat_2group.mat');
elseif exist('loader_subj_mat_3group.mat') == 2 && sum(ngroup == 3) == 1
	load('loader_subj_mat_3group.mat');
elseif exist('loader_subj_mat_allgroup.mat') == 2 && sum(ngroup == 'all') == 3 
	load('loader_subj_mat_allgroup.mat');
else

	load('q_task_warped.mat');
	% const
	subj_num = 24;
	joint_num = 10;
	obs_num = 240;
	% load dummy struct;
	dummy_struct1	= fpca_subj(1, ngroup);
	fPCA_subj		= repmat(dummy_struct1,1, subj_num);

	for nsubj = 1:subj_num
		%compute fpca for current subject 
		%disp(['Elaborating subj num ' num2str(nsubj)]);
		struct_tmp = fpca_subj(nsubj, ngroup);
		if nsubj <6
			fPCA_subj(nsubj).h_joint = struct_tmp.h_joint;
			fPCA_subj(nsubj).s_joint = [];
			fPCA_subj(nsubj).la_joint = [];
		else
			fPCA_subj(nsubj).h_joint = [];
			fPCA_subj(nsubj).s_joint = struct_tmp.s_joint;
			fPCA_subj(nsubj).la_joint = struct_tmp.la_joint;
		end
	end

	%% load q_stacked_subj
	dummy_struct1	= fpca_stacker_subj(1, ngroup);
	q_stacked_subj	= repmat(dummy_struct1, 1, subj_num);

	for nsubj = 1:subj_num
		%disp(['Stacking subj num ' num2str(nsubj)]);
		struct_tmp = fpca_stacker_subj(nsubj, ngroup);
		if nsubj <6
			q_stacked_subj(nsubj).q_matrix_h = struct_tmp.q_matrix_h;
			q_stacked_subj(nsubj).q_matrix_s = [];
			q_stacked_subj(nsubj).q_matrix_la = [];
		else
			q_stacked_subj(nsubj).q_matrix_h = [];
			q_stacked_subj(nsubj).q_matrix_s = struct_tmp.q_matrix_s;
			q_stacked_subj(nsubj).q_matrix_la = struct_tmp.q_matrix_la;
		end	
	end
end
end