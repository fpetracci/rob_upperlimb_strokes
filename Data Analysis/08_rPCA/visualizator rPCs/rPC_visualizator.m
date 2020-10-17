%% Description of SCRIPT:
% this script aims to visualize the movement associated to a signle rPC. 
% To execute this file, folder "1subjattime" must be in path

%% intro
clear all; clc;

ngroup = 1;		
%		- ngroup: number between 1, 2 and 3. it selects which group of task
%		we want to analyze. (1 = int, 2 = tr, 3 = tm, 'all' = all tasks)
% load data
data_rPCA_all = rpca_all_subj(ngroup);

%% general parameter (to edit for displaying different rPCs)

nsubj = 8;		% selected subject
t0 = 1;			% initial time of recorded trial
tf = 240;		% final time of recorded trial
tinit = 60;		% initial time of time range we want to extrapulate rPCS
tstop = 100;	% final time of time range we want to extrapulate rPCS
t = 0;			% instant at which we evaluate rPCs, if t = 0 we compute for all t in [tinit : tstop]
njoint = 10;	% number of joints
nrpc = 10;		% total number of used rPCs
sel_rPC = 1;	% selected rPCs to be shown
samples_anim = 100;	% number of samples for the animation
rep = 2;		% number of repetitions of animation

%% check inputs

% check time
if tstop < tinit
	tstop = tinit;
	warning('tstop must be greater or equal wrt tinit');
end

if tstop > tf
	tstop = tf;
	warning('exceed final time istant, tstop set to tf');
elseif tstop < t0
	tstop = t0;
	warning('exceed final time istant, tstop set to t0');
end

if tinit < t0
	tinit = t0;
	warning('exceed starting time istant, tinit set to t0');
elseif  tinit > tf
	tinit = tf;
	warning('exceed starting time istant, tinit set to tf');
end

if tstop == tinit
	t = tstop;
	warning('actually look only at t');
end

nsample = tstop - tinit + 1;

% check subj

if floor(nsubj)-nsubj ~= 0
	error('Ciao Giuseppe!')
elseif nsubj <= 0 || nsubj > 24
	error('this subject does not exist inside the dataset, number must be in [1 24]')
end
%% single subject loading

if t == 0
	
	if nsubj > 5 % strokes subject
		rPCs_vis_coeff_tmp_s	= [];
		rPCs_vis_var_tmp_s		= [];
		rPCs_vis_scores_tmp_s	= [];
		rPCs_vis_coeff_tmp_la	= [];
		rPCs_vis_var_tmp_la		= [];
		rPCs_vis_scores_tmp_la	= [];
		
		rPCs_vis_coeff			= zeros(njoint, nsample, 2);
		rPCs_vis_var			= zeros(1, nsample, 2);
		rPCs_vis_scores			= zeros(2,nsample, 2); % 2 righe, min e max score

		for i = tinit : tstop
			[coeff_rPCs, var_rPCs, scoresMm_rPCs, dom] = rPC_t_subj(i, data_rPCA_all, nsubj, sel_rPC);

			rPCs_vis_coeff_tmp_s	= cat(2, rPCs_vis_coeff_tmp_s, coeff_rPCs(:, 1));
			rPCs_vis_var_tmp_s		= cat(2, rPCs_vis_var_tmp_s, var_rPCs(1));
			rPCs_vis_scores_tmp_s	= cat(2, rPCs_vis_scores_tmp_s, scoresMm_rPCs(:, 1));

			rPCs_vis_coeff_tmp_la	= cat(2, rPCs_vis_coeff_tmp_la, coeff_rPCs(:,2));
			rPCs_vis_var_tmp_la		= cat(2, rPCs_vis_var_tmp_la, var_rPCs(2));
			rPCs_vis_scores_tmp_la	= cat(2, rPCs_vis_scores_tmp_la, scoresMm_rPCs(:, 2));
		end

		rPCs_vis_coeff(:, :, 1)		= rPCs_vis_coeff_tmp_s;
		rPCs_vis_var(:, :, 1)		= rPCs_vis_var_tmp_s;
		rPCs_vis_scores(:, :, 1)	= rPCs_vis_scores_tmp_s;

		rPCs_vis_coeff(:, :, 2)		= rPCs_vis_coeff_tmp_la;
		rPCs_vis_var(:, :, 2)		= rPCs_vis_var_tmp_la;
		rPCs_vis_scores(:, :, 2)	= rPCs_vis_scores_tmp_la;
		
	else % healthy subject
		rPCs_vis_coeff			= [];
		rPCs_vis_var			= [];
		rPCs_vis_scores			= []; % 2 righe, min e max score
		
		for i = tinit : tstop
			[coeff_rPCs, var_rPCs, scoresMm_rPCs, dom] = rPC_t_subj(i, data_rPCA_all, nsubj, sel_rPC);

			rPCs_vis_coeff	= cat(2, rPCs_vis_coeff, coeff_rPCs(:, 1));
			rPCs_vis_var	= cat(2, rPCs_vis_var, var_rPCs(1));
			rPCs_vis_scores	= cat(2, rPCs_vis_scores, scoresMm_rPCs(:, 1));
		end
	end
