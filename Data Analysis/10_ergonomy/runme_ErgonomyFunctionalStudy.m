% script to check ergonomy functional between some tasks

%% load
clear; clc; close;

oldfolder = cd;
cd ../
cd 99_folder_mat
%load('healthy_task.mat');
%load('strokes_task.mat');
load('q_task.mat');
% load q warped
cd(oldfolder);
clear oldfolder;

%% choose 
ntask	= 7;
h_subj	= 1;
s_subj	= 3+5;		% first five subjects are healthy ones
ntrial	= 1;		% 1 to 3 left side, 4 to 6 right side

ts = 1/60;

%% figure 1 healthy subject

q_trial_h	= q_task(ntask).subject(h_subj).trial(ntrial).q_grad(:,[10:end]);
J_h			= J_ergo(q_trial_h);
mean_J_h	= mean(J_h);

figure(1)
clf
hold on
title('Healthy subject')

plot((1:size(q_trial_h,2))*ts, J_h, 'DisplayName','Ergonomy Functional')
plot((1:size(q_trial_h,2))*ts, mean(J_h) * ones(size(q_trial_h,2),1), 'DisplayName','Mean')
text(size(q_trial_h,2)*ts/2, mean(J_h)/2,['Mean = ' num2str(mean(J_h),4)])
%plot((1:size(q_trial_h,2))*ts, J_ergo(q_trial_h, diag([0 0 0 1 1 1 1 1 1 1])), 'DisplayName','Velocity Norm')

xlabel('Time [s]')
ylabel('Ergonomy Functional [rad^2 / s^2]')
legend
grid on
axis([0, size(q_trial_h, 2)*ts, 0, max(J_h)])
set(gca,'FontSize',20)
set(findall(gcf,'type','text'),'FontSize',20)
hold off						
						

%% figure 2 stroke subject

q_trial_s	= q_task(ntask).subject(s_subj).trial(ntrial).q_grad(:,[10:end]);
J_s			= J_ergo(q_trial_s);
mean_J_s	= mean(J_s);

figure(2)
clf
hold on
if q_task(ntask).subject(s_subj).trial(ntrial).stroke_task == 1
	title('Stroke subject, done with stroke arm')
else
	title('Stroke subject, done with healthy arm')
end

plot((1:size(q_trial_s,2))*ts, J_s, 'DisplayName','Ergonomy Functional')
plot((1:size(q_trial_s,2))*ts, mean(J_s) * ones(size(q_trial_s,2),1), 'DisplayName','Mean')
text(size(q_trial_s,2)*ts/2, mean(J_s)/2,['Mean = ' num2str(mean(J_s),4)])
%plot((1:size(q_trial_s,2))*ts, J_ergo(q_trial_s, diag([0 0 0 1 1 1 1 1 1 1])), 'DisplayName','Velocity Norm')

xlabel('Time [s]')
ylabel('Ergonomy Functional [rad^2 / s^2]')
legend
grid on
axis([0, size(q_trial_s, 2)*ts, 0, max(J_s)])
set(gca,'FontSize',20)
set(findall(gcf,'type','text'),'FontSize',20)
hold off						

