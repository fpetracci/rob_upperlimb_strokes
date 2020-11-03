function TW_checking(n_task)
%plot of the angles deriving from the execution of task number n_task in 2 figures 
%to show the difference after the application of TW
close all;
load('q_task_warped.mat');
load('q_task.mat');
%%
figure(1)
for i=1:24
	if not(isempty(q_task(n_task).subject(i).trial(1).q_grad))
		s2 = q_task(n_task).subject(i).trial(1).q_grad;
		plot(s2([4],:)','red')
		hold on
		plot(s2([7],:)','blue')
	end
end
figure(2)
for i=1:24
	if not(isempty(q_task_warp(n_task).subject(i).trial(1).q_grad))
		s2 = q_task_warp(n_task).subject(i).trial(1).q_grad;
		plot(s2([4],:)','red')
		hold on
		plot(s2([7],:)','blue')
	end
end
%% If you want to view the angles of each patient for each of the trials, uncomment this block
%plot of the angles resulting from the execution of task number n_task divided for each trial
% 24 plot, one for each subject
% for i = 1:24
% 	for j = 1:6
% 		figure(i + 2)
% 		if not(isempty(q_task(n_task).subject(i).trial(j).q_grad))
% 			s2 = q_task(n_task).subject(i).trial(j).q_grad(:,10:end);
% 			s2 = correct2pi_err(s2);
% 			s2_new = q_task_warp(n_task).subject(i).trial(j).q_grad(:,10:end);
% 			% Plot angle warped
% 			subplot(6,2,j*2 - 1)
% 			plot(s2_new([4 7],:)')
% 			% Plot angle  not-warped
% 			subplot(6,2,j * 2)
% 			plot(s2([4 7],:)')
% 		end
% 	end
% end
ylim([-180 180])
grid on
end
