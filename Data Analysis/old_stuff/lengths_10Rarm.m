function lengths = lengths_10Rarm(trial)
%lengths_arm Summary of this function goes here
%   Detailed explanation goes here
% example [l_upperarm, l_forearm] =
% lengths_arm( healthy_task(1).subject(1).right_side_trial(1) )

% l_shoulder_l = lsq_order0_norm(trial.Shoulder_L.Pos - trial.Neck.Pos);
% l_shoulder_r = lsq_order0_norm(trial.Shoulder_R.Pos - trial.Neck.Pos);

l_shoulder_l = lsq_order0_norm(trial.Upperarm_L.Pos(:,2) - trial.T8.Pos(:,2));
l_shoulder_r = lsq_order0_norm(trial.Upperarm_R.Pos(:,2) - trial.T8.Pos(:,2));

l_upperarm_l = lsq_order0_norm(trial.Upperarm_L.Pos - trial.Forearm_L.Pos);
l_upperarm_r = lsq_order0_norm(trial.Upperarm_R.Pos - trial.Forearm_R.Pos);

l_forearm_l = lsq_order0_norm(trial.Forearm_L.Pos - trial.Hand_L.Pos);
l_forearm_r = lsq_order0_norm(trial.Forearm_R.Pos - trial.Hand_R.Pos);

h_chest = lsq_order0_norm(trial.T8.Pos - trial.T12.Pos);		% height chest

w_chest_l = sign(trial.Upperarm_L.Pos(1,1) - trial.T8.Pos(1,1)) * lsq_order0_norm(trial.Upperarm_L.Pos(:,1) - trial.T8.Pos(:,1));
w_chest_r = sign(trial.Upperarm_R.Pos(1,1) - trial.T8.Pos(1,1)) * lsq_order0_norm(trial.Upperarm_R.Pos(:,1) - trial.T8.Pos(:,1));


lengths = struct(	'h_chest', h_chest,...
					'w_chest', struct('left', w_chest_l, 'right', w_chest_r),...
					'shoulder_l', struct('left', l_shoulder_l, 'right', l_shoulder_r),...
					'upperarm', struct('left', l_upperarm_l, 'right', l_upperarm_r), ...
					'forearm', struct('left', l_forearm_l, 'right', l_forearm_r)	);

end




