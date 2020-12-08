function [y] = MeasurementNoiseFcn(q,arm)
%MEASUREMENTNOISEFCN Summary of this function goes here
%   Detailed explanation goes here

y = fkine_kalman_marker(q,arm);

end

