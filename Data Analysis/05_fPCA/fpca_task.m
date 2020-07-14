function data = fpca_task(ntask)
%% intro
% load
oldfolder = cd;
cd ../
cd 99_folder_mat
load('q_task_warped.mat');
cd(oldfolder);
clear oldfolder;
[njoints, nsamples] = size(q_task_warp(ntask).subject(1).trial(1).q_grad);

%% nobs counter

%each task at a time??
nobs_h		= 0;	% number of observations of trial executed with healthy arm
nobs_s		= 0;	% number of observations of trial executed with healthy arm
nobs_error	= 0;	% number of observations that are errors
nobs_empty	= 0;	% number of observations that are empty

for subj = 1:24
	for ntrial = 1:6
		if ~isempty(q_task_warp(ntask).subject(subj).trial(ntrial).q_grad)
			if q_task_warp(ntask).subject(subj).trial(ntrial).stroke_task == 1
				nobs_s = nobs_s + 1;
			elseif q_task_warp(ntask).subject(subj).trial(ntrial).stroke_task == 0
				nobs_h = nobs_h + 1;
			else
				nobs_error = nobs_error + 1;
			end
		else
			nobs_empty = nobs_empty + 1;
		end
	end
end

%% q_matrix
h_counter = 0;	% counter to keep track of h_matrix index during 
s_counter = 0;	% counter to keep track of s_matrix index during 

q_matrix_h = zeros(nobs_h, nsamples, njoints); % 3 dimension matrix
q_matrix_s = zeros(nobs_s, nsamples, njoints); % 3 dimension matrix
for subj = 1:24
	for ntrial = 1:6
		if ~isempty(q_task_warp(ntask).subject(subj).trial(ntrial).q_grad)
			% load q trial into a tmp variable
			q_trial = q_task_warp(ntask).subject(subj).trial(ntrial).q_grad;
			
			if q_task_warp(ntask).subject(subj).trial(ntrial).stroke_task == 0
				% healthy arm executed the trial
				h_counter = h_counter + 1 ; %update current 
				for dof = 1:10 % load each joint
					q_1dof	= q_trial(dof,:);			
					q_matrix_h(h_counter, :, dof) = q_1dof; 
					% load q_trial in a single row
				end
			elseif q_task_warp(ntask).subject(subj).trial(ntrial).stroke_task == 1
				% stroke arm executed the trial
				s_counter = s_counter + 1;
				for dof = 1:10 % load each joint
					q_1dof	= q_trial(dof,:);			
					q_matrix_s(s_counter, :, dof) = q_1dof;
					% load q_trial in a single row
				end
			end
		end
	end
end

%% fpca
nbase	= 15;	% number of elements in the base
norder	= 5;	% order of the functions
nfpc	= 3;	% how many fPCs I want to save

% load a single fpca-struct and then repeat it to create structure
fpca_tmp = q_fpca(q_matrix_h(:,:,1), nbase, norder, nfpc);
h_joint = repmat(fpca_tmp, 1, njoints);	% healthy fpca-struct
s_joint = repmat(fpca_tmp, 1, njoints);	% stroke fpca-struct

for dof = 1:njoints
	h_joint(dof) = q_fpca(q_matrix_h(:,:,dof), nbase, norder, nfpc);
	s_joint(dof) = q_fpca(q_matrix_s(:,:,dof), nbase, norder, nfpc);
end

%% save section
data = struct;
data.h_joint = h_joint;
data.s_joint = s_joint;

end

