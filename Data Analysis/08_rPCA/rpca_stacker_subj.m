function data = rpca_stacker_subj(nsubj, ngroup)
%RPCA_STACKER_SUBJ stacks all time warped trials of chosen subject and
%chosen group of task.
% input:
%		- nsubj: number between 1 and 24,1 to 5 healthy, 6 to 24 stroke
%		patients.
%		- ngroup: number between 1, 2 and 3. it selects which group of task
%		we want to analyze. (1 = int, 2 = tr, 3 = tm)

%% intro
% load
oldfolder = cd;
cd ../
cd 99_folder_mat
load('q_task_warped.mat');
cd(oldfolder);
clear oldfolder;
[njoints, nsamples] = size(q_task_warp(1).subject(1).trial(1).q_grad);


%% task choice

if ngroup == 1
	% tasks int
	task_first = 1;
	task_last = 10;
elseif ngroup == 2
	% tasks tr
	task_first = 11;
	task_last = 20;
elseif ngroup == 3
	% tasks tm
	task_first = 21;
	task_last = 30;
else
	error('ngroup must be an integer between 1,2 and 3');
end


%% nobs counter

%each subj at a time
nobs_h		= 0;	% number of observations of trial executed with healthy arm
nobs_s		= 0;	% number of observations of trial executed with stroke arm
nobs_la		= 0;	% number of observations of trial executed with healthy arm of a stroke subject
nobs_error	= 0;	% number of observations that are errors
nobs_empty	= 0;	% number of observations that are empty

for ntask = task_first:task_last
	for ntrial = 1:6
		if ~isempty(q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad)
			if ~check_trial(q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad)
				nobs_error = nobs_error + 1;
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 1
				nobs_s = nobs_s + 1;
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 0 &...
				   q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_side == -1
				nobs_h = nobs_h + 1;
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 0 & ...
				   q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_side ~= -1
				nobs_la = nobs_la + 1;
			end
		else
			nobs_empty = nobs_empty + 1;
		end
	end
end

% nobs_error
% nobs_empty

%% q_matrix

h_counter  = 0;	% counter to keep track of h_matrix index during iteration
s_counter  = 0;	% counter to keep track of s_matrix index during iteration
la_counter = 0; % counter to keep track of la_matrix index during iteration
q_matrix_h =	zeros(nobs_h, nsamples, njoints); % 3 dimension matrix
q_matrix_s =	zeros(nobs_s, nsamples, njoints); % 3 dimension matrix
q_matrix_la =	zeros(nobs_la, nsamples, njoints); % 3 dimension matrix
for ntask = task_first:task_last
	for ntrial = 1:6
		if ~isempty(q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad)
			% load q trial into a tmp variable
			q_trial = q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad;
			
			if ~check_trial(q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad)
				% do nothing = skiptrial
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 0 & ...
			   q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_side == -1
				% healthy arm executed the trial
				h_counter = h_counter + 1 ; %update current 
				for dof = 1:10 % load each joint
					q_1dof	= q_trial(dof,:);			
					q_matrix_h(h_counter, :, dof) = q_1dof; 
					% load q_trial in a single row
				end
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 1
				% stroke arm executed the trial
				s_counter = s_counter + 1;
				for dof = 1:10 % load each joint
					q_1dof	= q_trial(dof,:);			
					q_matrix_s(s_counter, :, dof) = q_1dof;
					% load q_trial in a single row
				end
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 0 & ...
				   q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_side ~= -1
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