num_healthy_sub = 5;
num_tasks = 30;
num_trial = 3;
p = 1;


oldfolder = cd;
cd ../
cd 99_folder_mat
load('task.mat');
cd(oldfolder);
clear oldfolder;

%num_trial = 6; % per la struct nuova 
tic
for i = 2:num_tasks
	s1 = healthy_task_q(i).subject(1).left_side_trial(1).q_grad;
	for j = 1:num_healthy_sub
			for k = 1:num_trial
				s2 =  healthy_task_q(i).subject(j).left_side_trial(k).q_grad;
				s2_new = TimeWarping(s1,s2,p);
				healthy_task_q(i).subject(j).left_side_trial(k).q_grad = s2_new;
				p = p+3;
			end
			
	end
end
			
			
            


