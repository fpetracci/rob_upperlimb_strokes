function view_trial(task, subject, hORs, lORr)
%view_trial plots and animates all relevant steps of our process to analyze
% a single trial specified by task, healthy or stroke subject, left or
% right side trial.
%	In order this function generates:
%	0. Brief description of the chosen task and some info on the subject.
%	1. Animation of the recorded given trial
%	2. Animation of the 10Rarm doing that task, Plot errors???
%	3. Animation of the warped task done by the 10Rarm, plot joint angles
%	before and after
%	4. Animation of the prime componenti analisi cose belle
%
%	How to use:
%	view_trial(task, subject, hORs, lORr, trial)
%	task:			1-30
%	subject:		1-5 for healthy, 1-19 for stroke
%	hORs:			'h' for healthy, 's' stroke subject
%	lORR:			'l' left or 'r' right side

%% TO DO LIST
% check if input
% check if trial
% info
% animation of chosen trial
% animation of 10R robot

% capire che fare dopo



%% load
oldfolder = cd;
cd ../
cd 99_folder_mat
load('healthy_task.mat');
load('strokes_task.mat');
load('q_task.mat');
% load q warped
cd(oldfolder);
clear oldfolder;

%% check if input is correct

%% check if trial exist
if isempty(healthy_task(task).subject(subject).left_side_trial(k).L5))
end

%% info on task

%% info on subject

%% animation of the trial

%% animation of 10R doing the trial



% animation of all data


end

