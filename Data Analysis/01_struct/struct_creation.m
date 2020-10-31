% Script to create 'dataset' structure. It groups data about every subjects
% involved and tasks executed. 
% It has to be executed only once in order to prepare the skeleton of this 
% structure, that will be filled later using struct_population.m.

%filename = 'L:\UZH_data\ULF_in_ADL\Healthies\H01_SoftProTasks\H01_T01_L1.mvnx';
% load a single file to generate the low level of the struct. Dirty trick
% but it's auto_updating if we want to change the low level struct inside
% the function struct_dataload

empty_trial = struct('L5', [], ...
					'Upperarm_R', [], 'Forearm_R', [], 'Hand_R' , [], ...
					'Upperarm_L', [], 'Forearm_L', [], 'Hand_L' , []);

%single_trial = struct_dataload(filename);

% array of struct, each element is a single trial
trial_struct = repmat(empty_trial, 1, nTrial);

% creation of 'subject' structure to contain all the trials of the single
% subject
subject = repmat(struct('left_side_trial', trial_struct, 'right_side_trial', trial_struct ), 1, nSubject_healthy);

% creation of task array structure to contain all necessary data
healthy_task = repmat(struct('subject', subject), 1, nTasks);

subject = repmat(struct('left_side_trial', trial_struct, 'right_side_trial', trial_struct ), 1, nSubject_strokes);
strokes_task = repmat(struct('subject', subject), 1, nTasks);


fprintf('Structures created! \n')

% % We need to separate 'task' structure and 'h_task' structure because they
% % are composed by a different number of 'subject' structure inside of their 
% % bodies. We can not use a single structure definition in which includes 
% % both post-strokes and healthy patients' data.


