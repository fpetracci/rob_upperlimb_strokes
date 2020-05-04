%Per una più chiara lettura leggere l'esempio, ho copiato ed incollato è
%bene poi parlarne tutti insieme
initialStateGuess = [0 0 0 0 0 0 0 0 0]; %ikine(PosHand(1)) 

ekf = extendedKalmanFilter(...
    @StateFcn,... % State transition function
    @MeasurementNonAdditiveNoise,... % Measurement function
    initialStateGuess,...
    'HasAdditiveMeasurementNoise',false);

R = 0.02; % Variance of the measurement noise v[k]
ekf.MeasurementNoise = R;

%% Loading data with noise addition in multiplicative form
rng(1); % Fix the random number generator for reproducible results
yTrue = %vettore che contiene i nostri dati di posizione ed orientazione
yMeas = yTrue .* (1+sqrt(R)*randn(size(yTrue))); % sqrt(R): Standard deviation of noise

%% Memory allocation
Nsteps = numel(yMeas); % Number of time steps
xCorrectedEKF = zeros(Nsteps,9); % Corrected state estimates
PCorrected = zeros(Nsteps,2,2); % Corrected state estimation error covariances
e = zeros(Nsteps,1); % Residuals (or innovations)

for k=1:Nsteps
  
    e(k) = yMeas(k) - MeasurementFcn(ekf.State); % ekf.State is x[k|k-1] at this point
    [xCorrectedEKF(k,:), PCorrected(k,:,:)] = correct(ekf,yMeas(k));
    % Predict the states at next time step, k+1. This updates the State and
    % StateCovariance properties of the filter to contain x[k+1|k] and
    % P[k+1|k]. These will be utilized by the filter at the next time step.
    predict(ekf);

end