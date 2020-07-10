%% controlloErrori
%q_task_del = q_task;


% close all;
% n_task = 20;
% s1 = q_task(20).subject(2).trial(2).q_grad(:,10:end);
% figure(1)
% plot(s1')
% for i = 1:24
% 	for j = 1:6
% 		figure(i +1)
% 		if not(isempty(q_task(n_task).subject(i).trial(j).q_grad))
% 			s2 = correct2pi_err(q_task(n_task).subject(i).trial(j).q_grad(:,10:end));
% 			s2_new = TimeWarping(s1,s2);
% 			subplot(2,3,j)
% 			%plot(s2_new([7],:))
% 			plot(s2_new')
% 			figure(25+i)
% 			plot(s2')
% 		end
% 	end
% end

close all;
n_task = 22;
s1 = q_task(n_task).subject(10).trial(3).q_grad(:,10:end);
s1 = correct2pi_err(s1);

figure(1)
plot(s1')
for i = 1:24
	for j = 1:6
		figure(i +1)
		if not(isempty(q_task(n_task).subject(i).trial(j).q_grad))
			s2 = q_task(n_task).subject(i).trial(j).q_grad(:,10:end);
			s2 = correct2pi_err(s2);
			s2_new = TimeWarping(s1,s2);
			subplot(6,2,j *2 - 1)
			%plot(s2_new([7],:))
			plot(s2_new([4 7],:)')
			
			subplot(6,2,j * 2)
			plot(s2([4 7],:)')
		end
	end
end
s2 = correct2pi_err(q_task(n_task).subject(16).trial(6).q_grad(:,10:end));
			s2_new = TimeWarping(s1,s2);