%% controlloErrori
n_task = 26;
s1 = q_task(n_task).subject(1).trial(1).q_grad;
for i = 1:10
	for j = 1:6
		figure(i)
		if not(isempty(q_task(n_task).subject(i).trial(j).q_grad))
			s2 = q_task(n_task).subject(i).trial(j).q_grad;
			s2_new = TimeWarping(s1,s2);
			subplot(2,3,j)
			plot(s2_new([7],:))
		end
	end
end