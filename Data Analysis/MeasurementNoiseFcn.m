function yk = MeasurementNoiseFcn(xk, vk, Arm)
% multiplicative error
yk = fkine_kalman(xk, Arm)*(1+vk);
% yk is a vector 35x1

end
