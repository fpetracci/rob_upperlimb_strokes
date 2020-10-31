function J = J_ergo(q_trial, W, ts)
%J_ERGO computes the ergonomic functional.
% Based on the kinematic definition of ergonomy (minimum velocities at 
% joints level) and given a weighting matrix W, it is defined as the
% quadratic form for each frame t:
%		J(t) = q_dot(t)' W q_dot(t)
% INPUT:
%  q_trial		angular joint values of the chosen trial
%  W			weighting matrix inside functional J (optional)
%  ts			sampling time [s] (optional)

% OUTPUT:
%  J			column vector containing functional values for each time frame

%% input checks

% nargin
if nargin == 3
	% do nothing
elseif nargin == 2
	ts = 1/60; % default sampling time [s]
elseif nargin == 1
	W = [20, 20, 20, 1, 1, 1, 1, 1.5, 2, 3];
	ts = 1/60; % default sampling time
else
	error('Check inputs!')
end

% dimensions
n_joints	= min(size(q_trial)); % I suppose at least n_timesteps > n_joints
n_timesteps = max(size(q_trial));

% W
if (size(W,1) == 1 && size(W,2) == n_joints) || (size(W,2) == 1 && size(W,1) == n_joints)
	W = diag(W);
elseif (size(W,1) == n_joints && size(W,2) == n_joints)
	% W already in the correct form
	% do nothing
else
	error('n_joints does not match weights'' matrix size!')
end

% q_trial
if size(q_trial, 1) == n_joints
	% each time step is a vector column with joints' angles
	% do nothing
elseif size(q_trial, 2) == n_joints
	% each time step is a vector row with joints' angles
	q_trial = q_trial';	
end
q_trial = deg2rad(q_trial);

%% ergonomyfunctional definition

q_dot = diff(q_trial')' /ts;
q_dot = [q_dot, q_dot(:,end)]; % added last time sample to have q_dot same
% dimensions as q_trial

% preallocating J
J = zeros(n_timesteps,1);

for i = 1:n_timesteps
	q_dot_now = q_dot(:,i);
	J(i) = q_dot_now' * W * q_dot_now;
end

end

