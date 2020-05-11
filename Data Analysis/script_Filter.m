clear; close; clc;


% loading data
trial = struct_dataload('H01_T07_L1'); % barbatrucco finché non abbiamo la struttura per bene... PEPOO LAVORA

arms = create_arms(trial);

% Measurement vector, copied here for reference
% yk = [	eul_L5; ...
% 		tr_shoulder; ...
% 		eul_shoulder; ...
% 		tr_elbow; ...
% 		eul_elbow; ...
% 		tr_wrist; ...
% 		eul_wrist];
			
if 1 == 1 %trial.task_side == left
	
	arm = arms.left;
	
	% construction of measurement vector 
	eul_L5_meas = reshape_data(tr2eul(quat2rotm(trial.L5.Quat) ));
	eul_shoulder_meas = reshape_data(tr2eul(quat2rotm(trial.Upperarm_L.Quat) ));
	eul_elbow_meas = reshape_data(tr2eul(quat2rotm(trial.Forearm_L.Quat) ));
	eul_wrist_meas = reshape_data(tr2eul(quat2rotm(trial.Hand_L.Quat) ));
	
	pos_shoulder_meas = reshape_data(trial.Upperarm_L.Pos);
	pos_elbow_meas = reshape_data(trial.Forearm_L.Pos);
	pos_wrist_meas = reshape_data(trial.Hand_L.Pos);
	

elseif 1 == 0 %trial.task_side == right
	
	arm = arms.right;
	
	% construction of measurement vector 
	eul_L5_meas = reshape_data(tr2eul(quat2rotm(trial.L5.Quat) ));
	eul_shoulder_meas = reshape_data(tr2eul(quat2rotm(trial.Upperarm_R.Quat) ));
	eul_elbow_meas = reshape_data(tr2eul(quat2rotm(trial.Forearm_R.Quat) ));
	eul_wrist_meas = reshape_data(tr2eul(quat2rotm(trial.Hand_R.Quat) ));
	
	pos_shoulder_meas = reshape_data(trial.Upperarm_R.Pos);
	pos_elbow_meas = reshape_data(trial.Forearm_R.Pos);
	pos_wrist_meas = reshape_data(trial.Hand_R.Pos);


end

% general variables outside chosing left or right
yMeas = [	eul_L5_meas;		...
			pos_shoulder_meas;	...
			eul_shoulder_meas;	...
			pos_elbow_meas;		...
			eul_elbow_meas;		...
			pos_wrist_meas;		...
			eul_wrist_meas];
yMeas_EE_rot = yMeas(end-2:end, 1, 1)';
yMeas_EE_pos = yMeas(end-5:end-3, 1, 1);

% homogeneous transform between global frame and EE frame in the first time
% step
TgEE_i = rt2tr(eul2rotm(yMeas_EE_rot), yMeas_EE_pos);


%% KALMAN VERTICALE

% init
t_tot = size(yMeas,3);						% number of time step in the chosen trial
q = zeros(arm.n, 1, t_tot);					% initialization of joint angles
initialStateGuess = arm.ikunc(TgEE_i);		% init vector for kalman

k = 1;										% initialization of filter step-index
k_max = 100;								% number of the vertical kalman iteration in the worst case where is not possible to reach the desidered tollerance e_tol
k_iter = zeros(1,t_tot);					% init vector to count kalman iterations for each frames

e = ones(size(yMeas,1), 1, t_tot, k_max);	% init of error vector
e_tol = 0.01;								% tolerance to break the filter iteration
% e_init = ones(size(yMeas, 1), 1);			% initialization of error

xCorrected = zeros(arm.n, 1, t_tot, k_max);
PCorrected = zeros(arm.n, arm.n, t_tot, k_max);
R = 1;										% Variance of the measurement noise v[k]
Q = 1;										% Variance of the process noise

