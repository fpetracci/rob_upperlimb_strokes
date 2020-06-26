function data = q_trial2q(trial)
%q_trial2q given a specific trial, computes and allocates 10R joint
%angles.
%   This function uses an EKF in order to get joint angles' estimate of a
%   10R serial robot representing a human torso-arm. This function relies
%   on functions create_arms() and par_10R().


%% initialization
% to accomodate different subjects and trial executions we have decided to
% reconstruct each time the 10R serial robot using the best fit of arm 
% lengths.
arms = create_arms(trial);
par = par_10R(trial);

%% load right or left side
% Rotation matrices from sens default frame (see fig 55 in MVN manual) and
% our DH driven frame on the robotic arm. 
% s stands for xsens, number for the n-frame on the robotic arm, 
% l/r left or right. 
% Example: Rs210_l is the rot matrix from hand frame of xsens to 10th frame
% of the left robotic arm described in arm.left

% general time initialization
nsamples = size(trial.Hand_L.Quat,1); % number of time step in the chosen trial
t_skip = 10;	% number of time step we have chosen to skip at the start 
				% and at the end of the trial to avoid measurments errors

% left side
Rs210_l = rotx(-pi/2);
Rs28_l = roty(-pi/2);
Rs26_l = rotx(+pi);
Rs23_l = rotx(pi/2 - par.theta_shoulder.left)*rotz(pi/2);

% right side
Rs210_r = rotx(pi/2);
Rs28_r = roty(pi/2)*rotz(pi);
Rs26_r = eye(3); 
Rs23_r = rotx(pi/2 + par.theta_shoulder.right)*rotz(pi/2); 

% distance between center of frame and virtual marker on x and y axis.
d_trasl = 0.05;

% preallocating for speed efficiency
rot_wrist_meas		= zeros(3,3,nsamples);
rot_elbow_meas		= zeros(3,3,nsamples);
rot_shoulder_meas	= zeros(3,3,nsamples);
rot_L5_meas			= zeros(3,3,nsamples);
T_wrist				= zeros(4,4,nsamples);
T_wrist_x			= zeros(4,4,nsamples);
T_wrist_y			= zeros(4,4,nsamples);
T_elbow				= zeros(4,4,nsamples);
T_elbow_x			= zeros(4,4,nsamples);
T_elbow_y			= zeros(4,4,nsamples);
T_shoulder			= zeros(4,4,nsamples);
T_shoulder_x		= zeros(4,4,nsamples);
T_shoulder_y		= zeros(4,4,nsamples);
T_L5				= zeros(4,4,nsamples);
T_L5_x				= zeros(4,4,nsamples);
T_L5_y				= zeros(4,4,nsamples);

