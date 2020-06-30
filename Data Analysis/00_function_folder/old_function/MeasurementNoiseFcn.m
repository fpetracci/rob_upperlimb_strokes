function yk = MeasurementNoiseFcn_rel(xk, Arm)
% % multiplicative error
% yk = fkine_kalman(xk, Arm)(1 + vk);

% additive
yk = fkine_kalman_marker(xk, Arm);

end

