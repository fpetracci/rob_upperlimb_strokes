function yk = MeasurementFcn(xk)

% The measurement is the forward kinematics of the angular joint
yk = Fkine(xk);
end