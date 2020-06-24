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
e_tol = 0.005;	
R = 0.00001;	% Variance of the measurement noise v[k]
Q = 0.01;	% Variance of the process noise
			
tol_nochange = 0.05;		% percent of norm
k_nochange = 0;
k_nochange_max = 10;
%% Kalman iteration
tic
q = q0_ikunc;
%Hn = zeros(size(yMeas,1), size(yMeas,2));
hn = fkine_kalman(q0_ikunc, arm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize the innovation vector
innovation = zeros(size(yMeas,1),1);

% initialize the innovation variance vector (96x96)
varInnov = zeros(size(yMeas,1),size(yMeas,1));

% Define the measurement covariance
R_OBS = 0.01*eye(size(yMeas,1)); 

%Define P and Q
P = 0.01*eye(arm.n); %incertezza c.i.  ok 0.001
processNoise = 0.001*eye(arm.n); %Q %incertezza modello

%initialize a matrix that will contains all estimed angles
EstimatedQ = [];

hnvalues = [];



for i = 1:t_tot

	qold = q; %Project the state ahead 
	hnold = hn;

	% Add the process noise  (Pk = I*Pk-1*I + Q)
	for j = 1:arm.n
		P(j,j) = P(j,j) + processNoise(j,j); %Project the error covariance ahead
	end

	% Define the observation vector (96x1)
	observation = yMeas(:,1,i);

	hn = fkine_kalman(qold, arm);
	Hn = (hn-hnold)*60;
	%Hn = jacobianfun(NumericParameters, qold');

	hnvalues = [hnvalues hn]; 

	innovation = observation - hn;

	%innovation = observation - hn; % 
	varInnov = Hn*P*Hn' + R_OBS; %

	% Kalman Gain P 
	K = P*Hn'*varInnov^-1;   

	% Calculate state corrections
	q = qold + K * innovation;

	% Update the covariance 
	P = P - K*Hn*P;

	%save estimated angles (in columns) 
	EstimatedQ = [EstimatedQ qold];
	%EstimatedQ = [EstimatedQ sinqold']; 
	q(:,1,i) = qold;
end

toc
%% init plots
q_rad = reshape( q, size(q,1), size(q,3), size(q,2));
q_grad = 180/pi*reshape( q, size(q,1), size(q,3), size(q,2)); %from rad to deg, reshape for having q in the right way
%% Synchronized plot arm with 

figure(1)
	subplot(1,2,1)
	title('q results animation')
	subplot(1,2,2)
	title('q results grad')
	
	
for i=1:floor(t_tot/3)
	% plot of robotic arm with PC.plot
	subplot(1,2,1)
	arm.plot(q(:,1,i*3)','floorlevel', 0)%mmmmmm?????
	% plot of joint angle
	subplot(1,2,2)
	plot_angle(q_grad,i*3)% if u want rad instead of grad use q_rad
	xlim([0 size(q_grad,2)])
	hold on

end
%% simple plots
figure(2)
plot(k_iter, '*')
title('k iterations')

figure(1)
armplot(q,arm)

figure(3)
title('q results rad')
qfirst = reshape( q, size(q,1), size(q,3), size(q,2));
plot(qfirst')

figure(3)
title('q results grad')
qsecond = 180/pi*reshape( q, size(q,1), size(q,3), size(q,2));
plot(qsecond')
%% q in t fisso
figure(1)

t_fisso = 175;
q_tfisso = zeros(arm.n, k_iter(t_fisso));
for k_plot = 1:k_iter(t_fisso)
	q_tfisso(:,k_plot) = xCorrected(:,1,t_fisso,k_plot);
end
arm.plot(q_tfisso');
title('q iterations given t - animation')
%% e in t fisso
figure(5)

t_fisso = 1;
e_tfisso = zeros(size(yMeas,1), k_iter(t_fisso));
for k_plot = 1:k_iter(t_fisso)
	e_tfisso(:,k_plot) = e(:,1,t_fisso,k_plot);
end

grid on
plot(e_tfisso')
title('e iterations given t')
% yMeas = [	eul_L5_meas;		...
% 			pos_shoulder_meas;	...
% 			eul_shoulder_meas;	...
% 			pos_elbow_meas;		...
% 			eul_elbow_meas;		...
% 			pos_wrist_meas;		...
% 			eul_wrist_meas];
%legend('x elbow','y elbow','z elbow',...
%		'x wrist','y wrist', 'z wrist',...
%		'phi','theta','psi')
%%  plot residual at final step iteration
clear i e_f
for i = 1:t_tot
 e_f(:,i) = e(:,:,i,k_iter(i));
end
figure(6)
plot(e_f')
title('errot at the final k iteration')
%% prove
figure(1)
title('inverse kinematic position at t = 1')
arm.plot(q0_ikunc)
% 
% arm.plot(q_tfisso(:,k_iter(t_fisso))' )
% 
% arm.plot(zeros(1,arm.n))
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
%% q animation for each time step and each k iter

figure(1)
for tt = 165:1:t_tot
	
	t_fisso = tt;
	fprintf('time step is %3.0f \n', tt);
	
	q_tfisso = zeros(arm.n, k_iter(t_fisso));
	for k_plot = 1:k_iter(t_fisso)
		q_tfisso(:,k_plot) = xCorrected(:,1,t_fisso,k_plot);
	end
	arm.plot(q_tfisso');
	title('q iterations given t - animation')

end
%% check range eul angles
figure(6)
%eul_prova = eul_L5_meas;
%eul_prova = eul_shoulder_meas;
%eul_prova = eul_elbow_meas;
eul_prova = eul_wrist_meas;

prova = reshape(eul_prova, size(eul_prova,1), size(eul_prova,3) );
plot(prova')
title( 'check angles')
%% errors!

for i = 1:t_tot
	yMeas_virt(:,i) = fkine_kalman(q_rad(:,i),arm);
end

%posizione polso misurata
pos_wrist_test = reshape(pos_wrist_meas, size(pos_wrist_meas,1), size(pos_wrist_meas,3), size(pos_wrist_meas,2));
%posizione polso ricostruita
pos_wrist_reconst = yMeas_virt(16:18,:);

%errore posizione polso
err_polso = pos_wrist_reconst - pos_wrist_test(:,1:t_tot);

%
figure(9)
plot(err_polso');

figure(10)
plot(pos_wrist_test'); hold on
plot(pos_wrist_reconst')
hold off

%plot(euler(:,:)')
%title('stimation angle and position')
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

