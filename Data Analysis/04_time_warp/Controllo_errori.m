%% controlloErrori
close all;

%% resample to 240
s1 = correct2pi_err(q_task(26).subject(3).trial(1).q_grad(:,10:end));
n_task = 26;
%tsin = timeseries(s1);
tsout = resample(s1',250,length(s1))';
tsout = tsout(:,6:end-5);

s1 = tsout;
figure(1)
plot(s1([4 7],:)') 
%%

for i = 1:24
	for j = 1:6
		figure(i + 1)
		if not(isempty(q_task(n_task).subject(i).trial(j).q_grad))
			s2 = q_task(n_task).subject(i).trial(j).q_grad(:,10:end);
			s2 = correct2pi_err(s2);
			
			s2_new = q_task_warp(n_task).subject(i).trial(j).q_grad(:,10:end);
			subplot(6,2,j*2 - 1)
			%plot(s2_new([7],:))
			plot(s2_new([4 7],:)')
			
			subplot(6,2,j * 2)
			plot(s2([4 7],:)')
		end
	end
end
s2 = correct2pi_err(q_task(n_task).subject(16).trial(6).q_grad(:,10:end));
			s2_new = TimeWarping(s1,s2);