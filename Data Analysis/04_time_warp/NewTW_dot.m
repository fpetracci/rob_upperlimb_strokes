% Creation of the Data-set:q_task_warped_dot
% Performed another TimeWarping in where only the movement phases are taken into account
%% init
clear all,clc

load('q_task.mat');
load('q_task_warped.mat');

%%Initializa
nSubject_strokes = 19;
nSubject_healthy = 5;
num_tasks = 30;
num_trial = 6;
q_task_warp_corretto = q_task_warp;
q_task_warp_dot = q_task;

%% calculation of the q of speed by eliminating some initial and final parts
for i = 1:num_tasks
	for j = (1:nSubject_healthy + nSubject_strokes)
			for k = 1:num_trial
				q_task_warp_corretto(i).subject(j).trial(k).q_grad = [];
				q_task_warp_dot(i).subject(j).trial(k).q_grad(:,228:end) = [];
				if not(isempty(q_task_warp(i).subject(j).trial(k).q_grad))
					q_trial = diff(q_task_warp(i).subject(j).trial(k).q_grad(:,10:227)')';
					q_task_warp_dot(i).subject(j).trial(k).q_grad = q_trial;
				end
			end
	end
end
save('q_task_warped_dot','q_task_warp_dot')
% %% if you want to use this TW uncommen the block 
% 
% for i = 1:num_tasks
% 	for j = (1:nSubject_healthy + nSubject_strokes)
% 		for k = 1:num_trial
% 			if not(isempty(q_task_warp(i).subject(j).trial(k).q_grad))
% 				s2 =  correct2pi_err(q_task_warp(i).subject(j).trial(k).q_grad);
% 				[skip_init, skip_end] = find_skip(s2);
% 				%% prendere soltanto la parte di movimento effettiva
% 				s2 = s2(:,skip_init+1:skip_end-1);
% 				if length(s2) > 0
% 					s2 = resample(s2',240,skip_end-skip_init-1)';
% 				end
% 				q_task_warp_corretto(i).subject(j).trial(k).q_grad = s2;
% 				q_trial = diff(q_task_warp_corretto(i).subject(j).trial(k).q_grad(:,10:227)')';
% 				q_task_warp_dot_new(i).subject(j).trial(k).q_grad = q_trial;
% 			end
% 			
% 		end
% 	end
% end
