  %% Example1: Create and use the filter
  % Generate data: Simulate the van der Pol ODEs for mu = 1 to get the true states
  dt = 0.05; % [s] Filter sample time
  tSpan = 0:dt:5;
  [~,xTrue]=ode45(@vdp1,tSpan,[2;0]);
  % Get measurements: A sensor measures the first state plus noise
  sqrtR = 0.04; % Standard deviation of measurement noise
  yMeas = xTrue(:,1) + sqrtR*randn(numel(tSpan),1);
  %% Construct filter
  initialStateGuess = [2; 0];
  myUKF = unscentedKalmanFilter(@vdpStateFcn,@vdpMeasurementFcn,initialStateGuess);
  myUKF.ProcessNoise = 0.01; % Variance of the process noise
  myUKF.MeasurementNoise = sqrtR^2; % Variance of the measurement noise
  %% Estimate 2 states from noisy measurement of the first state
  xEst = zeros(size(xTrue));
  for k=1:size(xTrue,1)
     % Use measurement y[k] to correct the state estimate for time k
     xEst(k,:) = correct(myUKF,yMeas(k)); 
     % The result is x[k|k]: Estimate of states at time k, utilizing
     % measurements up to time k. This is also stored in the State 
     % property of the filter.
     %
     % Now, predict states at next time step. This updates the State and 
     % StateCovariance properties of the filter. These are utilized in
     % the next correct command
     predict(myUKF); % Filter stores x[k+1|k], P[k+1|k]
  end
  %% Plot results
  plot(xTrue(:,1),xTrue(:,2),'x',xEst(:,1),xEst(:,2),'ro');
  legend('True','Estimated');

  %% Example2: Non-additive measurement noise
  % The relationship between the measurement noise v[k] and y[k] is
  % nonlinear. Specify this when creating the filter. The first two
  % inputs of the measurement function must correspond to x[k] and v[k]
  myUKF = unscentedKalmanFilter(@vdpStateFcn, ...
                   @vdpMeasurementNonAdditiveNoiseFcn, [2;0],...
                   'HasAdditiveMeasurementNoise', false());

  %% Example3: Pass additional inputs to state and measurement functions
  % Assume the state transition model is x[k+1] = sqrt(x[k]) + u[k] + w[k], 
  % and the measurement model is y[k] = x[k] + 2*u[k] + v[k]. Here both
  % the process and measurement noise terms are additive. Add the extra 
  % input u in the state-transition and measurement functions after state x.
  f = @(x,u)(sqrt(x)+u); % Extra input u[k] follows x[k]
  h = @(x,u)(x+2*u);
  myUKF = unscentedKalmanFilter(f,h,0); % 0 is the initial state guess
  %% Provide extra inputs through correct and predict
  % correct the state estimate with measurement y[k]=0.8, input u[k]=0.2
  correct(myUKF,0.8,0.2)
  % predict the states at next time, given u[k]=0.2
  predict(myUKF,0.2)