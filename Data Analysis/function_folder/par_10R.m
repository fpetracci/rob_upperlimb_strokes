function par = par_10R(trial)
%par_10R Summary of this function goes here
%   this function calculates all parameters needed to build the
%   Denavit-Hartenberg table of the 10R arm. 
% example: par =
% par_10R( healthy_task(1).subject(1).right_side_trial(1) )

L5_pos = [lsq_order0_norm(trial.L5.Pos(:,1)), lsq_order0_norm(trial.L5.Pos(:,2)), lsq_order0_norm(trial.L5.Pos(:,3))]';

L5_shoulder_l = lsq_order0_norm(trial.Upperarm_L.Pos(:,2:3) - trial.L5.Pos(:,2:3));
L5_shoulder_r = lsq_order0_norm(trial.Upperarm_R.Pos(:,2:3) - trial.L5.Pos(:,2:3));

d_shoulder_l = lsq_order0_norm(trial.Upperarm_L.Pos(:,1) - trial.L5.Pos(:,1));
d_shoulder_r = lsq_order0_norm(trial.Upperarm_R.Pos(:,1) - trial.L5.Pos(:,1));

%intermediate step in order to calculate theta_shoulder
cateto_y_l = lsq_order0_norm(trial.Upperarm_L.Pos(:,2) - trial.L5.Pos(:,2));
cateto_y_r = lsq_order0_norm(trial.Upperarm_R.Pos(:,2) - trial.L5.Pos(:,2));

cateto_z_l = lsq_order0_norm(trial.Upperarm_L.Pos(:,3) - trial.L5.Pos(:,3));
cateto_z_r = lsq_order0_norm(trial.Upperarm_R.Pos(:,3) - trial.L5.Pos(:,3));

theta_shoulder_l = atan2(cateto_y_l, cateto_z_l);
theta_shoulder_r = atan2(cateto_y_r, cateto_z_r);

l_upperarm_l = lsq_order0_norm(trial.Upperarm_L.Pos - trial.Forearm_L.Pos);
l_upperarm_r = lsq_order0_norm(trial.Upperarm_R.Pos - trial.Forearm_R.Pos);

l_forearm_l = lsq_order0_norm(trial.Forearm_L.Pos - trial.Hand_L.Pos);
l_forearm_r = lsq_order0_norm(trial.Forearm_R.Pos - trial.Hand_R.Pos);

l_hand = 0; 	% wrist - hand

% struct definition
par = struct(		'L5_pos', L5_pos,...																% position of vertebrae L5
					'L5_shoulder', struct('left',L5_shoulder_l,'right', L5_shoulder_r),...				% distance norm between L5 and shoulder projected in z-y plane of x_sense frame
					'depth_shoulder', struct('left', d_shoulder_l, 'right', d_shoulder_r),...			% distance norm between L5 and shoulder along x axis of x_sense frame
					'theta_shoulder', struct('left', theta_shoulder_l, 'right', theta_shoulder_r),...	% direction of L5-shoulder vector in z-y plane of x_sense frame
					'upperarm', struct('left', l_upperarm_l, 'right', l_upperarm_r), ...				% distance norm between shoulder and elbow
					'forearm', struct('left', l_forearm_l, 'right', l_forearm_r),...					% distance norm between elbow and wrist
					'hand', l_hand	);																	% distance wrist - hand

end


function sol = lsq_order0_norm(diff)
% This function finds the constant value that minimizes the square error
% of the given vector's norm of each row.
%	
%	

	norm_diff = zeros(size(diff, 1), 1);
	for i = 1:size(diff, 1)
		norm_diff(i) = norm(diff(i,:), 2);
	end

	sol = polyfit(1:size(norm_diff, 1), norm_diff', 0); 

end