for t = 1:t_tot
	% e(:,:,t,1) = e_init;

	filter = extendedKalmanFilter(...
		@StateFcn,... % State transition function
		@MeasurementNoiseFcn,... % Measurement function
		initialStateGuess,...
		'HasAdditiveMeasurementNoise',false);
	%HasAdditiveProcessNoise
	filter.MeasurementNoise = R;
	filter.ProcessNoise = Q; 
	
% 	while (norm(e,2) > e_tol && k <= k_max)
% 		e(:,:,t,k) = yMeas(:,:,t) - MeasurementFcn(filter.State, arm);
% 		[xCorrected(:,:,t,k), PCorrected(:,:,t,k)] = correct(filter, yMeas(:, :, t), arm);
% 		predict(filter);
% 		k = k + 1;
% %		fa un passo in piu`, da correggere se ne abbiamo voglia => BREAK?
% 	end
% 	
	while k < 2 * k_max
		e(:,:,t,k) = yMeas(:,:,t) - MeasurementFcn(filter.State, arm);
		[xCorrected(:,:,t,k), PCorrected(:,:,t,k)] = correct(filter, yMeas(:, :, t), arm);
		predict(filter);
		if ((norm(e(:,:,t,k),2) < e_tol) || (k >= k_max))
			break
		end
		k = k + 1;
	end

	k_iter(:,t) = k;
	q(:,1,t) = mod(xCorrected(:,:,t,k), 2*pi);
	% e_plot(t,:) = e';
	initialStateGuess = xCorrected(:,:,t,k);
	
end

% 
% for t=1:t_tot
% 	initialStateGuess =Left_Arm.ikcon(rt2tr(quat2rotm(trial.Hand_L.Quat(t,:)),trial.Hand_L.Pos(t,:)'));
% 	e = yMeas(:,:,t) - MeasurementFcn(filter.State, Left_Arm);
% 	e_plot(t,:) = e';
% end
% ERRORE SUL MODULO QUATERNIONI????????

% Error using eig
% Input matrix contains NaN or Inf.
% 
% Error in rotm2quat (line 64)
%     [eigVec,eigVal] = eig(K(:,:,i),'vector');
% 
% Error in fkine_PAD (line 19)
% 	Quat = rotm2quat(Rt)';
% 
% Error in fkine_kalman (line 5)
% [Quat_T12, Tr_T12]				= fkine_PAD(Arm_DH,xk,2);
% 
% Error in MeasurementFcn (line 3)
% yk = fkine_kalman(xk, Arm);


%% KALMAN ORIZZONTALE
% 
% 
% k = 1;									% initialization of filter step-index
% %e = ones(1,size(yMeas, 1), size(yMeas, 3));		% initialization of error
% q = zeros(Left_Arm.n, 1, 1);		% initialization of joint angles
% initialStateGuess = Left_Arm.ikunc(rt2tr(quat2rotm(trial.Hand_L.Quat(1,:)),trial.Hand_L.Pos(1,:)'));
% t_tot = size(yMeas,3);
% xCorrected = zeros(10,1);
% PCorrected = ones(10,10);
% 
% filter = extendedKalmanFilter(...
% 		@StateFcn,... % State transition function
% 		@MeasurementNoiseFcn,... % Measurement function
% 		initialStateGuess,...
% 		'HasAdditiveMeasurementNoise',false);
% 	%HasAdditiveProcessNoise
% 
% 	R = 1;	% Variance of the measurement noise v[k]
% 	Q = 1;	% Variance of the process noise
% 	filter.MeasurementNoise = R;
% 	filter.ProcessNoise = Q; 
% 	
% for k=1:t_tot
% 	e(:,:,k) = yMeas(:,:,k) - MeasurementFcn(filter.State, Left_Arm);% ekf.State is x[k|k-1] at this point
%     [ xCorrected, PCorrected] = correct(filter,yMeas(:,:,k),Left_Arm);
%     % Predict the states at next time step, k+1. This updates the State and
%     % StateCovariance properties of the filter to contain x[k+1|k] and
%     % P[k+1|k]. These will be utilized by the filter at the next time step.
%     predict(filter);
% 	q(:,1,k) = mod(xCorrected,2*pi);
% end
% 	

