function [x_new, P_new]= ukf_correct(x_old, P_old, e, S, C)
%ukf_correct computes Unscented Kalman filter correction step, using
%classic Kalman theory.
	
	K = C*(inv(S)); 
    P_delta = - K*S*K';
	
    x_new = x_old + K*e;
    P = P_old + P_delta;    
	
	P_new = (P+P')/2; % forced simmetry
end
