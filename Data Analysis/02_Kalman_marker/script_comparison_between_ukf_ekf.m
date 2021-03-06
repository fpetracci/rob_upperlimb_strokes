%script_comparison_between_ukf_ekf executes EKF and UKF for a selected
%trial and compares their efficiency.

%% init
clear; clc;
load('healthy_task.mat');
load('strokes_task.mat');
trial = strokes_task(27).subject(3).left_side_trial(1);
clear healthy_task strokes_task

% % %trial = struct_dataload('P09_T23_L1'); % barbatrucco finché non abbiamo la struttura per bene... PEPOO LAVORA
% % trial = struct_dataload('H03_T11_L1'); % barbatrucco finché non abbiamo la struttura per bene... PEPOO LAVORA
% % %trial = struct_dataload('H01_T07_L1');

arms = create_arms(trial);
par = par_10R(trial);
%% load right or left side
% Rotation matrices from sens default frame (see fig 55 in MVN manual) and
% our DH driven frame on the robotic arm. 
% s stands for xsens, number for the n-frame on the robotic arm, 
% l/r left or right. 
% Example: Rs210_l is the rot matrix from hand frame of xsens to 10th frame
% of the left robotic arm described in arm.left

d_trasl = 0.05;

% left
Rs210_l = rotx(-pi/2);
Rs28_l = roty(-pi/2);
Rs26_l = rotx(+pi);
Rs23_l = rotx(pi/2 - par.theta_shoulder.left)*rotz(pi/2);

% right
Rs210_r = rotx(pi/2);
Rs28_r = roty(pi/2)*rotz(pi);
Rs26_r = eye(3); % MMMMMMMMMMMMMMMMMMMMMMM
Rs23_r = rotx(pi/2 + par.theta_shoulder.right)*rotz(pi/2); %



