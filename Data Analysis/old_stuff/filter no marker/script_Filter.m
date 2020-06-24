%% init
clear; clc;

trial = struct_dataload('H01_T07_L1'); % barbatrucco finché non abbiamo la struttura per bene... PEPOO LAVORA
%trial = struct_dataload('H03_T11_L1'); % barbatrucco finché non abbiamo la struttura per bene... PEPOO LAVORA

arms = create_arms(trial);
par = par_10R(trial);
%% load
% Rotation matrices from sens default frame (see fig 55 in MVN manual) and
% our DH driven frame on the robotic arm. 
% s stands for xsens, number for the n-frame on the robotic arm, 
% l/r left or right. 
% Example: Rs210_l is the rot matrix from hand frame of xsens to 10th frame
% of the left robotic arm described in arm.left

Rs210_l = rotx(-pi/2);
Rs28_l = rotz(pi)*rotx(pi);
Rs26_l = rotx(pi)*rotz(-pi/2);
Rs23_l = roty(pi/2)*rotz(pi-par.theta_shoulder.left);


if 1 == 1 %trial.task_side == left
	
	arm = arms.left;
	
	
	% euler angles
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
	
	% positions
	pos_shoulder_meas = reshape_data(trial.Upperarm_L.Pos);
	pos_elbow_meas = reshape_data(trial.Forearm_L.Pos);
	pos_wrist_meas = reshape_data(trial.Hand_L.Pos);
	

elseif 1 == 0 %trial.task_side == right
	
	arm = arms.right;
	
	error('NON ANCORA SVILUPPATO')

end
%% yMeas Generation
% Virtual measurement vector, copied here for reference
% yk = [	eul_L5; ...
% 		tr_shoulder; ...
% 		eul_shoulder; ...
% 		tr_elbow; ...
% 		eul_elbow; ...
% 		tr_wrist; ...
% 		eul_wrist];
% 
% yMeas = [	eul_L5_meas;		...
% 			pos_shoulder_meas;	...
% 			eul_shoulder_meas;	...
% 			pos_elbow_meas;		...
% 			eul_elbow_meas;		...
% 			pos_wrist_meas;		...
% 			eul_wrist_meas];
		
yMeas = [	eul_L5_meas;		...
			pos_shoulder_meas;	...
			eul_shoulder_meas;	...
			pos_elbow_meas;		...
			eul_elbow_meas;		...
			pos_wrist_meas;		...
			eul_wrist_meas];
%% Kalman Init
t_tot = size(yMeas,3) - 10;						% number of time step in the chosen trial
q = zeros(arm.n, 1, t_tot);					% initialization of joint angles

% construction of the homogeneous transform between global frame and EE 
%frame in the first time step TgEE_i
yMeas_EE_rot = eul2r(eul_wrist_meas(:,1,1)'); % peter corke function
%yMeas_EE_rot = eul2rotm(eul_wrist_meas(:,1,1)',  'ZYZ');
yMeas_EE_pos = pos_wrist_meas(:,1,1);
TgEE_i = rt2tr(yMeas_EE_rot, yMeas_EE_pos);

q0_ikunc = arm.ikunc(TgEE_i);				% init vector for kalman
initialStateGuess = q0_ikunc;

k = 1;										% initialization of filter step-index
k_max = 100;								% number of the vertical kalman iteration in the worst case where is not possible to reach the desidered tollerance e_tol
k_iter = zeros(1,t_tot);					% init vector to count kalman iterations for each frames

e = ones(size(yMeas,1), 1, t_tot, k_max);	% init of error vector
e_tol = 0.001;								% tolerance to break the filter iteration
% e_init = ones(size(yMeas, 1), 1);			% initialization of error

xCorrected = zeros(arm.n, 1, t_tot, k_max);
PCorrected = zeros(arm.n, arm.n, t_tot, k_max);
R = 0.5;										% Variance of the measurement noise v[k]
Q = 0.1;										% Variance of the process noise
%% PROVE PARAMETRI

a_cov_m = 10*pi/180;		% covariance of measured angles
p_cov_m = 0.001;	% covariance of measured positions

% covariance measures' matrix calculation

cov_vector_meas = [	a_cov_m a_cov_m a_cov_m ...
					p_cov_m p_cov_m p_cov_m ...
					a_cov_m a_cov_m a_cov_m ...
					p_cov_m p_cov_m p_cov_m ...
					a_cov_m a_cov_m a_cov_m ...
					p_cov_m p_cov_m p_cov_m ...
					a_cov_m a_cov_m a_cov_m ...
					];
				
R = eye(size(yMeas,1));	% Variance of the measurement noise v[k]
R = cov_vector_meas.*R;

cov_vector_q = [	0.001 ... % cov associated to joint angle 1
					0.001 ... % cov associated to joint angle 2
					0.001 ... % cov associated to joint angle 3
					0.001 ... % cov associated to joint angle 4
					0.001 ... % cov associated to joint angle 5
					0.001 ... % cov associated to joint angle 6
					0.001 ... % cov associated to joint angle 7
					0.001 ... % cov associated to joint angle 8
					0.001 ... % cov associated to joint angle 9
					0.001 ... % cov associated to joint angle 10
					];
				% 0.01 rad = 0.57 grad
				
Q = eye(arm.n);			% Variance of the process noise
Q = cov_vector_q.*Q;

e_tol = 0.005;	
tol_nochange = 0.05;		% percent of norm
k_nochange = 0;
k_nochange_max = 5;
%% Kalman iteration
tic
for t = 1:t_tot
	% filter definition
	filter = unscentedKalmanFilter(...
		@StateFcn,... % State transition function
		@MeasurementNoiseFcn,... % Measurement function
		initialStateGuess);

	filter.MeasurementNoise = R;	% Variance of the measurement noise v[k] (21x21)
	filter.ProcessNoise = Q;		% Variance of the process noise (10x10)
		
	% kalman iterations
	while k < (2 * k_max)
		
		[xCorrected(:,:,t,k), PCorrected(:,:,t,k)] = correct(filter, yMeas(:, :, t), arm);
		predict(filter);
		
		e(:,:,t,k) = yMeas(:,:,t) - MeasurementFcn(filter.State, arm);
		
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
	q(:,1,t) = xCorrected(:,:,t,k);

	% save for the next time step iteration
	initialStateGuess = xCorrected(:,:,t,k);
	
	k_nochange = 0;
	k = 1;
	
end
toc
%% init plots
q_rad = reshape( q, size(q,1), size(q,3), size(q,2));
q_grad = 180/pi*reshape( q, size(q,1), size(q,3), size(q,2)); %from rad to deg, reshape for having q in the right way