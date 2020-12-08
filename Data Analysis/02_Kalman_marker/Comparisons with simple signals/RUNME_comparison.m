%% Intro & load
clear; clc;
load('healthy_task.mat');
load('strokes_task.mat');
trial = strokes_task(27).subject(3).left_side_trial(1);

arms = create_arms(trial);
par = par_10R(trial);

arm = arms.right;

gen_signal;

y = y_noise2;		% noise on state and on measurements

%% Filter parameters

q0 = zeros(10,1); % init state for the filters
P0	= sigma_state^2  * eye(njoints)/3;
Q	= sigma_meas^2 * eye(nmeas)/3;

%% EKF

%init
qCorr_ekf = zeros(njoints,	nsample);
PCorr_ekf = zeros(njoints,njoints,	nsample);

% iterations
tic
ekf  = extendedKalmanFilter(...
		@StateFcn,...				% State transition function
		@MeasurementNoiseFcn,...	% Measurement function
		q0);
ekf.MeasurementNoise	= Q;	% Variance of the measurement noise v[k]
ekf.ProcessNoise		= P0;	% Variance of the process noise (10x10)

for t = 1:nsample
	%Correction
	[qCorr_ekf(:,t), PCorr_ekf(:,:,t)] = correct(ekf, y(:,t), arm);
	% prediction
	predict(ekf);
end

iter_time_ekf = toc;
disp([ 'Ekf took	' num2str(iter_time_ekf) ' s'])

%% UKF
%init
qCorr_ukf = zeros(njoints,	nsample);
PCorr_ukf = zeros(njoints,njoints,	nsample);

% iterations
tic
ukf  = unscentedKalmanFilter(...
		@StateFcn,...				% State transition function
		@MeasurementNoiseFcn,...	% Measurement function
		q0);
ukf.MeasurementNoise	= Q;	% Variance of the measurement noise v[k]
ukf.ProcessNoise		= P0;	% Variance of the process noise (10x10)

for t = 1:nsample
	%Correction
	[qCorr_ukf(:,t), PCorr_ukf(:,:,t)] = correct(ukf, y(:,t), arm);
	% prediction
	predict(ukf);
end

iter_time_ukf = toc;
disp([ 'Ukf took	' num2str(iter_time_ukf) ' s'])

%% Our UKF

% init
err				= zeros(nmeas,		nsample);
qCorr_OurUkf	= zeros(njoints,	nsample);
qPred			= qCorr_OurUkf;
PCorr_OurUkf	= zeros(njoints,	njoints,	nsample);
PPred			= PCorr_OurUkf;

R = Q;
% nolock
% cov_vector_q_nolock		= deg2rad(1) * ones(10,1); 
% std deviation of noise on joint angles [rad]

cov_vector_q_nolock	= [	deg2rad(2); deg2rad(0.5); deg2rad(0.5);...
						deg2rad(0.5); deg2rad(0.5); deg2rad(0.5);...
						deg2rad(0.5); deg2rad(0.5); ...
						deg2rad(0.5); deg2rad(0.5)];
P_nolock			= diag(cov_vector_q_nolock);

tic
% iterations
for t = 1:nsample
	
	% correction step
	if t == 1
		% first step
		[y_virt, S_first, C] = ukf_virtmeas(q0, P0, arm);
		S = R + S_first;
		err(:,t) = y(:, t) - y_virt;
		
		[qCorr_OurUkf(:,t), PCorr_OurUkf(:,:,t)] = ukf_correct(...
							q0, P0, ...
							err(:,t), S, C);
	else
		[y_virt, S_first, C] = ukf_virtmeas(qPred(:,t-1), PPred(:,:,t-1), arm);
		S = R + S_first;	% additive noise on measures
		
		err(:,t) = y(:, t) - y_virt;
		[qCorr_OurUkf(:,t), PCorr_OurUkf(:,:,t)] = ukf_correct(...
							qPred(:,t-1), PPred(:,:,t-1),...
							err(:,t), S, C);
	end
	
	% prediction
	[qPred(:,t), PPred(:,:,t)] = ukf_predict(...
							qCorr_OurUkf(:,t), PCorr_OurUkf(:,t)+P_nolock);
	
	
end
iter_time_OurUkf = toc;
disp([ 'OurUkf took ' num2str(iter_time_OurUkf) ' s'])
qCorr_ekf_old = qCorr_ekf;

%% analysis
%errors
ekf_err		= vett_norm2(q_true - qCorr_ekf,2);
ukf_err		= vett_norm2(q_true - qCorr_ukf,2);
OurUkf_err	= vett_norm2(q_true - qCorr_OurUkf,2);

% plot
figure(1)
clf
for i = 1:njoints
	subplot(5,2,i)
	plot(q_true(i,:), '--k', 'DisplayName', 'True')
	title(['joint number ' num2str(i)])
	hold on
	plot(qCorr_ekf(i,:), '-r', 'DisplayName', 'EKF')
	plot(qCorr_ukf(i,:), '-c', 'DisplayName', 'UKF')
	plot(qCorr_OurUkf(i,:), '-b', 'DisplayName', 'Our UKF')
	xlabel('Time Samples')
	ylabel('Angles [rad]')
	grid on
	axis tight
	legend
end


% error plot
figure(2)
clf
plot(ekf_err, '-r', 'DisplayName', 'EKF')
title('Norm of state error')
hold on
plot(ukf_err, '-c', 'DisplayName', 'UKF')
plot(OurUkf_err, '-b', 'DisplayName', 'Our UKF')
xlabel('Time Samples')
ylabel('Norm [rad]')
grid on
axis tight
legend

% % angle j zoomed
% j = 7;
% figure(3)
% clf
% plot(q_true(j,:), '--k', 'DisplayName', 'True', 'Linewidth', 1)
% hold on
% plot(q_noise(j,:), '--r', 'DisplayName', 'With Noise')
% % plot(ukf_err, '-c', 'DisplayName', 'UKF')
% plot(qCorr_OurUkf(j,:), '-b', 'DisplayName', 'Our UKF')
% 
% title(['Angle ' num2str(j)])
% xlabel('Time Samples')
% ylabel('Angles [rad]')
% grid on
% axis tight
% legend


%means
disp([ 'EKF		has mean of error ' num2str(mean(ekf_err)) ' rad'])
disp([ 'UKF		has mean of error ' num2str(mean(ukf_err)) ' rad'])
disp([ 'OurUKF	has mean of error ' num2str(mean(OurUkf_err)) ' rad'])
