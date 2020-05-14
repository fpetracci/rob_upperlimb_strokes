%% init
clear; clc;

trial = struct_dataload('H01_T07_L1'); % barbatrucco finché non abbiamo la struttura per bene... PEPOO LAVORA

arms = create_arms(trial);
par = par_10R(trial);
%% load
% Measurement vector, copied here for reference
% yk = [	eul_L5; ...
% 		tr_shoulder; ...
% 		eul_shoulder; ...
% 		tr_elbow; ...
% 		eul_elbow; ...
% 		tr_wrist; ...
% 		eul_wrist];

% rotation matrix xsens -> dh frames
%nome non ci piace ma e` la rotazione che 
% porta xs in sistema di riferimento su wrist "nostro" dovuto a dh
Rs210_l = rotx(-pi/2);
Rs28_l = rotz(pi)*rotx(pi);
Rs23_l = roty(pi/2)*rotx(pi-par.theta_shoulder.left);


if 1 == 1 %trial.task_side == left
	
	arm = arms.left;
	
	% construction of measurement vector 
	eul_L5_meas = reshape_data(tr2eul(quat2rotm(trial.L5.Quat) ));
	eul_shoulder_meas = reshape_data(tr2eul(quat2rotm(trial.Upperarm_L.Quat) ));
	
	
	for i=1:size(trial.Hand_L.Quat,1)
		eul_wrist_meas(:,i) = tr2eul(quat2rotm(trial.Hand_L.Quat(i,:)) * Rs210_l);
		eul_elbow_meas(:,i) = tr2eul( quat2rotm(trial.Forearm_L.Quat(i,:)) * Rs28_l);
	end
 	eul_wrist_meas = reshape_data(eul_wrist_meas');
	eul_elbow_meas = reshape_data(eul_elbow_meas');
	
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

%% yMeas Generation
% general variables outside chosing left or right
% yMeas = [	eul_L5_meas;		...
% 			pos_shoulder_meas;	...
% 			eul_shoulder_meas;	...
% 			pos_elbow_meas;		...
% 			eul_elbow_meas;		...
% 			pos_wrist_meas;		...
% 			eul_wrist_meas];
		
yMeas = [	eul_L5_meas; ...
			pos_shoulder_meas;	...
			%eul_elbow_meas;		...
			pos_wrist_meas;		...
			eul_wrist_meas];


yMeas_EE_rot = eul2r(eul_wrist_meas(:,1,1)'); % peter corke function
%yMeas_EE_rot = eul2rotm(eul_wrist_meas(:,1,1)',  'ZYZ');
yMeas_EE_pos = pos_wrist_meas(:,1,1);

% homogeneous transform between global frame and EE frame in the first time
% step
TgEE_i = rt2tr(yMeas_EE_rot, yMeas_EE_pos);

%% Kalman Init
t_tot = size(yMeas,3);						% number of time step in the chosen trial
q = zeros(arm.n, 1, t_tot);					% initialization of joint angles
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

%% PROVE PAR
e_tol = 0.01;	
R = 1;	% Variance of the measurement noise v[k]
Q = 1;	% Variance of the process noise


%% Kalman iteration
for t = 1:t_tot
	% e(:,:,t,1) = e_init;

	
	%filter definition
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
	while k < (2 * k_max)
		e(:,:,t,k) = yMeas(:,:,t) - MeasurementFcn(filter.State, arm);
		[xCorrected(:,:,t,k), PCorrected(:,:,t,k)] = correct(filter, yMeas(:, :, t), arm);
		predict(filter);
		if ((norm(e(:,:,t,k),2) < e_tol) || (k >= k_max))
			break
		end
		k = k + 1;
	end

	k_iter(:,t) = k;
	%q(:,1,t) = mod(xCorrected(:,:,t,k), 2*pi);
	q(:,1,t) = xCorrected(:,:,t,k);

	% e_plot(t,:) = e';
	initialStateGuess = xCorrected(:,:,t,k);
	k = 1;
	
end

%%
figure(1)
armplot(q,arm);

figure(2)
plot(k_iter, '*')

figure(3)
qfirst = reshape( q, size(q,1), size(q,3), size(q,2));
plot(qfirst')

%% q in t fisso
figure(1)
t_fisso = 1;
q_tfisso = zeros(arm.n, k_iter(t_fisso));
for k_plot = 1:k_iter(t_fisso)
	q_tfisso(:,k_plot) = xCorrected(:,1,t_fisso,k_plot);
end
arm.plot(q_tfisso');

%% e in t fisso
figure(5)
t_fisso = 1;
e_tfisso = zeros(size(yMeas,1), k_iter(t_fisso));
for k_plot = 1:k_iter(t_fisso)
	e_tfisso(:,k_plot) = e(:,1,t_fisso,k_plot);
end

grid on
plot(e_tfisso')
legend('x elbow','y elbow','z elbow',...
		'x wrist','y wrist', 'z wrist',...
		'phi','theta','psi')

%% prove
arm.plot(q0_ikunc)

arm.plot(q_tfisso(:,k_iter(t_fisso))' )

arm.plot(zeros(1,arm.n))



%%
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

