%% q_main.m				- runs the needed scripts to generate q_task.mat
%% q_trial2q.m			- implements EKF executions and joint angles estimations on a single trial dataset given as input
%% q_creation.m			- initializes the structures of q_task
%% q_population.m		- populates q_task struct with estimated joint angles values from q_trial2q.m and other informations

%% comment %%

% Structures' tree:
%	q_task(1->30).
%			subject(1->nSubjects_healthy,nSubjects_healthy+1->n_subjects_healthy+n_subjects_strokes).
%					trial(1->n_trials, n_trials+1->2*n_trials).
% 							q_grad			% results of EKF estimate of joint angles for every timestep (grad)
% 							err				% error between measured positions and reconstructed ones using estimated joint angles
% 							stroke_task		% boolean, true if the task is executed using the damaged side, false otherwise.
% 							stroke_side		% the side damaged by stroke: -1 = healthy, 0 = left, 1 = right.
% 							task_side		% stores the side which executes the task: 0 = left, 1 = right.

%% main structure script
tic
clear; clc; close;

oldfolder = cd;
cd ../
cd 99_folder_mat
load('healthy_task.mat');
load('strokes_task.mat');
cd(oldfolder);
clear oldfolder;

%global constant definition
nTasks = 30;
nTrial = 3;
nSubject_strokes = 19;
nSubject_healthy = 5;

% script execution
q_creation
q_population

toc
