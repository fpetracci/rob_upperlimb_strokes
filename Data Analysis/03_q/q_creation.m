% Script to initializes the structures of q_task. It groups data about every 
% subjects involved and tasks executed. 
% It has to be executed only once in order to prepare the skeleton of this 
% structure, that will be filled later using q_population.m.

% use an empty trial to generate the low level of the struct.
empty_q = struct('q_grad', [], 'err', []);

% array of struct, each element is a single empty trial
trial_struct = repmat(empty_q, 1, nTrial*2);

% creation of 'subject' structure to contain all the trials of the single
% subject
subject = repmat(struct('trial', trial_struct), 1, nSubject_healthy + nSubject_strokes);

% creation of task array structure to contain all necessary data
q_task = repmat(struct('subject', subject), 1, nTasks);

fprintf('Structure created! \n')
