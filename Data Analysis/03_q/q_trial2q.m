function data = q_trial2q(trial)
%q_trial2q given a specific trial, computes and allocates 10R joint
%angles.
%   This function uses an UKF in order to get joint angles' estimate of a
%   10R serial robot representing a human torso-arm. This function relies
%   on functions create_arms() and par_10R().


%% initialization
% to accomodate different subjects and trial executions we have decided to
% reconstruct each time the 10R serial robot using the best fit of arm 
% lengths.
arms = create_arms(trial);
par = par_10R(trial);
%%
% %% Delete first t_init_skip samples
% t_init_skip = 5;
% 
% trial.L5.Pos(1:t_init_skip,:) = [];
% trial.L5.Quat(1:t_init_skip,:) = [];
% 
% trial.Upperarm_L.Pos(1:t_init_skip,:) = [];
% trial.Upperarm_L.Quat(1:t_init_skip,:) = [];
% 
% trial.Forearm_L.Pos(1:t_init_skip,:) = [];
% trial.Forearm_L.Quat(1:t_init_skip,:) = [];
% 
% trial.Hand_L.Pos(1:t_init_skip,:) = [];
% trial.Hand_L.Quat(1:t_init_skip,:) = [];
% 
% trial.Upperarm_R.Pos(1:t_init_skip,:) = [];
% trial.Upperarm_R.Quat(1:t_init_skip,:) = [];
% 
% trial.Forearm_R.Pos(1:t_init_skip,:) = [];
% trial.Forearm_R.Quat(1:t_init_skip,:) = [];
% 
% trial.Hand_R.Pos(1:t_init_skip,:) = [];
% trial.Hand_R.Quat(1:t_init_skip,:) = [];

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
T_L5_z				= zeros(4,4,nsamples);


