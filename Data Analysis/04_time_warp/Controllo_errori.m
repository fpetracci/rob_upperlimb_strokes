%% controlloErrori
close all;

oldfolder = cd;
cd ../
cd 99_folder_mat
load('q_task_warped.mat');
load('q_task.mat');
cd(oldfolder);
clear oldfolder;
% s1 = q_task_warp_corretto(1).subject(1).trial(1).q_grad;
%q_task_warp = q_task_warp_do;

%% resample to 240
% s1 = correct2pi_err(q_task_warp_corretto(1).subject(3).trial(1).q_grad(:,10:end));
% s1 = diff(s1')'
n_task = 1; %1 16:21 17 16:18
%tsin = timeseries(s1);
%tsout = resample(s1',250,length(s1))';
%tsout = tsout(:,6:end-5);

%s1 = tsout;
%figure(1)

%plot(s1([4 7],:)')
figure( 1)
for i = 4:24
%for j = 1:6
		
		if not(isempty(q_task(n_task).subject(i).trial(j).q_grad))
			%s2 = q_task_warp(n_task).subject(i).trial(j).q_grad(:,10:end);
			%s2 = correct2pi_err(s2);
			%s2 = q_task_warp(n_task).subject(i).trial(j).q_grad;
			%s2 = diff(s2')';
			%subplot(6,2,j*2 )
			%plot(s2([4 7],:)')
			%plot(s2_new([4 7],:)')
			
			s2 = q_task(n_task).subject(i).trial(1).q_grad;
			%s2 = diff(s2')';
			%subplot(6,2,j*2-1)
			plot(s2([4],:)','red')
			hold on
			plot(s2([7],:)','blue')
			hold on
		end
	%end
end

ylim([-180 180])
grid on
% s2 = correct2pi_err(q_task(n_task).subject(16).trial(6).q_grad(:,10:end));
% 			s2_new = TimeWarping(s1,s2);