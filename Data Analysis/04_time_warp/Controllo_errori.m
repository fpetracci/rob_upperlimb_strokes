%% controlloErrori
n_task = 22;
% q_task_del = q_task;

s1 = q_task(22).subject(23).trial(1).q_grad(:,10:end);
for i = 1:24
	for j = 1:6
		figure(i)
		if not(isempty(q_task(n_task).subject(i).trial(j).q_grad))
			s2 = q_task(n_task).subject(i).trial(j).q_grad(:,10:end);
			s2_new = TimeWarping(s1,s2);
			subplot(2,3,j)
			plot(s2_new(:,:)')
		end
	end
end