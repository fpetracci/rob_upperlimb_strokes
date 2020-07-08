%% controlloErrori
<<<<<<< HEAD
n_task = 22;
% q_task_del = q_task;


close all;
n_task = 22;
s1 = q_task(22).subject(7).trial(2).q_grad;

for i = 1:24
	for j = 1:6
		figure(i)
		if not(isempty(q_task(n_task).subject(i).trial(j).q_grad))

			s2 = correct2pi_err(q_task(n_task).subject(i).trial(j).q_grad);
			s2_new = TimeWarping(s1,s2);
			subplot(2,3,j)
			%plot(s2_new([7],:))
			plot(s2_new')
>>>>>>> Correct Controllo_errori and warpa_task
		end
	end
end