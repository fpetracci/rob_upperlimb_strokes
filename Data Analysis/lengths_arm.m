function output = lengths_arm(data)
%lengths_arm Summary of this function goes here
%   Detailed explanation goes here
% example [l_upperarm, l_forearm] =
% lengths_arm( healthy_task(1).subject(1).right_side_trial(1) )


l_upperarm_l = lsq_order0_norm(data.P_Upperarm_L - data.P_Forearm_L);
l_upperarm_r = lsq_order0_norm(data.P_Upperarm_R - data.P_Forearm_R);
l_forearm_l = lsq_order0_norm(data.P_Forearm_L - data.P_Hand_L);
l_forearm_r = lsq_order0_norm(data.P_Forearm_R - data.P_Hand_R);

output = [l_upperarm_l, l_upperarm_r, l_forearm_l, l_forearm_r];

end




