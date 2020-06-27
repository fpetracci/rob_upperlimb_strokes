function [x_new, P_new]= ukf_correct(x_old, P_old, e, S, C)
	%correzione del filtro, secondo Kalman
	
	K = C*(inv(S)); 
    P_delta = - K*S*K';
	
    x_new = x_old + K*e;
    P = P_old + P_delta;    
	
	P_new = (P+P')/2; %si prende la parte simmetrica
end
