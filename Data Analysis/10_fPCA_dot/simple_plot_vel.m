% This script plots two velocity profiles to compare an healthy signal and
% a stroke-arm signal

%% intro & load
clear;clc;
load('q_task_warped_dot.mat')
load('q_task_warped.mat')
load('q_task.mat')

% parameters
ntask = 1;			% which task we want to analyse
nhealthy_subj = 1;	% which healthy subject we want to analyse
n_htrial = 1;		% which healthy trial of that task we want to take (1-6)
nstroke_subj = 6;	% which post stroke subject we want to analyse
					% 8 is dominant, should have expected behaviour
njoint = 7;			% which joint we want to show
%% signals

% velocity
htrial_vel = q_task_warp_dot(ntask).subject(nhealthy_subj).trial(n_htrial).q_grad;

for i = 1:6
	strial_vel = q_task_warp_dot(ntask).subject(nstroke_subj).trial(i).q_grad;
	if q_task_warp_dot(ntask).subject(nhealthy_subj).trial(n_htrial).stroke_task == 1
		% found a trial that is executed with stroke arm
		break
	end
end

% angles
htrial = q_task_warp(ntask).subject(nhealthy_subj).trial(n_htrial).q_grad;

for i = 1:6
	strial = q_task_warp(ntask).subject(nstroke_subj).trial(i).q_grad;
	if q_task_warp(ntask).subject(nhealthy_subj).trial(n_htrial).stroke_task == 1
		% found a trial that is executed with stroke arm
		break
	end
end

% angles pre warp
htrial_pw = q_task(ntask).subject(nhealthy_subj).trial(n_htrial).q_grad;

for i = 1:6
	strial_pw = q_task(ntask).subject(nstroke_subj).trial(i).q_grad;
	if q_task_warp(ntask).subject(nhealthy_subj).trial(n_htrial).stroke_task == 1
		% found a trial that is executed with stroke arm
		break
	end
end

%% plot a single joint velocity

figure(1)
clf;
plot(htrial_vel(njoint,:),'-b', 'linewidth', 1, 'DisplayName', 'Healthy')
hold on
plot(strial_vel(njoint,:),'-r', 'linewidth', 1, 'DisplayName', 'Stroke')
grid on
legend
title(['H-Subj ' num2str(nhealthy_subj) ' & S-Subj ' num2str(nstroke_subj) ' on joint ' num2str(njoint) ' doing task ' num2str(ntask)])
axis tight
ylabel(' Velocity [deg/s] ')
xlabel(' Time samples ')

%%  plot the single joint angle signal
figure(2)
clf;
plot(htrial(njoint,:),'-b', 'linewidth', 1, 'DisplayName', 'Healthy')
hold on
plot(strial(njoint,:),'-r', 'linewidth', 1, 'DisplayName', 'Stroke')
grid on
legend
title(['H-Subj ' num2str(nhealthy_subj) ' & S-Subj ' num2str(nstroke_subj) ' on joint ' num2str(njoint) ' doing task ' num2str(ntask)])
axis tight
ylabel(' Angle [deg] ')
xlabel(' Time samples ')

%% plot the original(prewarp) single joint angle signal
figure(3)
clf;
plot(htrial_pw(njoint,:),'-b', 'linewidth', 1, 'DisplayName', 'Healthy')
hold on
plot(strial_pw(njoint,:),'-r', 'linewidth', 1, 'DisplayName', 'Stroke')
grid on
legend
title(['H-Subj ' num2str(nhealthy_subj) ' & S-Subj ' num2str(nstroke_subj) ' on joint ' num2str(njoint) ' doing task ' num2str(ntask)])
axis tight
ylabel(' Angle [deg] ')
xlabel(' Time samples ')

%% plot some number of joint signal
figure(4)
clf;
hold on
for i = 1:6
	temph = q_task_warp(ntask).subject(nhealthy_subj).trial(i).q_grad;
	temps = q_task_warp(ntask).subject(nstroke_subj).trial(i).q_grad;
	plot(temph(njoint,:),'-b', 'linewidth', 1)
	
	if q_task_warp(ntask).subject(nstroke_subj).trial(i).stroke_task == 1
		plot(temps(njoint,:),'-r', 'linewidth', 1)
	else
		plot(temps(njoint,:),'-g', 'linewidth', 1)
	end
	grid on
	legend('Healthy', 'Stroke', 'Less Affected')
	title(['H-Subj ' num2str(nhealthy_subj) ' & S-Subj ' num2str(nstroke_subj) ' on joint ' num2str(njoint) ' doing task ' num2str(ntask)])
	axis tight
	ylabel(' Angle [deg] ')
	xlabel(' Time samples ')
end

