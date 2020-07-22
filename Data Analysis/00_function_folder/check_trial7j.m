function flag = check_trial7j(q_trial)
%CHECK_TRIAL checks if there are angles in the trial that are out of bounds
	% and returns:
	% . 0 for a trial that can't be used
	% . 1 for a trial that can be used

%% TEMPORARY ONLY CHECK ON JOINT ANGLE 7
	
% joint 7, bound [-0.17, 2.53]
% n_neg7: how many time samples have an out of bound angle
n_neg7 = length( find(q_trial(7,:) <= rad2deg(-0.17)) );

if n_neg7 >= 10
	flag = 0; % trial can't be used
else
	flag = 1;
end

end

