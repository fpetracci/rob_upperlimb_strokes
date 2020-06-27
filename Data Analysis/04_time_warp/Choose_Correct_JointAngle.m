%% Function that doesn't need, we have decided to choose the 7th joint angle
	
%% this script has the objective to identify which one of the 10 joint angle maintain the same patter 

%trial = "healthy_task_q(1).subject(1).left_side_trial(1).q_grad"
correlation = zeros(2,2,10); %% contain correlation coefficient between 2 signals
max_Join_corr = zeros(1,10); %counter that takes into account which is the angle with greatest correlation for each test
max_corr = 0; % necessary to find the angle with greatest correlation
max_corr_index = 1;
max_corr_task = zeros(1,30)
%% init 
num_joint_angle = 10;
num_healthy_sub = 5;
num_tasks = 30;
tic
for k = 1:num_tasks
	for j = 1:num_healthy_sub
		for i = 1:10
			%subplot(5,2,i)
			%plot(healthy_task_q(1).subject(1).left_side_trial(1).q_grad(i,:)')
			%hold on
			trial2 = TimeWarping(healthy_task_q(k).subject(j).left_side_trial(1).q_grad(i,:),...
				healthy_task_q(k).subject(j).left_side_trial(2).q_grad(i,:));
			%plot(trial2')
			trial3 = TimeWarping(healthy_task_q(k).subject(j).left_side_trial(1).q_grad(i,:),...
				healthy_task_q(k).subject(j).left_side_trial(3).q_grad(i,:));
			%plot(trial3')
			corr1 = corrcoef(healthy_task_q(k).subject(j).left_side_trial(1).q_grad(i,:),trial2);
			corr2 = corrcoef(healthy_task_q(k).subject(j).left_side_trial(1).q_grad(i,:),trial3);
			correlation(:,:,i) = (corr1 + corr2 )/2;
			
            titleNumber = correlation(2,1,i);
			% find the index(joint angle) with greatest correlation
                    if titleNumber >= max_corr
				max_corr = titleNumber;
				max_corr_index = i;
        end
			%title(['Corr is' num2str(TitleNumber)])
		end
		max_Join_corr(max_corr_index) = max_Join_corr(max_corr_index) +1;
                max_corr = 0;
                max_corr_index = 1;
			end
end
toc
for i = 1:10
			j = 1;
			k = 1;
			subplot(5,2,i)
			plot(healthy_task_q(1).subject(1).left_side_trial(1).q_grad(i,:)')
			hold on
			trial2 = TimeWarping(healthy_task_q(k).subject(j).left_side_trial(1).q_grad(i,:),...
				healthy_task_q(k).subject(j).left_side_trial(2).q_grad(i,:));
			plot(trial2')
			trial3 = TimeWarping(healthy_task_q(k).subject(j).left_side_trial(1).q_grad(i,:),...
				healthy_task_q(k).subject(j).left_side_trial(3).q_grad(i,:));
			plot(trial3')
			corr1 = corrcoef(healthy_task_q(k).subject(j).left_side_trial(1).q_grad(i,:),trial2);
			corr2 = corrcoef(healthy_task_q(k).subject(j).left_side_trial(1).q_grad(i,:),trial3);
			correlation(:,:,i) = (corr1 + corr2 )/2;
			
            titleNumber = correlation(2,1,i);
			% find the index(joint angle) with greatest correlation
                    if titleNumber >= max_corr
						max_corr = titleNumber;
						max_corr_index = i;
					end
			title(['Corr is' num2str(TitleNumber)])
end