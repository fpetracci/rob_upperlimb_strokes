function yk = MeasurementFcn(xk, Arm)

yk = fkine_kalman_marker(xk, Arm);
% yk is a vector 35x1

end

