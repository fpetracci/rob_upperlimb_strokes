clear; close; clc;
%left side - PROVA DA PENSARCI A COME AUTOMATIZZARE TUTTO

arm_10R % deve essere una funzione del trial!! DA MODIFICARE

% ikine(PosHand(1)) 
 

%% Loading data
[Quat_Hand,Quat_Elbow] = QuatFixed(trial); % modief

yMeas = [	
% 			reshape_data(trial.T12.Quat); 
%			reshape_data(trial.T12.Pos);...
% 			reshape_data(trial.T8.Quat); 
%			reshape_data(trial.T8.Pos);...
% 			reshape_data(trial.Upperarm_L.Quat); 
%			reshape_data(trial.Upperarm_L.Pos);...
%			reshape_data(Quat_Elbow)];
%			reshape_data(trial.Forearm_L.Pos)];
			reshape_data(Quat_Hand)];
%			reshape_data(trial.Hand_L.Pos)];
			
		
%yMeas = yTrue .* (1+sqrt(R)*randn(size(yTrue))); % sqrt(R): Standard deviation of noise

%% KALMAN VERTICALE



% init
t_tot = size(yMeas,3);					% number of time step in the chosen trial
e_tol = 0.01;							% tolerance to break the filter iteration
k = 1;									% initialization of filter step-index
e_init = ones(size(yMeas, 1), 1);		% initialization of error
q = zeros(Left_Arm.n, 1, t_tot);		% initialization of joint angles
e_plot = zeros(t_tot, size(yMeas, 1));	% init vector with all residual errors at time steps
initialStateGuess = Left_Arm.ikunc(rt2tr(quat2rotm(trial.Hand_L.Quat(1,:)),trial.Hand_L.Pos(1,:)')); %init vector for kalman
c = zeros(1,t_tot);						% init vector to count kalman iterations for each frames
k_iter = 100;							% number of the vertical kalman iteration in the worst case where is not possible to reach the desidered tollerance e_tol

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
	Q = 0.01;	% Variance of the process noise
	filter.MeasurementNoise = R;
	filter.ProcessNoise = Q; 
	k = 0;
	
	while (norm(e,2) > e_tol && k<k_iter)
		e = yMeas(:,:,t) - MeasurementFcn(filter.State, Left_Arm);
		[xCorrected, PCorrected] = correct(filter, yMeas(:, :, t), Left_Arm);
		predict(filter);
		k = k + 1;
%		fa un passo in piu`, da correggere se ne abbiamo voglia => BREAK?
	end
	c(:,t) = k;
	q(:,1,t) = mod(xCorrected,2*pi);
	e_plot(t,:) = e';
	initialStateGuess = xCorrected;
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

