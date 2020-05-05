function lengths = lengths_9Rarm(trial)
%lengths_arm Summary of this function goes here
%   Detailed explanation goes here
% example [l_upperarm, l_forearm] =
% lengths_arm( healthy_task(1).subject(1).right_side_trial(1) )

l_shoulder_l = lsq_order0_norm(trial.P_Shoulder_L - trial.P_Neck);
l_shoulder_r = lsq_order0_norm(trial.P_Shoulder_R - trial.P_Neck);

l_upperarm_l = lsq_order0_norm(trial.P_Upperarm_L - trial.P_Forearm_L);
l_upperarm_r = lsq_order0_norm(trial.P_Upperarm_R - trial.P_Forearm_R);

l_forearm_l = lsq_order0_norm(trial.P_Forearm_L - trial.P_Hand_L);
l_forearm_r = lsq_order0_norm(trial.P_Forearm_R - trial.P_Hand_R);

h_torso = lsq_order0_norm(trial.P_Neck(:,3) - trial.P_Pelvis(:,3));
d_neck = lsq_order0_norm(trial.P_Neck(:,1:2) - trial.P_Pelvis(:,1:2));




lengths = struct(	'h_torso', h_torso,...
					'd_neck', d_neck,...
					'shoulder', struct('left', l_shoulder_l, 'right', l_shoulder_r),...
					'upperarm', struct('left', l_upperarm_l, 'right', l_upperarm_r), ...
					'forearm', struct('left', l_forearm_l, 'right', l_forearm_r)	);

end




