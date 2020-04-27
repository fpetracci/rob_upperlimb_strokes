% Script to create 'dataset' structure. It groups data about every subjects
% involved and tasks executed. 
% It has to be executed only once in order to prepare the skeleton of this 
% structure, that will be fullfilled later using struct_population.m.

filename = 'L:\UZH_data\ULF_in_ADL\Healthies\H02_SoftProTasks\H02_T01_L1.mvnx';

% load a single file to generate the low level of the struct. Dirty trick
% but it's auto_updating if we want to change the low level struct inside
% the function struct_dataload
single_trial = struct_dataload(filename);

% array of struct, each element is a single trial
trial_struct = repmat(single_trial, 1, nTrial);

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


%% Old

%dataset.stroke_side = 0; %1 if task is executed using the side affected by stroke, 0 instead
%
% creation of 'subject' structure to contain all necessary data of a single subject
%
% for i = 1:nTrial %% number of executed tasks
%     eval(['subject.left_side.trial' num2str(i) '=dataset;'])
% 	eval(['subject.right_side.trial' num2str(i) '=dataset;'])
% end
% 
% subject.stroke_side = 0; %-1 = no strokes, 0 = left, 1 = right
% 
% %creation of 'strokes_data.task' and 'healthy_data.task' structures to
% %contain all data regarding every tasks execution from all subjects.
% 
% for i = 1:nTasks %% number of executed tasks
%     for j=1:nSubject_strokes %% number of subject affected to strokes
%         eval(['task' num2str(i) '.subject' num2str(j) ' =subject;'])
%     end
%     eval(['strokes_data.task' num2str(i) '=task' num2str(i) ';'])
% end
% 
% for i = 1:nTasks %% number of executed tasks
%     for k=1:nSubject_healthy %% number of healthy subjects
%         eval(['h_task' num2str(i) '.subject' num2str(k) ' =subject;'])
%     end
%     eval(['healthy_data.task' num2str(i) '=h_task' num2str(i) ';'])
% end
% 

% 
% %clear all