elseif t > t0-1 && t <= tf
	
	if nsubj > 5
		rPCs_vis_coeff			= zeros(njoint, 1, 2);
		rPCs_vis_var			= zeros(1, 1, 2);
		rPCs_vis_scores			= zeros(2, 1, 2); % 2 righe, min e max score
		
		[coeff_rPCs, var_rPCs, scoresMm_rPCs, dom] = rPC_t_subj(t, data_rPCA_all, nsubj, sel_rPC);
		
		rPCs_vis_coeff(:, :, 1)		= coeff_rPCs(:,1);
		rPCs_vis_var(:, :, 1)		= var_rPCs(1);
		rPCs_vis_scores(:, :, 1)	= scoresMm_rPCs(:, 1);

		rPCs_vis_coeff(:, :, 2)		= coeff_rPCs(:,2);
		rPCs_vis_var(:, :, 2)		= var_rPCs(2);
		rPCs_vis_scores(:, :, 2)	= scoresMm_rPCs(:, 2);
	else
		[rPCs_vis_coeff, rPCs_vis_var, rPCs_vis_scores, dom] = rPC_t_subj(t, data_rPCA_all, nsubj, sel_rPC);
	end
else
	error('t must be integer and between [t0 tf]');
end

%% Animations

if dom == -1
	dispmsg = ['Healthy subject, the ' num2str(sel_rPC) ' rPC is shown.'];
elseif dom == 0
	dispmsg = ['Non dominant subj, the ' num2str(sel_rPC) ' rPC is shown.'];
elseif dom == 1
	dispmsg = ['Dominant subj, the ' num2str(sel_rPC) ' rPC is shown.'];
end

if nsubj > 5 
	%stroke subject
	if size(rPCs_vis_coeff, 2) > 1
		% animation of rPC of the mean in the range [tinit, tstop]
		% stroke
		mean_s = mean(data_rPCA_all(nsubj).s.mean, 2);
		
		% if nsample < 20 we are more interested in the min max movement,
		% otherwise the mean of the min max range is computed.
		if nsample > 20
			alpha_s = linspace(mean(rPCs_vis_scores(1, :, 1)), mean(rPCs_vis_scores(2, :, 1)), samples_anim);
		else
			alpha_s = linspace(max(rPCs_vis_scores(1, :, 1)), min(rPCs_vis_scores(2, :, 1)), samples_anim);
		end
		mean_rpc = mean(rPCs_vis_coeff(:,:,1),2);
		mean_rpc = mean_rpc./norm(mean_rpc);
		q_s = mean_s + mean_rpc * alpha_s;
		
		disp(dispmsg)
		arm_gen_plot(q_s, rep, 1);
		
		% less affected
		mean_la = mean(data_rPCA_all(nsubj).la.mean,2);
		
		% if nsample < 20 we are more interested in the min max movement,
		% otherwise the mean of the min max range is computed.
		if nsample > 20
			alpha_la = linspace(mean(rPCs_vis_scores(1, :, 2)), mean(rPCs_vis_scores(2, :, 2)), samples_anim);
		else
			alpha_la = linspace(max(rPCs_vis_scores(1, :, 2)), min(rPCs_vis_scores(2, :, 2)), samples_anim);
		end
		mean_rpc = mean(rPCs_vis_coeff(:,:,2),2);
		mean_rpc = mean_rpc./norm(mean_rpc);
		q_la = mean_la + mean_rpc * alpha_la;
		
		disp(dispmsg)
		arm_gen_plot(q_la, rep, 2);
	else
		% animation of rPC at time t
		% stroke
		mean_s = data_rPCA_all(nsubj).s.mean(:,t);
		alpha_s = linspace(rPCs_vis_scores(1, :, 1), rPCs_vis_scores(2, :, 1), samples_anim);
		q_s = mean_s + rPCs_vis_coeff(:,:,1) * alpha_s;
	
		disp(dispmsg)
		arm_gen_plot(q_s, rep, 1);
		
		% less affected
		mean_la = data_rPCA_all(nsubj).la.mean(:,t);
		alpha_la = linspace(rPCs_vis_scores(1, :, 1), rPCs_vis_scores(2, :, 1), samples_anim);
		q_la = mean_la + rPCs_vis_coeff(:,:,2) * alpha_la;
			
		disp(dispmsg)
		arm_gen_plot(q_la, rep, 2);
	end
	
else 
	%healthy subject
	if size(rPCs_vis_coeff, 2) > 1
		% animation of rPC of the mean in the range [tinit, tstop]
		mean_h = mean(data_rPCA_all(nsubj).h.mean, 2);
		
		% if nsample < 20 we are more interested in the min max movement,
		% otherwise the mean of the min max range is computed.
		if nsample > 20
			alpha_h = linspace(mean(rPCs_vis_scores(1, :)), mean(rPCs_vis_scores(2, :)), samples_anim);
		else
			alpha_h = linspace(max(rPCs_vis_scores(1, :)), min(rPCs_vis_scores(2, :)), samples_anim);
		end
		mean_rpc = mean(rPCs_vis_coeff(:,:),2);
		mean_rpc = mean_rpc./norm(mean_rpc);
		q_h = mean_h + mean_rpc * alpha_h;
			
		disp(dispmsg)
		arm_gen_plot(q_h, rep, 1);
		
	else
		% animation of rPC at time t
		mean_h = data_rPCA_all(nsubj).h.mean(:,t);
		alpha_h = linspace(rPCs_vis_scores(1, :), rPCs_vis_scores(2, :), samples_anim);
		q_h = mean_h + rPCs_vis_coeff(:,:) * alpha_h;
		
		disp(dispmsg)
		arm_gen_plot(q_h, rep, 1);
	end
	
end
