%% q_main.m				- runs the needed scripts to generate strokes_data.mat and healthy_data.mat
%% q_trial2q.m			- function that extrapolate relevant data from the file .mvnx. It needs load_mvnx in order to work correctly.
%% q_creation.m			- initializes the structures of strokes_data and healthy_data
%% q_population.m		- searches and read all mvnx files with the proper name and populates the structures of strokes_data and healthy_data with the relevant data

%% comment %%

% Structures' tree:
%	healthy/strokes_task(1->30).
%			subject(1->n_subjects).
%					left/right_trial(1->n_trials).
% 							L5.
% 								quat
% 								pos
% 							Shoulder_L/R.
% 								quat
% 								pos
% 							Upperarm_L/R.
% 								...
% 							Forearm_L/R.
% 								...
% 							Hand_L/R.
% 								...
% 							stroke_side		% the side damaged by stroke: -1 = healthy, 0 = left, 1 = right.
% 							stroke_task		% boolean, true if the task is executed using the damaged side, false otherwise.
% 							task_side		% stores the side which executes the task: 0 = left, 1 = right.

%% main structure script
tic
clear; clc; close;

% load data
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
