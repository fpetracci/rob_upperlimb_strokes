% this script generates signal for the comparison

%% parameters
time	= 1:240;
nsample = length(time);
njoints = 10;

%% gen true angles

q_true = zeros(10,240);
q_noise = q_true;
for i = 1:length(time)
	q_true(:,i) = sin(time(i)/time(end) * 2 * pi) * ones(10,1);
end

%% gen measurements & noise
tmp_meas_vector =  fkine_kalman_marker(zeros(10,1), arm);
nmeas = size(tmp_meas_vector,1);
y_true	= zeros(nmeas, length(time)); %init meas vector
y_noise = y_true;
y_noise2 = y_true;

% 
sigma_meas	= 0.01;	% [m]
sigma_state = 1/180*pi; % [rad]

for i = 1:length(time)
	y_true(:,i)		= fkine_kalman_marker(q_true(:,i), arm);
	y_noise(:,i)	= fkine_kalman_marker(q_true(:,i), arm) ...
						+ sigma_meas * randn(36,1);
	q_noise(:,i)	= q_true(:,i) + sigma_state * randn(10,1);
	y_noise2(:,i)	= fkine_kalman_marker(q_noise(:,i), arm) ...
						+ sigma_meas * randn(36,1);
	
end