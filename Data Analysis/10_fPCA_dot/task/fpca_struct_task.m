% This script aims to extrapulate fPCs from q_task, a structure cointaing
% all joint-angles values of a 10R arm robot reproducing the human motion
% described in the UZH dataset.

% NOTE: due to later improvement, the mean (in time) was removed from
% signals during fpca calculations. This is why in reconstruction plots the 
% mean signal is recalculated and added manually.

%% fpca calculation
clear all; close all; clc;
tic
% load dummy struct;
task_num = 30;
joint_num = 10;
dummy_struct1	= fpca_task(1);
fPCA_task		= repmat(dummy_struct1,1, task_num);
% const
obs_num = size(dummy_struct1.h_joint(1).val_pc,1);

for ntask = 1:task_num
	%compute fpca for current task 
	disp(['Elaborating task num ' num2str(ntask)]);
	struct_task = fpca_task(ntask);
	fPCA_task(ntask) = struct_task;
	
end
toc

%% reconstruct q
tic 

[qmat, qmat_separated] = fpca2q(fPCA_task(1).h_joint(1));
dummy_struct1 = struct('qmat', [], 'qmat_separated', [] );
dummy_struct2 = struct('joint', repmat(dummy_struct1, 1, joint_num));
q_fpca_task = repmat(dummy_struct2, 1, task_num);

q_fpca_task_s = q_fpca_task;
q_fpca_task_h = q_fpca_task;
q_fpca_task_la = q_fpca_task;

for i = 1:task_num
	for j = 1:joint_num
		single_struct_h = fPCA_task(i).h_joint(j);
		[qmat, qmat_separated] = fpca2q(single_struct_h);
		q_fpca_task_h(i).joint(j).qmat = qmat;
		q_fpca_task_h(i).joint(j).qmat_separated = qmat_separated;
		
		single_struct_s = fPCA_task(i).h_joint(j);
		[qmat, qmat_separated] = fpca2q(single_struct_s);
		q_fpca_task_s(i).joint(j).qmat = qmat;
		q_fpca_task_s(i).joint(j).qmat_separated = qmat_separated;
		
		single_struct_la = fPCA_task(i).la_joint(j);
		[qmat, qmat_separated] = fpca2q(single_struct_la);
		q_fpca_task_la(i).joint(j).qmat = qmat;
		q_fpca_task_la(i).joint(j).qmat_separated = qmat_separated;
		
	end
end

toc

%% load qstacked
dummy_struct1	= fpca_stacker_task(1);
q_stacked_task	= repmat(dummy_struct1, 1, task_num);

for ntask = 1:task_num
	%compute fpca for current task 
	disp(['Stacking task num ' num2str(ntask)]);
	stacked_task = fpca_stacker_task(ntask);
	q_stacked_task(ntask) = stacked_task;
	
end

clearvars -except q_fpca_task_s q_fpca_task_h q_fpca_task_la fPCA_task q_stacked_task

%% plots 1 obs h
close all
task_chosen = 1;
obs = 1;

% for j = 1:10
% 	figure(j)
% 	for i = 1:4
% 		subplot(2,4,i)
% 		plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,i))
% 		hold on
% 		q_stacked_plot = q_stacked_task(task_chosen).q_matrix_h(:,:,j)';
% 		plot(q_stacked_plot(:,obs))
% 		title(['Joint number ' num2str(j)]);
% 
% 		subplot(2,4,i+4)
% 		plot(q_fpca_task_h(task_chosen).joint(j).qmat_separated(:,obs,i))
% 		hold on
% 		q_stacked_plot = q_stacked_task(task_chosen).q_matrix_h(:,:,j)';
% 		plot(q_stacked_plot(:,obs))
% 		title(['Joint number ' num2str(j)]);
% 
% 	end
% end

for j = 1:10
		figure(j)
		%figure('Renderer', 'painters', 'Position', [10 10 1900 1000])
		clf
		q_stacked_plot = q_stacked_task(task_chosen).q_matrix_h(:,:,j)';
		
		% "new" mean calculation		
		mean_mat	= mean(q_stacked_task(task_chosen).q_matrix_h,2); 
		mean_tmp	= mean_mat(obs,1,j);
		
		% plot of angular joint
		subplot(1,2,1)
		
		% mean is removed from signal, we'll add it manually after fpca
		%plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,1),...
		%	 'Linewidth',0.5,'DisplayName','Mean of Signal')
		
		plot(mean_tmp* ones(1,size(q_stacked_task(task_chosen).q_matrix_h,2)),...
			 'Linewidth',0.5,'DisplayName','Mean of Signal')
		
		hold on
		plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,2)+mean_tmp,...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1')
		 plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,3)+mean_tmp,...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2')
		 plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,4)+mean_tmp,...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2 + fPC3')
		 
		
		plot(q_stacked_plot(:,obs), ...
			'k--', 'Linewidth',1.5,'DisplayName','Actual Signal')
		legend('Location','best')
		xlabel('Time samples')
		ylabel(' Angular Value [grad]')
		xlim([1 length(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,1))])
		grid on
		title(['Joint number ' num2str(j)]);
		
		fontsize = 12;
		set(gca,'FontSize',fontsize)
		set(findall(gcf,'type','text'),'FontSize',fontsize)
		hold off	
		
		
		
		% pareto
		subplot(1,2,2)
		var_list = fPCA_task(task_chosen).h_joint(j).var;
		pareto2(var_list);
		%hold on, %errorbar(mean(var_list),std(var_list))
		title('Variance Explanations')
		lgd = legend({'Variance','Cumulative Variance'},'FontSize', fontsize,'TextColor','black', 'Location', 'east');
		%lgd.Position = [0.5 0.5 0.1433 0.1560];

		%legend('Variance', 'Cumulative Variance')
		axis([0 (length(var_list)+1) 0 1])
		xlabel('fPC')
		ylabel('Explained Variance')
		xticks([1:length(var_list)])
		yticks([0:0.1:1])
		%xticklabels([{'1'},{'2'},{'3'},{'4'},{'5'}])
		%yticklabels([{'0%'},{'10%'},{'20%'},{'30%'},{'40%'},{'50%'},{'60%'},{'70%'},{'80%'},{'90%'},{'100%'}])
		grid on
		

