function flag = check_trial(q_trial)
	flag = check_trial7j(q_trial);
end

%%
function flag = check_trial_complete(q_trial)
%CHECK_TRIAL checks if there are angles in the trial that are out of bounds
	% and returns:
	% . 0 for a trial that can't be used
	% . 1 for a trial that can be used

[njoints, ~]	= size(q_trial);

% Physiological bounds on joint angle:
% 1		[-pi/4, +pi/2]
% 2		[-pi/4, +pi/4]
% 3		[-0.26, +0.26]
% 4		[-2.96, +pi/2]
% 5		[-pi, +0.87]
% 6		[-pi/2, +pi]
% 7		[-0.17, 2.53]
% 8		[-pi/2, pi]
% 9		[-pi/2, 1.22]
% 10	[-0.26, 0.26]
bounds = [	[-pi/4, +pi/2]; [-pi/4, +pi/4]; [-0.26, +0.26]; ...
			[-2.96, +pi/2];	[-pi, +0.87]; [-pi/2, +pi]; ...
			[-0.17, 2.53]; [-pi/2, pi]; [-pi/2, 1.22]; ...
			[-0.26, 0.26] ];

bounds(4,:) = deg2rad([-230, 40]);
scale_factor = 1.5;


bounds = scale_factor * rad2deg(bounds);


% number of outofbound for each joint
n_outofbound = zeros(njoints,1);

for j = 1:njoints
	tmp_under	= length( find(q_trial(j,:) <= bounds(j,1)) );
	tmp_over	= length( find(q_trial(j,:) >= bounds(j,2)) );
	n_outofbound(j) = tmp_under + tmp_over;
end

% no check for first 3 joints
n_outofbound(1:3) = 0;


if max(n_outofbound) >= 20
	flag = 0; 	% trial can't be used
else
	flag = 1;	% trial can be used
end

end

%%
function flag = check_trial7j(q_trial)
%CHECK_TRIAL checks if there are angles in the trial that are out of bounds
	% and returns:
	% . 0 for a trial that can't be used
	% . 1 for a trial that can be used

%% TEMPORARY ONLY CHECK ON JOINT ANGLE 7
	
% joint 7, bound [-0.17, 2.53]
% n_neg7: how many time samples have an out of bound angle
n_neg7 = length( find(q_trial(7,:) <= rad2deg(-0.17*1.15)) );

if n_neg7 >= 10
	flag = 0; % trial can't be used
else
	flag = 1;
end

end



