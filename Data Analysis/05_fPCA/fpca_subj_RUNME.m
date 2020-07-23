%% fpca calculation
clear all; close all; clc;
tic
% const
task_num = 30;
subj_num = 24;
joint_num = 10;
obs_num = 240;
% load dummy struct;
dummy_struct1	= fpca_task(1);
fPCA_subj		= repmat(dummy_struct1,1, subj_num);

for nsubj = 1:subj_num
	%compute fpca for current task 
	disp(['Elaborating subj num ' num2str(nsubj)]);
	struct_task = fpca_subj(nsubj);
	if nsubj <6
		fPCA_subj(nsubj).h_joint = struct_task.h_joint;
		fPCA_subj(nsubj).s_joint = [];
		fPCA_subj(nsubj).la_joint = [];
	else
		fPCA_subj(nsubj).h_joint = [];
		fPCA_subj(nsubj).s_joint = struct_task.s_joint;
		fPCA_subj(nsubj).la_joint = struct_task.la_joint;
	end
end
toc


%% plot median
for j = 1:10
	for i = 1:5
		var_h(j,:) =  mean(fPCA_subj(i).h_joint(j).var,2);
	% 	var_s1(j,:) =  fPCA_subj(1).s_joint(j).var;
	% 	var_la1(j,:) =  fPCA_subj(1).la_joint(j).var;
	end
end

% 
% % 	var_h1(j,:) =  fPCA_subj(1).h_joint(j).var;
% 	var_s(j,:) =  fPCA_subj(8).s_joint(j).var;
% 	var_la(j,:) =  fPCA_subj(8).la_joint(j).var;
% end

r = [4:7];
figure(1)
clf
hold on

for i = 6:24
	for j = 1:10
		var_s(j,:) =  fPCA_subj(i).s_joint(j).var;
		var_la(j,:) =  fPCA_subj(i).la_joint(j).var;
	end
% plot(cumsum(mean(var_la(r,:),1),2)','g')
% plot(cumsum(mean(var_s(r,:),1),2)', 'r')
%plot(cumsum(median(var_la(r,:),1),2)','g')
plot(cumsum(median(var_s(r,:),1),2)', 'r')
end

grid on
% plot(cumsum(mean(var_h(r,:),1),2)','b--' , 'Linewidth', 5)
plot(cumsum(median(var_h(r,:),1),2)','b--' , 'Linewidth', 5)

%% test
i = 6;
for j = 1:10
			var_s(j,:)	= fPCA_subj(i).s_joint(j).var';
			var_la(j,:)	= fPCA_subj(i).la_joint(j).var';
end

sdiffla(i,:) = median(cumsum(var_s(r,:),2),1) - median(cumsum(var_la(r,:),2),1)


%% diff la vs stroke median

%var_h(j,:) =  mean(fPCA_subj(i).h_joint(j).var,2);
for i = 6:24
	for j = 1:10
		var_s(j,:)	= fPCA_subj(i).s_joint(j).var';
		var_la(j,:)	= fPCA_subj(i).la_joint(j).var';
	end
	sdiffla(i-5,:) = median(cumsum(var_s(r,:),2),1) - median(cumsum(var_la(r,:),2),1);
end
plot(sdiffla')


