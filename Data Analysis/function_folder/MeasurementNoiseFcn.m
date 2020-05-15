function yk = MeasurementNoiseFcn(xk, Arm)
% % multiplicative error
% yk = fkine_kalman(xk, Arm)(1 + vk);

% additive
yk = fkine_kalman(xk, Arm);

end

