%% stroke
%init
clear;clc

nTasks = 30;
nTrial = 3;
nSubject_strokes = 19;
oldfolder = cd;
cd ../
cd 99_folder_mat
load('strokes_task.mat');
load('healthy_task.mat');
cd(oldfolder);
clear oldfolder;

counter_errori = 0;
str = {};
for i = 1:nTasks

	for j = 1:nSubject_strokes
		for k = 1:nTrial
			n_fields = length(fieldnames(strokes_task(i).subject(j).left_side_trial(k)));

			if(n_fields == 7)
% 				strokes_task(i).subject(j).left_side_trial(k).stroke_side = ...
%					str2num(strokes_task(i).subject(j).left_side_trial(k).stroke_side);
				
				%strokes_task(i).subject(j).left_side_trial = []; 
				%strokes_task(i).subject(j).right_side_trial = []; 
				%strokes_task(i).subject(j).stroke_side = []; 
				counter_errori = counter_errori + 1;
				str{counter_errori} = ['task ', num2str(i), ' subject ', num2str(j), ' trial ', num2str(k)];
			end
		end
	end
		
end