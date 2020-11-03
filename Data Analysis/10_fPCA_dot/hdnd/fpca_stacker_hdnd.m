function data = fpca_stacker_hdnd(ngroup)
%RPCA_STACKER_SUBJ stacks all time warped trials of chosen group of task in 
% three different group Healthy, Stroke and LessAffected.
% input:
%		- nsubj: number between 1 and 24,1 to 5 healthy, 6 to 24 stroke
%		patients.
%		- ngroup: number between 1, 2 and 3. it selects which group of task
%		we want to analyze. (1 = int, 2 = tr, 3 = tm)


%% iteration 

q_matrix_h = [];
q_matrix_a_d = [];
q_matrix_a_nd = [];
q_matrix_la_d = [];
q_matrix_la_nd = [];

for nsubj = 1:24
	
	%nsubj = [1:20, 22:24]
	[q_h, q_a_d, q_a_nd, q_la_d, q_la_nd] = stack1subj(nsubj, ngroup);
	q_matrix_h		= cat(1,	q_matrix_h,		q_h);
	q_matrix_a_d	= cat(1,	q_matrix_a_d,	q_a_d);
	q_matrix_a_nd	= cat(1,	q_matrix_a_nd,	q_a_nd);
	q_matrix_la_d	= cat(1,	q_matrix_la_d,	q_la_d);
	q_matrix_la_nd	= cat(1,	q_matrix_la_nd,	q_la_nd);

end


%% save for output
data = struct;
data.q_matrix_h			= q_matrix_h;
data.q_matrix_a_d		= q_matrix_a_d;
data.q_matrix_a_nd		= q_matrix_a_nd;
data.q_matrix_la_d		= q_matrix_la_d;
data.q_matrix_la_nd		= q_matrix_la_nd;

end

%% ------------------------------------------------------------------------
function [q_h, q_a_d, q_a_nd, q_la_d, q_la_nd] = stack1subj(nsubj, ngroup)
%% intro
% load
% oldfolder = cd;
% cd ../
% cd ../
% cd 99_folder_mat
load('q_task_warped_dot.mat');
% cd(oldfolder);
% clear oldfolder;
q_task_warp = q_task_warp_dot;
[njoints, nsamples] = size(q_task_warp(1).subject(1).trial(1).q_grad);

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
	
elseif sum( ngroup == 'all') == 3
	% all
	task_first = 1;
	task_last = 30;
else
	error('ngroup must be an integer between 1,2 and 3 or string all');
end

%% nobs counter

%subj_Ad: -1 for healthy, 1 for Ad, 0 for And
% Ad	= affected on dominant side
% And	= affected on non-dominant side
subj_Ad = [	-1	-1	-1	-1	-1 ...% healthy
			0	1	1	1	0	1	0	0	1	1	0	0	0	1	1	0	1	1	1];
		%	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24

%each subj at a time
nobs_h		= 0;	% number of observations of trial executed with healthy arm
nobs_a_d	= 0;	% number of observations of trial executed with stroke arm of a dominant affected
nobs_a_nd	= 0;	% number of observations of trial executed with stroke arm of a non dominant affected
nobs_la_d	= 0;	% number of observations of trial executed with healthy arm of a stroke subject of a dominant affected
nobs_la_nd	= 0;	% number of observations of trial executed with healthy arm of a stroke subject of a non dominant affected
nobs_error	= 0;	% number of observations that are errors 
nobs_empty	= 0;	% number of observations that are empty

for ntask = task_first:task_last
	for ntrial = 1:6
		if ~isempty(q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad)
			if ~check_trial(q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad)
				nobs_error = nobs_error + 1;
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 1
				
				% affected side
				if subj_Ad(nsubj) 
					nobs_a_d = nobs_a_d + 1;
				elseif ~subj_Ad(nsubj)
					nobs_a_nd = nobs_a_nd + 1;
				end
				
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 0 &...
				   q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_side == -1
				
			   % healthy side 
				nobs_h = nobs_h + 1;
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 0 & ...
				   q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_side ~= -1
				
				% less affected
				if subj_Ad(nsubj)
					nobs_la_d = nobs_la_d + 1;
				elseif ~subj_Ad(nsubj)
					nobs_la_nd = nobs_la_nd + 1;
				end
				
			end
		else
			nobs_empty = nobs_empty + 1;
		end
	end
end

% nobs_error
% nobs_empty

%% q_matrix

%counters
h_counter		= 0;	% counter to keep track of h_matrix index during iteration
a_d_counter		= 0;	% counter to keep track of s_matrix index during iteration
a_nd_counter	= 0;	% counter to keep track of s_matrix index during iteration
la_d_counter	= 0;	% counter to keep track of s_matrix index during iteration
la_nd_counter	= 0;	% counter to keep track of s_matrix index during iteration

%preallocating matrix
q_h		=	zeros(nobs_h,		nsamples, njoints);	% 3 dimension matrix
q_a_d	=	zeros(nobs_a_d,		nsamples, njoints); % 3 dimension matrix
q_a_nd	=	zeros(nobs_a_nd,	nsamples, njoints); % 3 dimension matrix
q_la_d	=	zeros(nobs_la_d,	nsamples, njoints); % 3 dimension matrix
q_la_nd	=	zeros(nobs_la_nd,	nsamples, njoints); % 3 dimension matrix

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
					q_h(h_counter, :, dof) = q_1dof; 
					% load q_trial in a single row
				end
			
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 1
				
				% affected side
				if subj_Ad(nsubj) 
					% A d
					a_d_counter = a_d_counter + 1 ; %update current 
					for dof = 1:10 % load each joint
						q_1dof	= q_trial(dof,:);			
						q_a_d(a_d_counter, :, dof) = q_1dof;
						% load q_trial in a single row
					end
	
				elseif ~subj_Ad(nsubj)
					% A nd
					a_nd_counter = a_nd_counter + 1 ; %update current 
					for dof = 1:10 % load each joint
						q_1dof	= q_trial(dof,:);			
						q_a_nd(a_nd_counter, :, dof) = q_1dof;
						% load q_trial in a single row
					end
				end
				
			elseif q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 0 & ...
				   q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_side ~= -1
				
			   % less affected
				if subj_Ad(nsubj)
					% la d
					la_d_counter = la_d_counter + 1 ; %update current 
					for dof = 1:10 % load each joint
						q_1dof	= q_trial(dof,:);			
						q_la_d(la_d_counter, :, dof) = q_1dof;
						% load q_trial in a single row
					end
				elseif ~subj_Ad(nsubj)
					% la nd
					la_nd_counter = la_nd_counter + 1 ; %update current 
					for dof = 1:10 % load each joint
						q_1dof	= q_trial(dof,:);			
						q_la_nd(la_nd_counter, :, dof) = q_1dof;
						% load q_trial in a single row
					end
					
				end

			end
		end
	end
end


%end function
end