% 		subplot(1,2,i+4)
% 		plot(q_fpca_task_h(task_chosen).joint(j).qmat_separated(:,obs,i))
% 		hold on
% 		q_stacked_plot = q_stacked_task(task_chosen).q_matrix_h(:,:,j)';
% 		plot(q_stacked_plot(:,obs))
% 		title(['Joint number ' num2str(j)]);


end
%% plots 1 obs s
task_chosen = 1;
obs = 1;

% for j = 1:10
% 	figure(j)
% 	for i = 1:4
% 		subplot(2,4,i)
% 		plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,i))
% 		hold on
% 		q_stacked_plot = q_stacked_task(task_chosen).q_matrix_h(:,:,j)';
% 		plot(q_stacked_plot(:,obs))
% 		title(['Joint number ' num2str(j)]);
% 
% 		subplot(2,4,i+4)
% 		plot(q_fpca_task_h(task_chosen).joint(j).qmat_separated(:,obs,i))
% 		hold on
% 		q_stacked_plot = q_stacked_task(task_chosen).q_matrix_h(:,:,j)';
% 		plot(q_stacked_plot(:,obs))
% 		title(['Joint number ' num2str(j)]);
% 
% 	end
% end

for j = (10+1):(10+10)
		figure(j)
		j = j-10;
		%figure('Renderer', 'painters', 'Position', [10 10 1900 1000])
		clf
		
		q_stacked_plot = q_stacked_task(task_chosen).q_matrix_h(:,:,j)';
		% "new" mean calculation
		mean_mat	= mean(q_stacked_task(task_chosen).q_matrix_h,2);
		mean_tmp	= mean_mat(obs,1,j);
		
		% plot of angular joint
		subplot(1,2,1)
		plot(mean_tmp* ones(1,size(q_stacked_task(task_chosen).q_matrix_h,2)),...
			 'Linewidth',0.5,'DisplayName','Mean of Signal')
		hold on
		plot(q_fpca_task_s(task_chosen).joint(j).qmat(:,obs,2)+mean_tmp,...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1')
		 plot(q_fpca_task_s(task_chosen).joint(j).qmat(:,obs,3)+mean_tmp,...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2')
		 plot(q_fpca_task_s(task_chosen).joint(j).qmat(:,obs,4)+mean_tmp,...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2 + fPC3')
		 
		
		plot(q_stacked_plot(:,obs), ...
			'k--', 'Linewidth',1.5,'DisplayName','Actual Signal')
		legend('Location','best')
		xlabel('Time samples')
		ylabel(' Angular Value [grad]')
		xlim([1 length(q_fpca_task_s(task_chosen).joint(j).qmat(:,obs,1))])
		grid on
		title(['Joint number ' num2str(j)]);
		
		fontsize = 12;
		set(gca,'FontSize',fontsize)
		set(findall(gcf,'type','text'),'FontSize',fontsize)
		hold off	
		
		
		
		% pareto
		subplot(1,2,2)
		var_list = fPCA_task(task_chosen).s_joint(j).var;
		pareto2(var_list);
		%hold on, %errorbar(mean(var_list),std(var_list))
		title('Variance Explanations')
		lgd = legend({'Variance','Cumulative Variance'},'FontSize', fontsize,'TextColor','black', 'Location', 'east');
		%lgd.Position = [0.5 0.5 0.1433 0.1560];

		%legend('Variance', 'Cumulative Variance')
		axis([0 (length(var_list)+1) 0 1])
		xlabel('fPC')
		ylabel('Explained Variance')
		xticks([1:length(var_list)])
		yticks([0:0.1:1])
		%xticklabels([{'1'},{'2'},{'3'},{'4'},{'5'}])
		%yticklabels([{'0%'},{'10%'},{'20%'},{'30%'},{'40%'},{'50%'},{'60%'},{'70%'},{'80%'},{'90%'},{'100%'}])
		grid on
		

% 		subplot(1,2,i+4)
% 		plot(q_fpca_task_h(task_chosen).joint(j).qmat_separated(:,obs,i))
% 		hold on
% 		q_stacked_plot = q_stacked_task(task_chosen).q_matrix_h(:,:,j)';
% 		plot(q_stacked_plot(:,obs))
% 		title(['Joint number ' num2str(j)]);


end
%

