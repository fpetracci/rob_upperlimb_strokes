% Script to create joint angles structure. It groups data about every 
% subjects involved and tasks executed. 
% It has to be executed only once in order to prepare the skeleton of this 
% structure, that will be fullfilled later using q_population.m.

% load a single trial to generate the low level of the struct. Dirty trick
% but it's auto_updating if we want to change the low level struct inside
% the function q_trial2q

trial = healthy_task(1).subject(1).left_side_trial(1);
single_trial_q = q_trial2q(trial);
clear trial

% array of struct, each element is a single trial
trial_struct = repmat(single_trial_q, 1, nTrial*2);

% creation of 'subject' structure to contain all the trials of the single
% subject
subject = repmat(struct('trial', trial_struct), 1, nSubject_healthy + nSubject_strokes);

% creation of task array structure to contain all necessary data
q_task = repmat(struct('subject', subject), 1, nTasks);

fprintf('Structure created! \n')

% % We need to separate 'task' structure and 'h_task' structure because they
% % are composed by a different number of 'subject' structure inside of their 
% % bodies. We can not use a single structure definition in which includes 
% % both post-strokes and healthy patients' data.


