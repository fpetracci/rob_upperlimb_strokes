% Script to create 'dataset' structure. It groups data about every subjects
% involved and tasks executed. 
% It has to be executed only once in order to prepare the skeleton of this 
% structure, that will be fullfilled later using struct_population.m.

%dataset.stroke_side = 0; %1 if task is executed using the side affected by stroke, 0 instead

%dataset.shoulder_r = [0, 0, 0];
%dataset.upperarm_r = [0, 0, 0];
%dataset.forearm_r = [0, 0, 0];
%dataset.hand_r = [0, 0, 0];
%dataset.elbow_angle_r = [0, 0, 0]; % in our study we are interested in 'Z', the first element
%dataset.wrist_angle_r = [0, 0, 0];
%dataset.shoulder_angle_r = [0, 0, 0];
%dataset.elbow_velocity_r = [0, 0, 0];

%dataset.shoulder_l = [0, 0, 0];
%dataset.upperarm_l = [0, 0, 0];
%dataset.forearm_l = [0, 0, 0];
%dataset.hand_l = [0, 0, 0];
%dataset.elbow_angle_l = [0, 0, 0]; % in our study we are interested in 'Z', the first element
%dataset.wrist_angle_l = [0, 0, 0];
%dataset.shoulder_angle_l = [0, 0, 0];
%dataset.elbow_velocity_l = [0, 0, 0];

%dataset.neck = [0, 0, 0];
%dataset.head = [0, 0, 0];

% creation of 'subject' structure to contain all necessary data of a single subject

for i = 1:nTrial %% number of executed tasks
    eval(['subject.left_side.trial' num2str(i) '=dataset;'])
	eval(['subject.right_side.trial' num2str(i) '=dataset;'])
end

subject.stroke_side = 0; %-1 = no strokes, 0 = left, 1 = right

%creation of 'strokes_data.task' and 'healthy_data.task' structures to
%contain all data regarding every tasks execution from all subjects.

for i = 1:nTasks %% number of executed tasks
    for j=1:nSubject_strokes %% number of subject affected to strokes
        eval(['task' num2str(i) '.subject' num2str(j) ' =subject;'])
    end
    eval(['strokes_data.task' num2str(i) '=task' num2str(i) ';'])
end

for i = 1:nTasks %% number of executed tasks
    for k=1:nSubject_healthy %% number of healthy subjects
        eval(['h_task' num2str(i) '.subject' num2str(k) ' =subject;'])
    end
    eval(['healthy_data.task' num2str(i) '=h_task' num2str(i) ';'])
end
%save ('struct.mat','strokes_data','healthy_data')

% We need to separate 'task' structure and 'h_task' structure because they
% are composed by a different number of 'subject' structure inside of their 
% bodies. We can not use a single structure definition in which includes 
% both post-strokes and healthy patients' data.

%clear all