if trial.task_side == 0 % left side
	
	% quat fix sign ????
	L5_rotm = quat2rotm(trial.L5.Quat);
	L5_quat = rotm2quat(L5_rotm);
	
	%right
	hand_rotm = quat2rotm(trial.Hand_L.Quat);
	hand_quat = rotm2quat(hand_rotm);

	fore_rotm = quat2rotm(trial.Forearm_L.Quat);
	fore_quat = rotm2quat(fore_rotm);

	uppe_rotm = quat2rotm(trial.Upperarm_L.Quat);
	uppe_quat = rotm2quat(uppe_rotm);

	arm = arms.left;
	% rotation matrix 
	for i = 1:nsamples
		rot_wrist_meas(:,:,i)		= quat2rotm(hand_quat(i,:))	* Rs210_l;
		rot_elbow_meas(:,:,i)		= quat2rotm(fore_quat(i,:))	* Rs28_l;
		rot_shoulder_meas(:,:,i)	= quat2rotm(uppe_quat(i,:))	* Rs26_l;
		rot_L5_meas(:,:,i)			= quat2rotm(L5_quat(i,:))	* Rs23_l;
	end
	
	% positions
	pos_shoulder_meas	= reshape_data(trial.Upperarm_L.Pos);
	pos_elbow_meas		= reshape_data(trial.Forearm_L.Pos);
	pos_wrist_meas		= reshape_data(trial.Hand_L.Pos);
	pos_L5_meas			= reshape_data(trial.L5.Pos);
		
	pos_shoulder_meas_fixL5	= pos_shoulder_meas - pos_L5_meas + par.L5_pos; 
	pos_elbow_meas_fixL5	= pos_elbow_meas	- pos_L5_meas + par.L5_pos;
	pos_wrist_meas_fixL5	= pos_wrist_meas	- pos_L5_meas + par.L5_pos;
	pos_L5_meas_fixL5		= pos_L5_meas		- pos_L5_meas + par.L5_pos;
	
	%marker construction
	for i = 1:nsamples
		T_wrist(:,:,i)		= [rot_wrist_meas(:,:,i) pos_wrist_meas_fixL5(:,:,i) ; 0 0 0 1];
		T_wrist_x(:,:,i)	= T_wrist(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_wrist_y(:,:,i)	= T_wrist(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_elbow(:,:,i)		= [rot_elbow_meas(:,:,i) pos_elbow_meas_fixL5(:,:,i) ; 0 0 0 1];
		T_elbow_x(:,:,i)	= T_elbow(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_elbow_y(:,:,i)	= T_elbow(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_shoulder(:,:,i)	= [rot_shoulder_meas(:,:,i) pos_shoulder_meas_fixL5(:,:,i) ; 0 0 0 1];
		T_shoulder_x(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_shoulder_y(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_L5(:,:,i)			= [rot_L5_meas(:,:,i) par.L5_pos ; 0 0 0 1];
		T_L5_x(:,:,i)		= T_L5(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_L5_y(:,:,i)		= T_L5(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		T_L5_z(:,:,i)		= T_L5(:,:,i)  * [eye(3) [0 0 d_trasl]'; 0 0 0 1];
		
	end
	
	% positions of virtual marker
	pos_wrist_meas_x_fixL5		= T_wrist_x(1:3, 4, :);
	pos_wrist_meas_y_fixL5		= T_wrist_y(1:3, 4, :);
	pos_elbow_meas_x_fixL5		= T_elbow_x(1:3, 4, :);
	pos_elbow_meas_y_fixL5		= T_elbow_y(1:3, 4, :);
	pos_shoulder_meas_x_fixL5	= T_shoulder_x(1:3, 4, :);
	pos_shoulder_meas_y_fixL5	= T_shoulder_y(1:3, 4, :);
	pos_L5_meas_x_fixL5			= T_L5_x(1:3, 4, :);
	pos_L5_meas_y_fixL5			= T_L5_y(1:3, 4, :);
	pos_L5_meas_z_fixL5			= T_L5_z(1:3, 4, :);
	
elseif trial.task_side == 1 % right side
	
	% quat fix sign ????
	L5_rotm = quat2rotm(trial.L5.Quat);
	L5_quat = rotm2quat(L5_rotm);
	
	%right
	hand_rotm = quat2rotm(trial.Hand_R.Quat);
	hand_quat = rotm2quat(hand_rotm);

	fore_rotm = quat2rotm(trial.Forearm_R.Quat);
	fore_quat = rotm2quat(fore_rotm);

	uppe_rotm = quat2rotm(trial.Upperarm_R.Quat);
	uppe_quat = rotm2quat(uppe_rotm);
	
	arm = arms.right;
	
	% rotation matrix 
	for i = 1:nsamples
		rot_wrist_meas(:,:,i)		= quat2rotm(hand_quat(i,:))	* Rs210_r;
		rot_elbow_meas(:,:,i)		= quat2rotm(fore_quat(i,:))	* Rs28_r;
		rot_shoulder_meas(:,:,i)	= quat2rotm(uppe_quat(i,:))	* Rs26_r;
		rot_L5_meas(:,:,i)			= quat2rotm(L5_quat(i,:))	* Rs23_r;
	end
	
	% positions
	pos_shoulder_meas	= reshape_data(trial.Upperarm_R.Pos);
	pos_elbow_meas		= reshape_data(trial.Forearm_R.Pos);
	pos_wrist_meas		= reshape_data(trial.Hand_R.Pos);
	pos_L5_meas			= reshape_data(trial.L5.Pos);
		
	pos_shoulder_meas_fixL5	= pos_shoulder_meas - pos_L5_meas + par.L5_pos; 
	pos_elbow_meas_fixL5	= pos_elbow_meas	- pos_L5_meas + par.L5_pos;
	pos_wrist_meas_fixL5	= pos_wrist_meas	- pos_L5_meas + par.L5_pos;
	pos_L5_meas_fixL5		= pos_L5_meas		- pos_L5_meas + par.L5_pos;
	
	%marker construction
	for i = 1:nsamples
		T_wrist(:,:,i)		= [rot_wrist_meas(:,:,i) pos_wrist_meas_fixL5(:,:,i) ; 0 0 0 1];
		T_wrist_x(:,:,i)	= T_wrist(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_wrist_y(:,:,i)	= T_wrist(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_elbow(:,:,i)		= [rot_elbow_meas(:,:,i) pos_elbow_meas_fixL5(:,:,i) ; 0 0 0 1];
		T_elbow_x(:,:,i)	= T_elbow(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_elbow_y(:,:,i)	= T_elbow(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_shoulder(:,:,i)	= [rot_shoulder_meas(:,:,i) pos_shoulder_meas_fixL5(:,:,i) ; 0 0 0 1];
		T_shoulder_x(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_shoulder_y(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_L5(:,:,i)			= [rot_L5_meas(:,:,i) par.L5_pos ; 0 0 0 1];
		T_L5_x(:,:,i)		= T_L5(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_L5_y(:,:,i)		= T_L5(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		T_L5_z(:,:,i)		= T_L5(:,:,i)  * [eye(3) [0 0 d_trasl]'; 0 0 0 1];
		
	end
	
	% positions of virtual marker
	pos_wrist_meas_x_fixL5		= T_wrist_x(1:3, 4, :);
	pos_wrist_meas_y_fixL5		= T_wrist_y(1:3, 4, :);
	pos_elbow_meas_x_fixL5		= T_elbow_x(1:3, 4, :);
	pos_elbow_meas_y_fixL5		= T_elbow_y(1:3, 4, :);
	pos_shoulder_meas_x_fixL5	= T_shoulder_x(1:3, 4, :);
	pos_shoulder_meas_y_fixL5	= T_shoulder_y(1:3, 4, :);
	pos_L5_meas_x_fixL5			= T_L5_x(1:3, 4, :);
	pos_L5_meas_y_fixL5			= T_L5_y(1:3, 4, :);
	pos_L5_meas_z_fixL5			= T_L5_z(1:3, 4, :);

end

% array of measurements including virtual markers
yMeas_fixL5 = [	pos_L5_meas_x_fixL5;		...
				pos_L5_meas_y_fixL5;		...
				pos_L5_meas_z_fixL5;		...
				pos_shoulder_meas_fixL5;	...
				pos_shoulder_meas_x_fixL5;	...
				pos_shoulder_meas_y_fixL5;	...
				pos_elbow_meas_fixL5;		...
				pos_elbow_meas_x_fixL5;		...
				pos_elbow_meas_y_fixL5;		...
				pos_wrist_meas_fixL5;		...
				pos_wrist_meas_x_fixL5;		...
				pos_wrist_meas_y_fixL5];	

%% Kalman Initialization					
t_tot = nsamples - t_skip;		% reduced time steps
q = zeros(arm.n, 1, t_tot);		% initialization of joint angles
only_horiz = 0;					% only_horiz flag used switched off vert iter 

% initialStateGuess computation:
% construction of the homogeneous transform between global frame and EE 
%frame in the first time step TgEE_i
yMeas_EE_rot	= rot_wrist_meas(:,:,1);
yMeas_EE_pos	= pos_wrist_meas_fixL5(:,1,1);
TgEE_i			= rt2tr(yMeas_EE_rot, yMeas_EE_pos);
q0_ikcon		= arm.ikcon(TgEE_i);
initialStateGuess = q0_ikcon';				% init vector for kalman


% general kalman init
k = 1;										% initialization of filter step-index
k_max = 100;								% number of the vertical kalman iteration in the worst case where is not possible to reach the desidered tollerance e_tol
k_iter = zeros(1,t_tot);					% init vector to count kalman iterations for each frames
e = ones(size(yMeas_fixL5,1), 1, t_tot, k_max);	% init of error vector
e_tol = 0.001;								% tolerance to break the filter iteration
tol_nochange = 0.01;						% percent of norm inside of which there is no more relevant corrections
k_nochange = 0;								% init counter no relevant corrections
k_nochange_max = 5;							% stop value for number of irrelevant corrections
tend_vert = 10;								% stop time step to use vertical filter

% vertical filter state and cov init
xCorrected_vert = zeros(arm.n, 1, t_tot, k_max);
PCorrected_vert = zeros(arm.n, arm.n, t_tot, k_max);
xPredicted_vert = zeros(arm.n, 1, t_tot, k_max);
PPredicted_vert = zeros(arm.n, arm.n, t_tot, k_max);

% horizontal filter init
xCorrected_horiz = zeros(arm.n, 1, t_tot);
PCorrected_horiz = zeros(arm.n, arm.n, t_tot);
xPredicted_horiz = zeros(arm.n, 1, t_tot);
PPredicted_horiz = zeros(arm.n, arm.n, t_tot);
e_horiz			 = zeros(size(yMeas_fixL5,1), 1, t_tot);

% R covariance of measurements
sigma_pos		= 0.005/3;		% std deviation of each measured positions [m]
cov_vector_meas = sigma_pos^2 * ones(size(yMeas_fixL5,2), size(yMeas_fixL5,1) );
cov_vector_meas(1,[19:27]) = cov_vector_meas(1,[19:27]);	% elbow measure are more accurate (lower std)
R				= diag(cov_vector_meas);

% P covariance of filter state (joint angles)
sigma_q			= deg2rad(5);		% std deviation of joint angles [rad]
cov_vector_q	= sigma_q^2 * ones(1, arm.n);
weights_covq	= [1 1 1 1 1 1 1 1 1 1]; % weights for different q
cov_vector_q	= cov_vector_q .* weights_covq;
P_init			= diag(cov_vector_q);

sigma_q_nolock		= deg2rad(2); % std deviation of noise on joint angles [rad]
cov_vector_q_nolock	= sigma_q_nolock^2 * ones(1, arm.n);
P_nolock			= diag(cov_vector_q_nolock);

%% Kalman iteration

for t = 1:t_tot
	
	%%horizontal step kalman filter
	% correction horiz
	if t == 1
		
		[y_virt, S_first, C] = ukf_virtmeas(initialStateGuess, P_init, arm);
		S = R + S_first;
		e_horiz(:,:,t) = yMeas_fixL5(:, :, t) - y_virt;
		[xCorrected_horiz(:,:,t), PCorrected_horiz(:,:,t)] = ukf_correct(...
							initialStateGuess, P_init, ...
							e_horiz(:,:,t), S, C);

	else
		if only_horiz == 1
			[y_virt, S_first, C] = ukf_virtmeas(xPredicted_horiz(:,:,t-1), PPredicted_horiz(:,:,t-1), arm);
			S = R + S_first;	% additive noise on measures
			e_horiz(:,:,t) = yMeas_fixL5(:, :, t) - y_virt;
			[xCorrected_horiz(:,:,t), PCorrected_horiz(:,:,t)] = ukf_correct(...
								xPredicted_horiz(:,:,t-1), PPredicted_horiz(:,:,t-1),...
								e_horiz(:,:,t), S, C);
		elseif only_horiz == 0
			[y_virt, S_first, C] = ukf_virtmeas(xCorrected_vert_final, PPredicted_horiz(:,:,t-1), arm);
			S = R + S_first;	% additive noise on measures
			e_horiz(:,:,t) = yMeas_fixL5(:, :, t) - y_virt;
			[xCorrected_horiz(:,:,t), PCorrected_horiz(:,:,t)] = ukf_correct(...
								xCorrected_vert_final, PPredicted_horiz(:,:,t-1),...
								e_horiz(:,:,t), S, C);
		end
	end
	
	% prediction horiz
	[xPredicted_horiz(:,:,t), PPredicted_horiz(:,:,t)] = ukf_predict(...
							xCorrected_horiz(:,:,t), PCorrected_horiz(:,:,t)+P_nolock);
	
	
	if only_horiz == 0					
		%%vertical step kalman filter
		% kalman iterations
		while k <= k_max
				% correction vert
				if k == 1	
					[y_virt, S_first, C] = ukf_virtmeas(xCorrected_horiz(:,:,t), P_init, arm);
					S = R + S_first;	% rumore additivo di misure
					e(:,:,t,k) = yMeas_fixL5(:, :, t) - y_virt;
					[xCorrected_vert(:,:,t,k), PCorrected_vert(:,:,t,k)] = ukf_correct(...
										xCorrected_horiz(:,:,t), P_init, ...
										e(:,:,t,k), S, C);

				else
					[y_virt, S_first, C] = ukf_virtmeas(xPredicted_vert(:,:,t,k-1), PPredicted_vert(:,:,t,k-1), arm);
					S = R + S_first;	% rumore additivo di misure
					e(:,:,t,k) = yMeas_fixL5(:, :, t) - y_virt;
					[xCorrected_vert(:,:,t,k), PCorrected_vert(:,:,t,k)] = ukf_correct(...
										xPredicted_vert(:,:,t,k-1), PPredicted_vert(:,:,t,k-1), ...
										e(:,:,t,k), S, C);
				end
				% prediction vert
				[xPredicted_vert(:,:,t,k), PPredicted_vert(:,:,t,k)] = ukf_predict(...
									xCorrected_vert(:,:,t,k), PCorrected_vert(:,:,t,k));

			% exit conditions
			if k ~= 1
				if norm(xCorrected_vert(:,:,t,k-1) - xCorrected_vert(:,:,t,k),2) < tol_nochange*norm(xCorrected_vert(:,:,t,k),2)
					% there is not enough correction in this k-step
					k_nochange = k_nochange + 1;
				end
			end
			if ((norm(e(:,:,t,k),2) < e_tol) || (k >= k_max) || (k_nochange_max <= k_nochange))
				% three exit conditions on the k-step:
				% 1. norm innovation < tolerated error
				% 2. number of k exceeds the max accepted
				% 3. number of irrelevant corrections exceeds the max accepted
				break
			end

			% increment k iter number
			k = k + 1;
		end

		% save q
		q(:,1,t) = xCorrected_vert(:,:,t,k);

		% save for the next time step iteration
		xCorrected_vert_final = xCorrected_vert(:,:,t,k);

		% k counters
		k_iter(:,t) = k;
		k_nochange = 0;
		k = 1;
	
	elseif only_horiz == 1
		
		% save q
		q(:,1,t) = xCorrected_horiz(:,:,t);
		
	end
	
	% vert iterations are redundant after init phase, horiz filter is
	% enough
	if t == tend_vert
		only_horiz = 1;
	end
	
end

%% end save
q_rad = reshape( q, size(q,1), size(q,3), size(q,2));
q_grad = 180/pi*reshape( q, size(q,1), size(q,3), size(q,2));


y_real = reshape(yMeas_fixL5,size(yMeas_fixL5,1),size(yMeas_fixL5,3),size(yMeas_fixL5,2));

yMeas_virt = zeros(size(yMeas_fixL5,1),t_tot);
for i = 1:t_tot
	yMeas_virt(:,i) = fkine_kalman_marker(q_rad(:,i),arm);
end
error = y_real(:,1:size(yMeas_virt,2)) - yMeas_virt;

% init each error
error_L5		= zeros(1,t_tot);
error_shoulder	= zeros(1,t_tot);
error_elbow		= zeros(1,t_tot);
error_wrist		= zeros(1,t_tot);
for i = 1:t_tot
	error_L5(1,i)		= norm(error([1:9],		i),2)/3;
	error_shoulder(1,i) = norm(error([10:18],	i),2)/3;
	error_elbow(1,i)	= norm(error([19:27],	i),2)/3;
	error_wrist(1,i)	= norm(error([28:36],	i),2)/3;
end

% save into data struct
data.q_grad			= q_grad;

data.err			= struct;
data.err.L5			= error_L5;
data.err.shoulder	= error_shoulder;
data.err.elbow		= error_elbow;
data.err.wrist		= error_wrist;


end

