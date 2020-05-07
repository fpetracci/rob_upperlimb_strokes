clear; close; clc;
%left side - PROVA DA PENSARCI A COME AUTOMATIZZARE TUTTO

arm_10R % deve essere una funzione del trial!! DA MODIFICARE

% ikine(PosHand(1)) 
 

%% Loading data
% 
% yk = [	Quat_T12; Tr_T12; ...
% 			Quat_T8; Tr_T8; ...
% 			Quat_Upperarm; Tr_Upperarm; ...
% 			Quat_Forearm; Tr_Forerarm; ...
% 			Quat_Hand; Tr_Hand];

yMeas = [	reshape_data(trial.T12.Quat); reshape_data(trial.T12.Pos);...
			reshape_data(trial.T8.Quat); reshape_data(trial.T8.Pos);...
			reshape_data(trial.Upperarm_L.Quat); reshape_data(trial.Upperarm_L.Pos);...
			reshape_data(trial.Forearm_L.Quat); reshape_data(trial.Forearm_L.Pos);...
			reshape_data(trial.Hand_L.Quat); reshape_data(trial.Hand_L.Pos)];
			
		
%yMeas = yTrue .* (1+sqrt(R)*randn(size(yTrue))); % sqrt(R): Standard deviation of noise

%% KALMAN VERTICALE



% init
t_tot = 1; %size(yMeas,3);					% number of time step in the chosen trial
e_tol = 0.01;							% tolerance to break the filter iteration
k = 1;									% initialization of filter step-index
e_init = ones(size(yMeas, 1), 1);		% initialization of error
q = zeros(Left_Arm.n, 1, t_tot);		% initialization of joint angles
e_plot = zeros(t_tot, size(yMeas, 1));	% init vector with all residual errors at time steps
initialStateGuess = Left_Arm.ikunc(rt2tr(quat2rotm(trial.Hand_L.Quat(1,:)),trial.Hand_L.Pos(1,:)'));

for t = 1:t_tot
	e = e_init;
	% init/reset filter
	xCorrected = zeros(10,1);
	PCorrected = zeros(10,10);

	filter = extendedKalmanFilter(...
		@StateFcn,... % State transition function
		@MeasurementNoiseFcn,... % Measurement function
		initialStateGuess,...
		'HasAdditiveMeasurementNoise',false);
	%HasAdditiveProcessNoise

	R = 1;	% Variance of the measurement noise v[k]
	Q = 1;	% Variance of the process noise
	filter.MeasurementNoise = R;
	filter.ProcessNoise = Q; 
	
	while norm(e,2) > e_tol
		e = yMeas(:,:,t) - MeasurementFcn(filter.State, Left_Arm);
		[xCorrected, PCorrected] = correct(filter, yMeas(:, :, t), Left_Arm);
		predict(filter);
		k = k + 1;
%		fa un passo in piu`, da correggere se ne abbiamo voglia => BREAK?
	end
	q(:,1,t) = xCorrected;
	e_plot(t,:) = e';
	initialStateGuess = xCorrected;
end

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



