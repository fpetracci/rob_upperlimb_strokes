%% struct_main.m		- runs the needed scripts to generate strokes_data.mat and healthy_data.mat
%% load_mvnx.m			- function that loads a specified .mvnx file into a matlab structure
%% struct_dataload.m	- function that extrapolate relevant data from the file .mvnx. It needs load_mvnx in order to work correctly.
%% struct_creation.m	- initializes the structures of strokes_data and healthy_data
%% struct_population.m	- searches and read all mvnx files with the proper name and populates the structures of strokes_data and healthy_data with the relevant data

%% comment %%
% Given the files.mvnx provided by UZH, we rearranged all trials in
% two structures: one for healthy subjects and one for post-stroke
% subjects. 
% Note that some of those files are corrupted, so we decided to exclude
% them entirely and creating their empty spaces inside the structures, in
% order to fill them once valid data are obtained. In other words, to run
% this script you have to delete P28_SoftProTasks, so in the corresponding 
% space in the structures there will be no data.

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

%global constant definition
nTasks = 30;
nTrial = 3;
nSubject_strokes = 19;
nSubject_healthy = 5;

% script execution
struct_creation
struct_population

toc
