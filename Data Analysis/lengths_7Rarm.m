function output = lengths_arm(data)
%lengths_arm Summary of this function goes here
%   Detailed explanation goes here
% example [l_upperarm, l_forearm] =
% lengths_arm( healthy_task(1).subject(1).right_side_trial(1) )


l_upperarm_l = lsq_order0_norm(data.Upperarm_L.Pos - data.Forearm_L.Pos);
l_upperarm_r = lsq_order0_norm(data.Upperarm_R.Pos - data.Forearm_R.Pos);
l_forearm_l = lsq_order0_norm(data.Forearm_L.Pos - data.P_Hand_L.Pos);
l_forearm_r = lsq_order0_norm(data.Forearm_R.Pos - data.Hand_R.Pos);

output = [l_upperarm_l, l_upperarm_r, l_forearm_l, l_forearm_r];

end




