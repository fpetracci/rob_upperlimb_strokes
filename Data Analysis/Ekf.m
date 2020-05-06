%Per una più chiara lettura leggere l'esempio, ho copiato ed incollato è
%bene poi parlarne tutti insieme
arm_10R
initialStateGuess = Left_Arm.ikunc (rt2tr(quat2rotm(trial.Hand_L.Quat(1,:)),trial.Hand_L.Pos(1,:)'));; %ikine(PosHand(1)) 

ekf = extendedKalmanFilter(...
    @StateFcn,... % State transition function
    @MeasurementNonAdditiveNoise,... % Measurement function
    initialStateGuess,...
    'HasAdditiveMeasurementNoise',false);

R = 0.02; % Variance of the measurement noise v[k]
ekf.MeasurementNoise = R;

%% Loading data with noise addition in multiplicative form
rng(1); % Fix the random number generator for reproducible results
yMeas = [quat2rotm(trial.Hand_L.Quat)		reshape(trial.Hand_L.Pos',3,1,180) ...
		 quat2rotm(trial.Forearm_L.Quat)	reshape(trial.Forearm_L.Pos',3,1,180)  ...
		 quat2rotm(trial.Upperarm_L.Quat)	reshape(trial.Upperarm_L.Pos',3,1,180) ...
		 quat2rotm(trial.T8.Quat)			reshape(trial.T8.Pos',3,1,180)  ]; %vettore che contiene i nostri dati di posizione ed orientazione
%yMeas = yTrue .* (1+sqrt(R)*randn(size(yTrue))); % sqrt(R): Standard deviation of noise

%% Memory allocation
Nsteps = length(yMeas); % Number of time steps
xCorrectedEKF = zeros(Nsteps,10); % Corrected state estimates
PCorrected = zeros(Nsteps,10,10); % Corrected state estimation error covariances
e = zeros(3,16,Nsteps); % Residuals (or innovations)

for k=1:Nsteps
  
    e(:,:,k) = reshape(yMeas(:,:,k),3,16) - MeasurementFcn(ekf.State,Left_Arm); % ekf.State is x[k|k-1] at this point
    [xCorrectedEKF(k*(1:3),:), PCorrected(k,:,:)] = correct(ekf,yMeas(k));
    % Predict the states at next time step, k+1. This updates the State and
    % StateCovariance properties of the filter to contain x[k+1|k] and
    % P[k+1|k]. These will be utilized by the filter at the next time step.
    predict(ekf);

end