% %correct Time warping
% clear all,clc
% oldfolder = cd;
% cd ../
% cd 99_folder_mat
% load('q_task_warped.mat');
% cd(oldfolder);
% clear oldfolder;
% %%Initializa
% nSubject_strokes = 19;
% nSubject_healthy = 5;
% num_tasks = 30;
% num_trial = 6;
% q_task_warp_corretto = q_task_warp;
% %% Come prima cosa andiamo a vedere se il movimento inizia prima o dopo i 20 samples
% % nel caso finisse prima si ricopia l'ultimo valore fino a init_movement, nel caso
% % fosse maggiore si eliminano i primi sample. ora si vede dove finisce il
% % movimento, se prima o dopo di end_movement si fa un resample fino a 240 - end_Movement
% %
skip_init_TOT = [];
skip_end_TOT = [];
for i = 1:num_tasks
	for j = (1:nSubject_healthy + nSubject_strokes)
			for k = 1:num_trial
				if not(isempty(q_task_warp(i).subject(j).trial(k).q_grad))
 					s2 =  correct2pi_err(q_task_warp(i).subject(j).trial(k).q_grad);
					[skip_init, skip_end] = find_skip(s2);
					skip_init_TOT = [skip_init_TOT skip_init];
					skip_end_TOT = [skip_end_TOT skip_end];
					for z = 1:10
						q_task_warp_corretto(i).subject(j).trial(k).q_grad = zeros(10,240);
					end
				end
			end
	end
end
%%
init_movement = ceil(mean(skip_init_TOT));
end_movement = ceil(240 - mean(skip_end_TOT));
movement = 240 - init_movement - end_movement;
%% 

for i = 1:num_tasks
	for j = (1:nSubject_healthy + nSubject_strokes)
		for k = 1:num_trial
			if not(isempty(q_task_warp(i).subject(j).trial(k).q_grad))
				s2 =  correct2pi_err(q_task_warp(i).subject(j).trial(k).q_grad);
				[skip_init, skip_end] = find_skip(s2);
				if skip_init < init_movement
					q_task_warp_corretto(i).subject(j).trial(k).q_grad(:,1:skip_init) = s2(:,1:skip_init);
					q_task_warp_corretto(i).subject(j).trial(k).q_grad(:,skip_init + 1:init_movement) = s2(:,init_movement) .* ones(10,init_movement-skip_init);
				elseif skip_init > init_movement
					q_task_warp_corretto(i).subject(j).trial(k).q_grad(:,1:init_movement) = s2(:,skip_init-init_movement:skip_init-1)
				end	

					q_task_warp_corretto(i).subject(j).trial(k).q_grad(:,skip_init:init_movement) = s2(:,skip_init:init_movement);
				if skip_end < 240-end_movement
					q_task_warp_corretto(i).subject(j).trial(k).q_grad(:, 240-end_movement:end) = s2(:,skip_end:skip_end+end_movement);
				elseif skip_end > 240 - end_movement
					q_task_warp_corretto(i).subject(j).trial(k).q_grad(:, 240-end_movement:end) = s2(:, 240-end_movement:end);
				end
				s2_new = resample(s2(:,skip_init+1:skip_end-1)',movement,skip_end-skip_init-1)';
				q_task_warp_corretto(i).subject(j).trial(k).q_grad(:,init_movement+1: 240- end_movement) = s2_new;
			end
			
		end
	end
end
%%
% s1 = q_task(s1_index(i,1)).subject(s1_index(i,2)).trial(s1_index(i,3)).q_grad;
% 		s1 = correct2pi_err(s1);
% 		s1_new = resample(s1',250,length(s1))';
% 		s1_new = s1_new(:,6:end-5);
% 		s1 = s1_new;
%                 disp(i)
% 			
% s2 =  correct2pi_err(q_task_warp(i).subject(j).trial(k).q_grad(:,10:end));
%  					s2_new = TimeWarping2(s1,s2);
% 					q_task_warp(i).subject(j).trial(k).q_grad = s2_new;			
% 					%q_task_warp(i).subject(j).trial(k).q_grad = correct2pi_err(q_task_warp(i).subject(j).trial(k).q_grad);