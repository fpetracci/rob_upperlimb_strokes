%% Description of SCRIPT:
% this script aims to visualize the movement associated to a signle rPC by
% generating 3 movie files: H S LA


%% intro
clear all; clc;

ngroup = 1;		
%		- ngroup: number between 1, 2 and 3. it selects which group of task
%		we want to analyze. (1 = int, 2 = tr, 3 = tm, 'all' = all tasks)
% load data
data_rPCA = rpca_hsla(ngroup);
[mean_post_h, mean_post_s, mean_post_la] = mean_postHSLA(ngroup, 0);

%% general parameter (to edit for displaying different rPCs)

t0 = 1;			% initial time of recorded trial
tf = 240;		% final time of recorded trial
tinit = 1;		% initial time of time range we want to extrapulate rPCS
tstop = 240;	% final time of time range we want to extrapulate rPCS
t = 0;			% instant at which we evaluate rPCs, if t = 0 we compute for all t in [tinit : tstop]
njoint = 10;	% number of joints
nrpc = 10;		% total number of used rPCs
sel_rPC = 1;	% selected rPCs to be shown
samples_anim = 100;	% number of samples for the animation
rep = 1;		% number of repetitions of animation

minmax = 0;		% flag to set how we choose the min max of the scalar that
				% multiply the single rPC: 
				% 0 - constant value 'const_alpha'
				% 1 - min/max are calculated as the temporal mean of the
				%		mins and maxes of the scores.
const_alpha = 45; 

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

%% search for min max scores & build scalar for movie
if minmax == 1
	%Search the min/max for each time step, then do the mean

	min_h	= mean(min(data_rPCA.h.scores(:,sel_rPC,:)));
	max_h	= mean(max(data_rPCA.h.scores(:,sel_rPC,:)));

	min_s	= mean(min(data_rPCA.s.scores(:,sel_rPC,:)));
	max_s	= mean(max(data_rPCA.s.scores(:,sel_rPC,:)));

	min_la	= mean(min(data_rPCA.la.scores(:,sel_rPC,:)));
	max_la	= mean(max(data_rPCA.la.scores(:,sel_rPC,:)));
else
	min_h	= -const_alpha;
	max_h	= const_alpha;

	min_s	= -const_alpha;
	max_s	= const_alpha;

	min_la	= -const_alpha;
	max_la	= const_alpha;
end

% build linspace
alpha_h = linspace(min_h, max_h, samples_anim);
alpha_s = linspace(min_s, max_s, samples_anim);
alpha_la = linspace(min_la, max_la, samples_anim);

%% joint angle values
rPC_h = mean(data_rPCA.h.coeff(:,1,:),3)/norm(mean(data_rPCA.h.coeff(:,1,:),3));
rPC_s = mean(data_rPCA.s.coeff(:,1,:),3)/norm(mean(data_rPCA.s.coeff(:,1,:),3));
rPC_la = mean(data_rPCA.la.coeff(:,1,:),3)/norm(mean(data_rPCA.la.coeff(:,1,:),3));

q_h		= rPC_h		* alpha_h		+ mean_post_h(:,sel_rPC);
q_s		= rPC_s		* alpha_s		+ mean_post_s(:,sel_rPC);
q_la	= rPC_la	* alpha_la		+ mean_post_la(:,sel_rPC);


%% gen movie
if minmax == 1
	arm_gen_movie(q_h,	rep, 1, 2, [num2str(sel_rPC) 'rPC_healthy'])
	arm_gen_movie(q_s,	rep, 1, 2, [num2str(sel_rPC) 'rPC_stroke'])
	arm_gen_movie(q_la, rep, 1, 2, [num2str(sel_rPC) 'rPC_lessaffected'])
else
	arm_gen_movie(q_h,	rep, 1, 2, [num2str(sel_rPC) 'rPC_healthy_bounded'])
	arm_gen_movie(q_s,	rep, 1, 2, [num2str(sel_rPC) 'rPC_stroke_bounded'])
	arm_gen_movie(q_la, rep, 1, 2, [num2str(sel_rPC) 'rPC_lessaffected_bounded'])
end
	
	
