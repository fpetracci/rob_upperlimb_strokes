% This script aims to compare joint angle

clear all; clc; close all;
tic
load('q_task_warped.mat');

[njoints, nsamples] = size(q_task_warp(1).subject(1).trial(1).q_grad);

n_outlier_h		= 0;
n_outlier_s		= 0;
n_outlier_la	= 0;

%% healthy fig
figure(1)
clf
for ntask = 1:30
	disp(['Plotting task num ' num2str(ntask)])
	
	hold on
	for nsubj = 1:5
		
		for ntrial = 1:6
			if ~isempty(q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad)
				q = q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad;
				if check_trial(q)
					for j = 1:njoints
						subplot(2,5,j)
						hold on
						title(['joint angle' num2str(j)])
						legend_str = ['subj ' num2str(nsubj) ' trial ' num2str(ntrial)];
						plot(q(j,:),'DisplayName', legend_str);
					end
				else 
					n_outlier_h = n_outlier_h +1;
				end
			else
				% do nothing empty trial
			end
		end
		
	end
	
end
drawnow

%% stroke fig
figure(2)
clf
for ntask = 1:30
	disp(['Plotting task num ' num2str(ntask)])
	
	hold on
	for nsubj = 6:24
		
		for ntrial = 1:6
			if ~isempty(q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad)
				if q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 1
					q = q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad;
					if check_trial(q)
						for j = 1:njoints
							subplot(2,5,j)
							hold on
							title(['joint angle' num2str(j)])
							legend_str = ['subj ' num2str(nsubj) ' trial ' num2str(ntrial)];
							plot(q(j,:),'DisplayName', legend_str);
						end
					else
						n_outlier_s = n_outlier_s + 1;
					end
				else
					% do nothing
				end
			else
				% do nothing
			end
		end
		
	end
	
end
drawnow

%% less affected fig
figure(3)
clf
for ntask = 1:30
	disp(['Plotting task num ' num2str(ntask)])
	hold on
	for nsubj = 6:24
		
		for ntrial = 1:6
			if ~isempty(q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad)
				if q_task_warp(ntask).subject(nsubj).trial(ntrial).stroke_task == 0
					q = q_task_warp(ntask).subject(nsubj).trial(ntrial).q_grad;
					if check_trial(q)
						for j = 1:njoints
							subplot(2,5,j)
							hold on
							title(['joint angle' num2str(j)])
							legend_str = ['subj ' num2str(nsubj) ' trial ' num2str(ntrial)];
							plot(q(j,:),'DisplayName', legend_str);
						end
					else
						n_outlier_la = n_outlier_la +1;
					end
				else
					% do nothing
				end
			else
				%do nothing
			end
		end
		
	end
	
end
drawnow

n_outlier_tot = n_outlier_h + n_outlier_la + n_outlier_s;

toc