if trial.task_side == 0 % left side
	arm = arms.left;
	% rotation matrix 
	for i = 1:nsamples
		rot_wrist_meas(:,:,i)		= quat2rotm(trial.Hand_L.Quat(i,:))		* Rs210_l;
		rot_elbow_meas(:,:,i)		= quat2rotm(trial.Forearm_L.Quat(i,:))	* Rs28_l;
		rot_shoulder_meas(:,:,i)	= quat2rotm(trial.Upperarm_L.Quat(i,:))	* Rs26_l;
		rot_L5_meas(:,:,i)			= quat2rotm(trial.L5.Quat(i,:))			* Rs23_l;
	end
	
	% positions
	pos_shoulder_meas	= reshape_data(trial.Upperarm_L.Pos);
	pos_elbow_meas		= reshape_data(trial.Forearm_L.Pos);
	pos_wrist_meas		= reshape_data(trial.Hand_L.Pos);
	pos_L5_meas			= reshape_data(trial.L5.Pos);
		
	for i = 1:nsamples
		T_wrist(:,:,i)		= [rot_wrist_meas(:,:,i) pos_wrist_meas(:,:,i) ; 0 0 0 1];
		T_wrist_x(:,:,i)	= T_wrist(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_wrist_y(:,:,i)	= T_wrist(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_elbow(:,:,i)		= [rot_elbow_meas(:,:,i) pos_elbow_meas(:,:,i) ; 0 0 0 1];
		T_elbow_x(:,:,i)	= T_elbow(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_elbow_y(:,:,i)	= T_elbow(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_shoulder(:,:,i)	= [rot_shoulder_meas(:,:,i) pos_shoulder_meas(:,:,i) ; 0 0 0 1];
		T_shoulder_x(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_shoulder_y(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_L5(:,:,i)			= [rot_L5_meas(:,:,i) pos_L5_meas(:,:,i) ; 0 0 0 1];
		T_L5_x(:,:,i)		= T_L5(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_L5_y(:,:,i)		= T_L5(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
	end
	
	% positions of virtual marker
	pos_wrist_meas_x	= T_wrist_x(1:3, 4, :);
	pos_wrist_meas_y	= T_wrist_y(1:3, 4, :);
	pos_elbow_meas_x	= T_elbow_x(1:3, 4, :);
	pos_elbow_meas_y	= T_elbow_y(1:3, 4, :);
	pos_shoulder_meas_x = T_shoulder_x(1:3, 4, :);
	pos_shoulder_meas_y = T_shoulder_y(1:3, 4, :);
	pos_L5_meas_x		= T_L5_x(1:3, 4, :);
	pos_L5_meas_y		= T_L5_y(1:3, 4, :);
	
elseif trial.task_side == 1 % right side
	
	arm = arms.right;
	
	% rotation matrix 
	for i = 1:nsamples
		rot_wrist_meas(:,:,i)		= quat2rotm(trial.Hand_R.Quat(i,:))		* Rs210_r;
		rot_elbow_meas(:,:,i)		= quat2rotm(trial.Forearm_R.Quat(i,:))	* Rs28_r;
		rot_shoulder_meas(:,:,i)	= quat2rotm(trial.Upperarm_R.Quat(i,:))	* Rs26_r;
		rot_L5_meas(:,:,i)			= quat2rotm(trial.L5.Quat(i,:))			* Rs23_r;
	end
	
	% positions
	pos_shoulder_meas	= reshape_data(trial.Upperarm_R.Pos);
	pos_elbow_meas		= reshape_data(trial.Forearm_R.Pos);
	pos_wrist_meas		= reshape_data(trial.Hand_R.Pos);
	pos_L5_meas			= reshape_data(trial.L5.Pos);
		
	for i = 1:nsamples
		T_wrist(:,:,i)		= [rot_wrist_meas(:,:,i) pos_wrist_meas(:,:,i) ; 0 0 0 1];
		T_wrist_x(:,:,i)	= T_wrist(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_wrist_y(:,:,i)	= T_wrist(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_elbow(:,:,i)		= [rot_elbow_meas(:,:,i) pos_elbow_meas(:,:,i) ; 0 0 0 1];
		T_elbow_x(:,:,i)	= T_elbow(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_elbow_y(:,:,i)	= T_elbow(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_shoulder(:,:,i)	= [rot_shoulder_meas(:,:,i) pos_shoulder_meas(:,:,i) ; 0 0 0 1];
		T_shoulder_x(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_shoulder_y(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_L5(:,:,i)			= [rot_L5_meas(:,:,i) pos_L5_meas(:,:,i) ; 0 0 0 1];
		T_L5_x(:,:,i)		= T_L5(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_L5_y(:,:,i)		= T_L5(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
	end
	
	% positions of virtual marker
	pos_wrist_meas_x	= T_wrist_x(1:3, 4, :);
	pos_wrist_meas_y	= T_wrist_y(1:3, 4, :);
	pos_elbow_meas_x	= T_elbow_x(1:3, 4, :);
	pos_elbow_meas_y	= T_elbow_y(1:3, 4, :);
	pos_shoulder_meas_x = T_shoulder_x(1:3, 4, :);
	pos_shoulder_meas_y = T_shoulder_y(1:3, 4, :);
	pos_L5_meas_x		= T_L5_x(1:3, 4, :);
	pos_L5_meas_y		= T_L5_y(1:3, 4, :);

end

% array of measurements including virtual markers
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

%% Kalman Initialization					
t_tot = nsamples - t_skip;		% reduced time steps
q = zeros(arm.n, 1, t_tot);		% initialization of joint angles

% initialStateGuess computation:
% construction of the homogeneous transform between global frame and EE 
%frame in the first time step TgEE_i
yMeas_EE_rot	= rot_wrist_meas(:,:,1);
yMeas_EE_pos	= pos_wrist_meas(:,1,1);
TgEE_i			= rt2tr(yMeas_EE_rot, yMeas_EE_pos);
q0_ikunc		= arm.ikunc(TgEE_i);
%q0_ikcon		= arm.ikcon(TgEE_i);

initialStateGuess = q0_ikunc;				% init vector for kalman

% general kalman init
k = 1;										% initialization of filter step-index
k_max = 100;								% number of the vertical kalman iteration in the worst case where is not possible to reach the desidered tollerance e_tol
e = ones(size(yMeas,1), 1, t_tot, k_max);	% init of error vector
e_tol = 0.005;								% tolerance to break the filter iteration
tol_nochange = 0.05;						% percent of norm inside of which there is no more relevant corrections
k_nochange = 0;								% init counter no relevant corrections
k_nochange_max = 10;						% stop value for number of irrelevant corrections

% vertical filter state and cov init
xCorrected_vert = zeros(arm.n, 1, t_tot, k_max);
PCorrected_vert = zeros(arm.n, arm.n, t_tot, k_max);

% horizontal filter state and cov init
xCorrected_horiz = zeros(arm.n, 1, t_tot);
PCorrected_horiz = zeros(arm.n, arm.n, t_tot);

% R covariance of measurements
sigma_pos		= 0.01;			% std deviation of each measured positions [m]
cov_vector_meas = sigma_pos^2 * ones(size(yMeas,2), size(yMeas,1) );
R				= diag(cov_vector_meas);

% Q covariance of filter state (joint angles)
sigma_q			= deg2rad(2);		% std deviation of joint angles [rad]
cov_vector_q	= sigma_q^2 * ones(1, arm.n);
weights_covq	= [1/2 1/2 1/2 1 1 1 1 1 1 1]; % weights for different q
cov_vector_q	= cov_vector_q .* weights_covq;
Q				= diag(cov_vector_q);

%% Kalman iteration

filter_horiz  = extendedKalmanFilter(...
		@StateFcn,...				% State transition function
		@MeasurementNoiseFcn,...	% Measurement function
		initialStateGuess);			% initial state guess

filter_horiz.MeasurementNoise = R;	% Variance of the measurement noise
filter_horiz.ProcessNoise = Q;		% Variance of the process noise

for t = 1:t_tot
	%horizontal step kalman filter
	[xCorrected_horiz(:,:,t), PCorrected_horiz(:,:,t)] = correct(filter_horiz, yMeas(:, :, t), arm);
	predict(filter_horiz);
	
	% vertical filter definition
	filter_vert = extendedKalmanFilter(...
		@StateFcn,...					% State transition function
		@MeasurementNoiseFcn,...		% Measurement function
		xCorrected_horiz(:,:,t));		% initial state = last corrected state of horiz filter

	filter_vert.MeasurementNoise = R;	% Variance of the measurement noise
	filter_vert.ProcessNoise = Q;		% Variance of the process noise 
	
	% kalman iterations
	while k <= k_max
		
		[xCorrected_vert(:,:,t,k), PCorrected_vert(:,:,t,k)] = correct(filter_vert, yMeas(:, :, t), arm);
		predict(filter_vert);
		
		e(:,:,t,k) = yMeas(:,:,t) - MeasurementFcn(filter_vert.State, arm);
		
		% exit conditions
		if k ~= 1
			if norm(e(:,:,t,k-1)- e(:,:,t,k),2) < tol_nochange*norm(e(:,:,1,k),2)
				% there is not enough correction in this k-step
				k_nochange = k_nochange + 1;
			end
		end
		if ((norm(e(:,:,t,k),2) < e_tol) || (k >= k_max) || (k_nochange_max >= k_nochange))
			% three exit conditions on the k-step:
			% 1. norm innovation < tolerated error
			% 2. number of k exceeds the max accepted
			% 3. number of irrelevant corrections exceeds the max accepted
			break
		end
		
		% increment k iter number
		k = k + 1;
	end
	
	% save q at the end of vertical iterations
	q(:,1,t) = xCorrected_vert(:,:,t,k);
	
	% save for the next time step iteration
	filter_horiz.State = xCorrected_vert(:,:,t,k);
	
	% reset k counters
	k_nochange = 0;
	k = 1;
	
end

%% end save
q_rad = reshape( q, size(q,1), size(q,3), size(q,2));
q_grad = 180/pi*reshape( q, size(q,1), size(q,3), size(q,2));

yMeas_virt = zeros(size(yMeas,1),t_tot);
for i = 1:t_tot
	yMeas_virt(:,i) = fkine_kalman_marker(q_rad(:,i),arm);
end
y_real = reshape(yMeas,size(yMeas,1),size(yMeas,3),size(yMeas,2));
error = y_real(:,1:size(yMeas_virt,2)) - yMeas_virt;

% save into data
data.q_grad = q_grad;
data.err = error;

end

