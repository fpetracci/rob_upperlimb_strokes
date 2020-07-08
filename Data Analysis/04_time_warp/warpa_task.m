nSubject_strokes = 19;
nSubject_healthy = 5;
num_tasks = 30;
num_trial = 6;
p = 1;
% q_task_warp = q_task;
% 
% oldfolder = cd;
% cd ../
% cd 99_folder_mat
% load('task.mat');
% cd(oldfolder);
% clear oldfolder;
% s1 = q_task_warp(1).subject(1).trial(1).q_grad;

%num_trial = 6; % per la struct nuova 
tic
for i = 1:num_tasks
	for j = (1:nSubject_healthy + nSubject_strokes)
			for k = 1:num_trial
				if not(isempty(q_task_warp(i).subject(j).trial(k).q_grad))
% 					s2 =  correct2pi_err(q_task_warp(i).subject(j).trial(k).q_grad);
% 					s2_new = TimeWarping(s1,s2);
% 					q_task_warp(i).subject(j).trial(k).q_grad = s2_new;			
					q_task_warp(i).subject(j).trial(k).q_grad = correct2pi_err(q_task_warp(i).subject(j).trial(k).q_grad);
				end
			end
	end
end
toc			
			
            