if 1 == 1 %trial.task_side == left
	
	arm = arms.left;
	for i=1:size(trial.Hand_L.Quat,1)
		eul_wrist_meas(:,i)		=	tr2eul(quat2rotm(trial.Hand_L.Quat(i,:))	* Rs210_l);
		eul_elbow_meas(:,i)		=	tr2eul(quat2rotm(trial.Forearm_L.Quat(i,:)) * Rs28_l);
		eul_shoulder_meas(:,i)	=	tr2eul(quat2rotm(trial.Upperarm_L.Quat(i,:))* Rs26_l);
		eul_L5_meas(:,i)		=	tr2eul(quat2rotm(trial.L5.Quat(i,:))		* Rs23_l);
	end
	

	
	eul_wrist_meas		= reshape_data(correct2pi_err(eul_wrist_meas)');
	eul_elbow_meas		= reshape_data(correct2pi_err(eul_elbow_meas)');
	eul_shoulder_meas	= reshape_data(correct2pi_err(eul_shoulder_meas)');
	eul_L5_meas			= reshape_data(correct2pi_err(eul_L5_meas)');
	
	% rotation matrix 
	for i = 1:size(trial.Hand_L.Quat,1)
		rot_wrist_meas(:,:,i)		=	quat2rotm(trial.Hand_L.Quat(i,:))	 * Rs210_l;
		rot_elbow_meas(:,:,i)		=	quat2rotm(trial.Forearm_L.Quat(i,:)) * Rs28_l;
		rot_shoulder_meas(:,:,i)	=	quat2rotm(trial.Upperarm_L.Quat(i,:))* Rs26_l;
		rot_L5_meas(:,:,i)			=	quat2rotm(trial.L5.Quat(i,:))		 * Rs23_l;
	end
	
	% positions
	pos_shoulder_meas = reshape_data(trial.Upperarm_L.Pos);
	pos_elbow_meas = reshape_data(trial.Forearm_L.Pos);
	pos_wrist_meas = reshape_data(trial.Hand_L.Pos);
	pos_L5_meas = reshape_data(trial.L5.Pos);
	
 	%T_wrist = rt2tr(rot_wrist_meas, pos_wrist_meas)	
	for i = 1:size(trial.Hand_L.Quat,1)
		T_wrist(:,:,i) = [rot_wrist_meas(:,:,i) pos_wrist_meas(:,:,i) ; 0 0 0 1];
		T_wrist_x(:,:,i) = T_wrist(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_wrist_y(:,:,i) = T_wrist(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_elbow(:,:,i) = [rot_elbow_meas(:,:,i) pos_elbow_meas(:,:,i) ; 0 0 0 1];
		T_elbow_x(:,:,i) = T_elbow(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_elbow_y(:,:,i) = T_elbow(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_shoulder(:,:,i) = [rot_shoulder_meas(:,:,i) pos_shoulder_meas(:,:,i) ; 0 0 0 1];
		T_shoulder_x(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_shoulder_y(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_L5(:,:,i) = [rot_L5_meas(:,:,i) pos_L5_meas(:,:,i) ; 0 0 0 1];
		T_L5_x(:,:,i) = T_L5(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_L5_y(:,:,i) = T_L5(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
	end
	
	pos_wrist_meas_x = T_wrist_x(1:3, 4, :);
	pos_wrist_meas_y = T_wrist_y(1:3, 4, :);
	pos_elbow_meas_x = T_elbow_x(1:3, 4, :);
	pos_elbow_meas_y = T_elbow_y(1:3, 4, :);
	pos_shoulder_meas_x = T_shoulder_x(1:3, 4, :);
	pos_shoulder_meas_y = T_shoulder_y(1:3, 4, :);
	pos_L5_meas_x = T_L5_x(1:3, 4, :);
	pos_L5_meas_y = T_L5_y(1:3, 4, :);
	
elseif 1 == 0 %trial.task_side == right
	
	arm = arms.right;
	
	for i=1:size(trial.Hand_L.Quat,1)
		eul_wrist_meas(:,i)		=	tr2eul(quat2rotm(trial.Hand_L.Quat(i,:))	* Rs210_l);
		eul_elbow_meas(:,i)		=	tr2eul(quat2rotm(trial.Forearm_L.Quat(i,:)) * Rs28_l);
		eul_shoulder_meas(:,i)	=	tr2eul(quat2rotm(trial.Upperarm_L.Quat(i,:))* Rs26_l);
		eul_L5_meas(:,i)		=	tr2eul(quat2rotm(trial.L5.Quat(i,:))		* Rs23_l);
	end
	
	eul_wrist_meas		= reshape_data(correct2pi_err(eul_wrist_meas)');
	eul_elbow_meas		= reshape_data(correct2pi_err(eul_elbow_meas)');
	eul_shoulder_meas	= reshape_data(correct2pi_err(eul_shoulder_meas)');
	eul_L5_meas			= reshape_data(correct2pi_err(eul_L5_meas)');
	
	% rotation matrix 
	for i = 1:size(trial.Hand_L.Quat,1)
		rot_wrist_meas(:,:,i)		=	quat2rotm(trial.Hand_L.Quat(i,:))	 * Rs210_l;
		rot_elbow_meas(:,:,i)		=	quat2rotm(trial.Forearm_L.Quat(i,:)) * Rs28_l;
		rot_shoulder_meas(:,:,i)	=	quat2rotm(trial.Upperarm_L.Quat(i,:))* Rs26_l;
		rot_L5_meas(:,:,i)			=	quat2rotm(trial.L5.Quat(i,:))		 * Rs23_l;
	end
	
	% positions
	pos_shoulder_meas = reshape_data(trial.Upperarm_L.Pos);
	pos_elbow_meas = reshape_data(trial.Forearm_L.Pos);
	pos_wrist_meas = reshape_data(trial.Hand_L.Pos);
	pos_L5_meas = reshape_data(trial.L5.Pos);
	
 	%T_wrist = rt2tr(rot_wrist_meas, pos_wrist_meas)	
	for i = 1:size(trial.Hand_L.Quat,1)
		T_wrist(:,:,i) = [rot_wrist_meas(:,:,i) pos_wrist_meas(:,:,i) ; 0 0 0 1];
		T_wrist_x(:,:,i) = T_wrist(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_wrist_y(:,:,i) = T_wrist(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_elbow(:,:,i) = [rot_elbow_meas(:,:,i) pos_elbow_meas(:,:,i) ; 0 0 0 1];
		T_elbow_x(:,:,i) = T_elbow(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_elbow_y(:,:,i) = T_elbow(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_shoulder(:,:,i) = [rot_shoulder_meas(:,:,i) pos_shoulder_meas(:,:,i) ; 0 0 0 1];
		T_shoulder_x(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_shoulder_y(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_L5(:,:,i) = [rot_L5_meas(:,:,i) pos_L5_meas(:,:,i) ; 0 0 0 1];
		T_L5_x(:,:,i) = T_L5(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_L5_y(:,:,i) = T_L5(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
	end
	
	pos_wrist_meas_x = T_wrist_x(1:3, 4, :);
	pos_wrist_meas_y = T_wrist_y(1:3, 4, :);
	pos_elbow_meas_x = T_elbow_x(1:3, 4, :);
	pos_elbow_meas_y = T_elbow_y(1:3, 4, :);
	pos_shoulder_meas_x = T_shoulder_x(1:3, 4, :);
	pos_shoulder_meas_y = T_shoulder_y(1:3, 4, :);
	pos_L5_meas_x = T_L5_x(1:3, 4, :);
	pos_L5_meas_y = T_L5_y(1:3, 4, :);

end
%% yMeas Generation	
yMeas = [	pos_L5_meas;		...
			pos_L5_meas_x;		...
			pos_L5_meas_y;		...
			pos_shoulder_meas;	...
			pos_shoulder_meas_x;...
			pos_shoulder_meas_y;...
			pos_elbow_meas;		...
			pos_elbow_meas_x;	...
			pos_elbow_meas_y;	...
			pos_wrist_meas;		...
			pos_wrist_meas_x;	...
			pos_wrist_meas_y];	
%% Kalman Init
t_tot = size(yMeas,3) - 10;			% number of time step in the chosen trial
q = zeros(arm.n, 1, t_tot);			% initialization of joint angles

% construction of the homogeneous transform between global frame and EE 
%frame in the first time step TgEE_i
yMeas_EE_rot = eul2r(eul_wrist_meas(:,1,1)'); % peter corke function
%yMeas_EE_rot = eul2rotm(eul_wrist_meas(:,1,1)',  'ZYZ');
yMeas_EE_pos = pos_wrist_meas(:,1,1);
TgEE_i = rt2tr(yMeas_EE_rot, yMeas_EE_pos);
q0_ikunc = arm.ikunc(TgEE_i);				

initialStateGuess = q0_ikunc;				% init vector for kalman

k = 1;										% initialization of filter step-index
k_max = 100;								% number of the vertical kalman iteration in the worst case where is not possible to reach the desidered tollerance e_tol
k_iter = zeros(1,t_tot);					% init vector to count kalman iterations for each frames

e = ones(size(yMeas,1), 1, t_tot, k_max);	% init of error vector
e_tol = 0.001;								% tolerance to break the filter iteration
% e_init = ones(size(yMeas, 1), 1);			% initialization of error

% vert filter state and cov init
xCorrected_vert = zeros(arm.n, 1, t_tot, k_max);
PCorrected_vert = zeros(arm.n, arm.n, t_tot, k_max);

% oriz filter state and cov init
xCorrected_oriz = zeros(arm.n, 1, t_tot);
PCorrected_oriz = zeros(arm.n, arm.n, t_tot);
%% parameters trials

p_cov_m			= 0.001;	% covariance of measured positions [m]
p_cov_marker	= 0.001;	% covariance of marker positions [m]
% covariance measures' matrix calculation

cov_vector_meas = [	p_cov_m			p_cov_m			p_cov_m ...			% L5
					p_cov_marker	p_cov_marker	p_cov_marker ...	% L5 x-Marker		
					p_cov_marker	p_cov_marker	p_cov_marker ...	% L5 y-Marker
					p_cov_m			p_cov_m			p_cov_m ...			% Shoulder
					p_cov_marker	p_cov_marker	p_cov_marker ...	% Shoulder x-Marker
					p_cov_marker	p_cov_marker	p_cov_marker ...	% Shoulder y-Marker
					p_cov_m			p_cov_m			p_cov_m ...			% Elbow
					p_cov_marker	p_cov_marker	p_cov_marker ...	% Elbow x-Marker
					p_cov_marker	p_cov_marker	p_cov_marker ...	% Elbow y-Marker
					p_cov_m			p_cov_m			p_cov_m ...			% Wrist
					p_cov_marker	p_cov_marker	p_cov_marker ...	% Wrist x-Marker
					p_cov_marker	p_cov_marker	p_cov_marker ...	% Wrist-- y-Marker
					];

R = diag(cov_vector_meas);

% 0.01 rad = 0.57 grad
cov_vector_q = [	0.001/2 ...	% cov associated to joint angle 1
					0.001/2 ...	% cov associated to joint angle 2
					0.001/2 ...	% cov associated to joint angle 3
					0.001 ...	% cov associated to joint angle 4
					0.001 ...	% cov associated to joint angle 5
					0.001 ...	% cov associated to joint angle 6
					0.001 ...	% cov associated to joint angle 7
					0.001 ...	% cov associated to joint angle 8
					0.001 ...	% cov associated to joint angle 9
					0.001 ...	% cov associated to joint angle 10
					];
Q = diag(cov_vector_q);


e_tol = 0.005;	
tol_nochange = 0.05;		% percent of norm
k_nochange = 0;
k_nochange_max = 10;

%% Kalman iteration EKF
fprintf('Extended Kalman iteration started! \n')
tic
filter_oriz  = extendedKalmanFilter(...
		@StateFcn,... % State transition function
		@MeasurementNoiseFcn,... % Measurement function
		initialStateGuess);
filter_oriz.MeasurementNoise = R;	% Variance of the measurement noise v[k] (21x21)
filter_oriz.ProcessNoise = Q;		% Variance of the process noise (10x10)

for t = 1:t_tot
	%oriz step kalman filter
	[xCorrected_oriz(:,:,t), PCorrected_oriz(:,:,t)] = correct(filter_oriz, yMeas(:, :, t), arm);
	predict(filter_oriz);
	
	% vertical filter definition
	filter_vert = extendedKalmanFilter(...
		@StateFcn,... % State transition function
		@MeasurementNoiseFcn,... % Measurement function
		xCorrected_oriz(:,:,t));

	filter_vert.MeasurementNoise = R;	% Variance of the measurement noise v[k] (21x21)
	filter_vert.ProcessNoise = PCorrected_oriz(:,:,t);		% Variance of the process noise (10x10)
	
	% kalman iterations
	while k < (2 * k_max)
		
		[xCorrected_vert(:,:,t,k), PCorrected_vert(:,:,t,k)] = correct(filter_vert, yMeas(:, :, t), arm);
		predict(filter_vert);
		
		e(:,:,t,k) = yMeas(:,:,t) - MeasurementFcn(filter_vert.State, arm);
		
		% exit conditions
		if k ~= 1
			if norm(e(:,:,t,k-1)- e(:,:,t,k),2) < tol_nochange*norm(e(:,:,1,k),2)
				k_nochange = k_nochange + 1;
			end
		end
		if ((norm(e(:,:,t,k),2) < e_tol) || (k >= k_max) || (k_nochange_max == k_nochange))
			break
		end
		
		% increment k iter number
		k = k + 1;
	end
	
	k_iter(:,t) = k;
	q(:,1,t) = xCorrected_vert(:,:,t,k);
	
	% save for the next time step iteration
	filter_oriz.State = xCorrected_vert(:,:,t,k);
	
	k_nochange = 0;
	k = 1;
	
end
iter_time = toc;
if iter_time > 30
	fprintf('Extended Kalman iteration takes a long time... %3.2f sec \n', iter_time)
else
	fprintf('Extended Kalman iteration took: %3.2f sec!\n', iter_time)
end
%% init plots EKF
q_rad_EKF = reshape( q, size(q,1), size(q,3), size(q,2));
q_grad_EKF = 180/pi*reshape( q, size(q,1), size(q,3), size(q,2)); %from rad to deg, reshape for having q in the right way
%% errors for plots EKF

for i = 1:t_tot
	yMeas_virt_EKF(:,i) = fkine_kalman_marker(q_rad_EKF(:,i),arm);
end

y_real = reshape(yMeas,size(yMeas,1),size(yMeas,3),size(yMeas,2));
error_EKF = y_real(:,1:size(yMeas_virt_EKF,2)) - yMeas_virt_EKF;
%plot(error')

%% Kalman iteration UKF
fprintf('Unscented Kalman iteration started! \n')
tic
filter_oriz  = unscentedKalmanFilter(...
		@StateFcn,... % State transition function
		@MeasurementNoiseFcn,... % Measurement function
		initialStateGuess);
filter_oriz.MeasurementNoise = R;	% Variance of the measurement noise v[k] (21x21)
filter_oriz.ProcessNoise = Q;		% Variance of the process noise (10x10)

for t = 1:t_tot
	%oriz step kalman filter
	[xCorrected_oriz(:,:,t), PCorrected_oriz(:,:,t)] = correct(filter_oriz, yMeas(:, :, t), arm);
	predict(filter_oriz);
	
	% vertical filter definition
	filter_vert = unscentedKalmanFilter(...
		@StateFcn,... % State transition function
		@MeasurementNoiseFcn,... % Measurement function
		xCorrected_oriz(:,:,t));

	filter_vert.MeasurementNoise = R;	% Variance of the measurement noise v[k] (21x21)
	filter_vert.ProcessNoise = PCorrected_oriz(:,:,t);		% Variance of the process noise (10x10)
	
	% kalman iterations
	while k < (2 * k_max)
		
		[xCorrected_vert(:,:,t,k), PCorrected_vert(:,:,t,k)] = correct(filter_vert, yMeas(:, :, t), arm);
		predict(filter_vert);
		
		e(:,:,t,k) = yMeas(:,:,t) - MeasurementFcn(filter_vert.State, arm);
		
		% exit conditions
		if k ~= 1
			if norm(e(:,:,t,k-1)- e(:,:,t,k),2) < tol_nochange*norm(e(:,:,1,k),2)
				k_nochange = k_nochange + 1;
			end
		end
		if ((norm(e(:,:,t,k),2) < e_tol) || (k >= k_max) || (k_nochange_max == k_nochange))
			break
		end
		
		% increment k iter number
		k = k + 1;
	end
	
	k_iter(:,t) = k;
	q(:,1,t) = xCorrected_vert(:,:,t,k);
	
	% save for the next time step iteration
	filter_oriz.State = xCorrected_vert(:,:,t,k);
	
	k_nochange = 0;
	k = 1;
	
end
iter_time = toc;
if iter_time > 30
	fprintf('Unscented Kalman iteration takes a long time... %3.2f sec \n', iter_time)
else
	fprintf('Unscented Kalman iteration took: %3.2f sec!\n', iter_time)
end
%% init plots UKF
q_rad_UKF = reshape( q, size(q,1), size(q,3), size(q,2));
q_grad_UKF = 180/pi*reshape( q, size(q,1), size(q,3), size(q,2)); %from rad to deg, reshape for having q in the right way
%% errors for plots UKF

for i = 1:t_tot
	yMeas_virt_UKF(:,i) = fkine_kalman_marker(q_rad_UKF(:,i),arm);
end

y_real = reshape(yMeas,size(yMeas,1),size(yMeas,3),size(yMeas,2));
error_UKF = y_real(:,1:size(yMeas_virt_UKF,2)) - yMeas_virt_UKF;
%plot(error')

%% Analysis

max_norm_er_EKF = zeros(size(error_EKF,1),1);
max_norm_er_UKF = zeros(size(error_UKF,1),1);

max_yMeas = yMeas(:,1,1);
min_yMeas = yMeas(:,1,1);

exc = zeros(size(error_EKF,1),1);


for i = 1:size(error_EKF,2)
	for j = 1:size(error_EKF,1)
		% EKF
		max_norm_er_EKF(j,1)= max(max_norm_er_EKF(j,1), norm(error_EKF(j,i)) );
		
		% UKF
		max_norm_er_UKF(j,1) = max(max_norm_er_UKF(j,1), norm(error_UKF(j,i)) );
		
		% non relativo all'EKF ma lo mettiamo qui lo stesso
		max_yMeas(j,1) = max(max_yMeas(j,1), yMeas(j,1,i) );
		min_yMeas(j,1) = min(min_yMeas(j,1), yMeas(j,1,i) );
		
		%
		exc(j,1) = norm(max_yMeas(j,1) - min_yMeas(j,1));
	end
end

% relative errors 
er_rel_EKF = max_norm_er_EKF./exc;
er_rel_UKF = max_norm_er_UKF./exc;
%% SYNC PLOT
% figure(1)
% 	subplot(1,2,1)
% 	title('q_{ekf} results ')
% 	subplot(1,2,2)
% 	title('q_ukf results ')
% 	
% for i=1:5:floor(t_tot)
% 	% plot of robotic arm with PC.plot
% 	subplot(1,2,1)
% 	arm.plot(q_rad_EKF(:,i)','floorlevel', 0)
% 	% plot of joint angle
% 	subplot(1,2,2)
% 	arm.plot(q_rad_UKF(:,i)','floorlevel', 0)
% 
% end
%% PLOTS
arm.plot(q_rad_EKF', 'floorlevel', 0)
arm.plot(q_rad_UKF', 'floorlevel', 0)

figure(1)
plot(q_grad_EKF')
hold on; grid on;
plot(q_grad_UKF')
title('Confronto q[grad] EKF vs UKF')

figure(2)
plot(error_EKF')
hold on; grid on;
plot(error_UKF')
title('Confronto error[m] EKF vs UKF')

figure(3)
plot(1:size(er_rel_EKF,1), er_rel_EKF, 'ro')
hold on; grid on;
plot(1:size(er_rel_UKF,1), er_rel_UKF, 'bo')
hold off
legend('EKF', 'UKF')
title('Errore rel EKF vs UKF')

figure(4)
plot(1:size(max_norm_er_EKF,1), max_norm_er_EKF, 'ro')
hold on; grid on;
plot(1:size(max_norm_er_UKF,1), max_norm_er_UKF, 'bo')
legend('EKF', 'UKF')
title('Errore max norm EKF vs UKF')

figure(5)
plot(1:size(max_norm_er_UKF,1), exc, 'go')
title('Escursione massima')


figure(4) % ZAPPA
plot((error_EKF'-error_UKF').^2)