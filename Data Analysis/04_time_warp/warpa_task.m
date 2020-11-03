% This script is like the main of the folder.
% Time warping is performed on the entire data_set: q_task
nSubject_strokes = 19;
nSubject_healthy = 5;
num_tasks = 30;
num_trial = 6;
p = 1;
s1_index = [1,1,6; 2,1,4; 3,1,6; 4,1,1; 5,1,6; 6,1,6; 7,10,3; 8,8,5; 9,1,6; 10,10,2;...
			11,2,1; 12,4,2; 13,3,3; 14,2,2; 15,3,3; 16,5,4; 17,5,4; 18,3,2; 19,16,2; 20,1,1;...
            21,1,1; 22,1,4; 23,10,5; 24,2,2; 25,3,1; 26,3,1; 27,5,5; 28,1,1; 29,18,5; 30,2,6];
%Importing data
load('q_task.mat');

tic
for i = 1:num_tasks
		s1 = q_task(s1_index(i,1)).subject(s1_index(i,2)).trial(s1_index(i,3)).q_grad;
		s1 = correct2pi_err(s1);
		s1_new = resample(s1',250,length(s1))';
		s1_new = s1_new(:,6:end-5);
		s1 = s1_new;
                disp(i)

	for j = (1:nSubject_healthy + nSubject_strokes)
			for k = 1:num_trial
				if not(isempty(q_task_warp(i).subject(j).trial(k).q_grad))
 					s2 =  correct2pi_err(q_task_warp(i).subject(j).trial(k).q_grad(:,10:end));
 					s2_new = TimeWarping(s1,s2);
					q_task_warp(i).subject(j).trial(k).q_grad = s2_new;			
					%q_task_warp(i).subject(j).trial(k).q_grad = correct2pi_err(q_task_warp(i).subject(j).trial(k).q_grad);
				end
			end
	end
end
toc			
save q_task_warpatiENDEND.mat q_task_warp	
            	
            


