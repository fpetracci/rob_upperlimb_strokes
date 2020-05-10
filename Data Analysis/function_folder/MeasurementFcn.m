function yk = MeasurementFcn(xk, Arm)

yk = fkine_kalman(xk, Arm);
% yk is a vector 35x1

end

