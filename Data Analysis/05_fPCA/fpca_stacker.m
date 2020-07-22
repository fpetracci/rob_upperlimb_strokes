function data = fpca_stacker(ntask)
% COMMENTAMI

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
nobs_s		= 0;	% number of observations of trial executed with stroke arm
nobs_la		= 0;	% number of observations of trial executed with healthy arm of a stroke subject
nobs_error	= 0;	% number of observations that are errors
nobs_empty	= 0;	% number of observations that are empty

for subj = 1:24
	for ntrial = 1:6
		if ~isempty(q_task_warp(ntask).subject(subj).trial(ntrial).q_grad)
			if ~check_trial(q_task_warp(ntask).subject(subj).trial(ntrial).q_grad)
				nobs_error = nobs_error + 1;
			elseif q_task_warp(ntask).subject(subj).trial(ntrial).stroke_task == 1
				nobs_s = nobs_s + 1;
			elseif q_task_warp(ntask).subject(subj).trial(ntrial).stroke_task == 0 &...
				   q_task_warp(ntask).subject(subj).trial(ntrial).stroke_side == -1
				nobs_h = nobs_h + 1;
			elseif q_task_warp(ntask).subject(subj).trial(ntrial).stroke_task == 0 & ...
				   q_task_warp(ntask).subject(subj).trial(ntrial).stroke_side ~= -1
				nobs_la = nobs_la + 1;
			end
		else
			nobs_empty = nobs_empty + 1;
		end
	end
end

%% q_matrix
h_counter  = 0;	% counter to keep track of h_matrix index during 
s_counter  = 0;	% counter to keep track of s_matrix index during 
la_counter = 0; % counter to keep track of la_matrix index during 
q_matrix_h =	zeros(nobs_h, nsamples, njoints); % 3 dimension matrix
q_matrix_s =	zeros(nobs_s, nsamples, njoints); % 3 dimension matrix
q_matrix_la =	zeros(nobs_la, nsamples, njoints); % 3 dimension matrix
for subj = 1:24
	for ntrial = 1:6
		if ~isempty(q_task_warp(ntask).subject(subj).trial(ntrial).q_grad)
			% load q trial into a tmp variable
			q_trial = q_task_warp(ntask).subject(subj).trial(ntrial).q_grad;
			
			if ~check_trial(q_task_warp(ntask).subject(subj).trial(ntrial).q_grad)
				% do nothing = skiptrial
			elseif q_task_warp(ntask).subject(subj).trial(ntrial).stroke_task == 0 & ...
			   q_task_warp(ntask).subject(subj).trial(ntrial).stroke_side == -1
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
			elseif q_task_warp(ntask).subject(subj).trial(ntrial).stroke_task == 0 & ...
				   q_task_warp(ntask).subject(subj).trial(ntrial).stroke_side ~= -1
				% stroke arm executed the trial
				la_counter = la_counter + 1;
				for dof = 1:10 % load each joint
					q_1dof	= q_trial(dof,:);			
					q_matrix_la(la_counter, :, dof) = q_1dof;
					% load q_trial in a single row
			end
		end
	end
end


%% save section
data = struct;
data.q_matrix_h = q_matrix_h;
data.q_matrix_s = q_matrix_s;
data.q_matrix_la = q_matrix_la;
end

