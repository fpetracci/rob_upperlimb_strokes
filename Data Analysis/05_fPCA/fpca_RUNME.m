% This script aims to extrapulate fPCs from q_task, a structure cointaing
% all joint-angles values of a 10R arm robot reproducing the human motion
% described in the UZH dataset.

%% fpca calculation
clear all; close all; clc;
tic
% const
task_num = 30;
joint_num = 10;
obs_num = 240;
% load dummy struct;
dummy_struct1	= fpca_task(1);
fPCA_task		= repmat(dummy_struct1,1, task_num);

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
		
	end
end

toc

%% load qstacked
dummy_struct1	= fpca_stacker(1);
q_stacked_task	= repmat(dummy_struct1, 1, task_num);

for ntask = 1:task_num
	%compute fpca for current task 
	disp(['Stacking task num ' num2str(ntask)]);
	stacked_task = fpca_stacker(ntask);
	q_stacked_task(ntask) = stacked_task;
	
end

clearvars -except q_fpca_task_s q_fpca_task_h fPCA_task q_stacked_task

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
		
		% plot of angular joint
		subplot(1,2,1)
		plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,1),...
			 'Linewidth',0.5,'DisplayName','Mean of Signal')
		hold on
		plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,2),...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1')
		 plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,3),...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2')
		 plot(q_fpca_task_h(task_chosen).joint(j).qmat(:,obs,4),...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2 + fPC3')
		 
		q_stacked_plot = q_stacked_task(task_chosen).q_matrix_h(:,:,j)';
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
		xticklabels([{'1'},{'2'},{'3'},{'4'},{'5'}])
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
		
		% plot of angular joint
		subplot(1,2,1)
		plot(q_fpca_task_s(task_chosen).joint(j).qmat(:,obs,1),...
			 'Linewidth',0.5,'DisplayName','Mean of Signal')
		hold on
		plot(q_fpca_task_s(task_chosen).joint(j).qmat(:,obs,2),...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1')
		 plot(q_fpca_task_s(task_chosen).joint(j).qmat(:,obs,3),...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2')
		 plot(q_fpca_task_s(task_chosen).joint(j).qmat(:,obs,4),...
			 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2 + fPC3')
		 
		q_stacked_plot = q_stacked_task(task_chosen).q_matrix_h(:,:,j)';
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
		xticklabels([{'1'},{'2'},{'3'},{'4'},{'5'}])
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

%% anovan

var_vect_pc1 = zeros(30*10*2,1);
var_sum_h = zeros(10,1);
var_sum_s = zeros(10,1);
for i = 1:30
	ii = (i-1)*10;
	for j = 1:10
		var_tmp_h = fPCA_task(i).h_joint(j).var(1);
		var_tmp_s = fPCA_task(i).s_joint(j).var(1);
		var_vect_pc1(ii+j) = var_tmp_h;
		var_vect_pc1(30*10+ii+j) = var_tmp_s;
		var_sum_h(j) = var_sum_h(j) + fPCA_task(i).h_joint(j).var(1);
		var_sum_s(j) = var_sum_s(j) + fPCA_task(i).s_joint(j).var(1);
	end
end
var_sum_h = var_sum_h/30;
var_sum_s = var_sum_s/30;
var_sum = [var_sum_h ;var_sum_h];
%g1 = [ones(10,1); zeros(10*29+10*30,1)]; % healthy
%g2 = [zeros(30*10,1); ones(10,1); zeros(10*29,1)]; % stroke

g1 = [ones(30*10,1); zeros(30*10,1)]; % healthy
g2 = [3*ones(30*10,1); 2*ones(30*10,1)]; % stroke
p = anovan(var_vect_pc1,{g1 g2})

% g1 = [ones(10,1); zeros(10,1)]; % healthy
% g2 = [zeros(10,1); ones(10,1)]; % stroke
% [a,b] = ttest((g1.*var_sum)',(g2.*var_sum)');
% p1 = anovan(var_sum,{[g1;g1] [g2;g2]});