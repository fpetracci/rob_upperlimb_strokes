function armplot(q, arm)
%RESHAPE_ARMPLOT Summary of this function goes here
%   Detailed explanation goes here


qfirst = reshape( q, size(q,1), size(q,3), size(q,2));
q_plot = qfirst';

arm.plot(q_plot,'floorlevel', 0)

end

