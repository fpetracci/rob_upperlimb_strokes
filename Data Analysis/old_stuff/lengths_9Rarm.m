function lengths = lengths_9Rarm(trial)
%lengths_arm Summary of this function goes here
%   Detailed explanation goes here
% example [l_upperarm, l_forearm] =
% lengths_arm( healthy_task(1).subject(1).right_side_trial(1) )

% l_shoulder_l = lsq_order0_norm(trial.Shoulder_L.Pos - trial.Neck.Pos);
% l_shoulder_r = lsq_order0_norm(trial.Shoulder_R.Pos - trial.Neck.Pos);

l_shoulder_l = lsq_order0_norm(trial.Upperarm_L.Pos - trial.Neck.Pos);
l_shoulder_r = lsq_order0_norm(trial.Upperarm_R.Pos - trial.Neck.Pos);


l_upperarm_l = lsq_order0_norm(trial.Upperarm_L.Pos - trial.Forearm_L.Pos);
l_upperarm_r = lsq_order0_norm(trial.Upperarm_R.Pos - trial.Forearm_R.Pos);

l_forearm_l = lsq_order0_norm(trial.Forearm_L.Pos - trial.Hand_L.Pos);
l_forearm_r = lsq_order0_norm(trial.Forearm_R.Pos - trial.Hand_R.Pos);

h_torso = lsq_order0_norm(trial.Neck.Pos(:,3) - trial.Pelvis.Pos(:,3));
d_neck = lsq_order0_norm(trial.Neck.Pos(:,1:2) - trial.Pelvis.Pos(:,1:2)); % Da guardare bene




lengths = struct(	'h_torso', h_torso,...
					'd_neck', d_neck,...
					'shoulder', struct('left', l_shoulder_l, 'right', l_shoulder_r),...
					'upperarm', struct('left', l_upperarm_l, 'right', l_upperarm_r), ...
					'forearm', struct('left', l_forearm_l, 'right', l_forearm_r)	);

end




