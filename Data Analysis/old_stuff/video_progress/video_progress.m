% This script aims to plot the "progress" of our analysis through a video
% animation of:
% 1. the recorded trial
% 2. the recorded trial, but only selected segments
% 3. the reconstructed arm with virtual markers
% 4. the reconstructed arm, cleanest version

%% intro & load

clear all;
close all;
clc;

% task & subject selection
%	task:			1-30
%	subject:		1-5 for healthy, 1-19 for stroke
%	hORs:			'h' for healthy, 's' stroke subject
%	lORR:			'l' left or 'r' right side
%	ntrial:			1-3 trial number

task	= 7;	% task number
subject	= 8;	% subject number (subj 8 is P10)
hORs	= 's';
lORr	= 'r';
ntrial	= 1;	% trial number (1 to 6)

% load from .mvnx files	
file_mvnx = load_mvnx('P10_T07_R1');

% load from .mat
load('healthy_task.mat');
load('strokes_task.mat');
load('q_task.mat');
load('q_task_warped.mat');

% check if trial exist
trial = check_trial(task, subject, hORs, lORr, ntrial, strokes_task, healthy_task);

% creation of 10R arm
arms = create_arms(trial);

if trial.task_side == 0
	arm_task = arms.left;
elseif trial.task_side == 1
	arm_task = arms.right;
end

% load of angular joints values
q_trial = load_q(task, subject, hORs, lORr, ntrial, q_task);

%% 1. the recorded trial 

figh = figure(1);
clf
figh.WindowState = 'maximize';

animate_all_segments(file_mvnx, 1, 1, 'all_segments')

%% 2. selected segments

animate_sel_segments(trial, 1, 1, 'selected_segments')

%% 3. plot with markers

animate_markers(trial, 1, 1, 'markers')

%% 4. clean final plot

figh = figure(1);
clf
figh.WindowState = 'maximize';

if hORs == 's'
	nsubj = subject + 5;
else
	nsubj = subject;
end

if lORr == 'r'
	ntrial_q = ntrial + 3;
else 
	ntrial_q = ntrial ;
end

q_trial = q_task(task).subject(nsubj).trial(ntrial_q).q_grad;
arm_gen_movie(q_trial, 1, 1, 2, 'clean_movie', [0, 0], [45 12])

%%



