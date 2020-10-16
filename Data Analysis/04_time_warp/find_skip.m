function [skip_init, skip_end] = find_skip(s)
%% load signal
% 	skip = 15;			% time samples skip to avoid errors at end and start of the trial
% 	s = correct2pi_err(s(:,skip:end-skip));
	s_dot = diff(s')';	% derivative of s (with unit frequency)
	s_dot = [s_dot, s_dot(:,end)]; % added last time sample to have s2_dot same
	% dimensions as s
	l_s = size(s,2);	% number of time sample in the chosen trial
	
	%% parameters to cut signal
	
	n_check		= 70;		% number of time sample in which we check abs(s2_dot) < bound
	flag_init	= 0;		% flag to end the search of initial time sample to cut
	flag_end	= 0;		% flag to end the search of final time sample to cut
	skip_init	= 1;		% store initial time sample from which start timewarping
	skip_end	= l_s;		% store final time sample from which start timewarping
	bound		= 0.7;		% bound of s_dot inside of which we consider the arm is not moving
	
	%% cut indexes
	% from the init find the last input for the significant signal
	for i = 1:n_check
		if   (abs(s_dot(4,i)) < bound && abs(s_dot(7,i)) < bound) && flag_init == 0
			skip_init = i;
		else
			flag_init = 1;
		end
		
		if  ( abs((s_dot(4,end - i)) < bound && abs(s_dot(7,end - i)) < bound) ) && flag_end == 0
			skip_end = l_s - i;
		else
			flag_end = 1;
		end
	end
end