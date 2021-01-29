clear 
clc

n_sample = 1e6;
rcondaa = zeros(n_sample,1);
rankaa = zeros(n_sample,1);
phi = 0;
for i = 1:n_sample
	L =  randn(1);
	theta = abs(randn(1));
	phi = phi + 1/180*pi;

% 	E = [			1 - cos(theta)^2*sin(phi)^2 - cos(phi)^2, cos(phi)*sin(phi) - cos(phi)*cos(theta)^2*sin(phi), sin(phi)*sin(theta);...
% 		  cos(phi)*sin(phi) - cos(phi)*cos(theta)^2*sin(phi),           1 - cos(phi)^2*cos(theta)^2 - sin(phi)^2, cos(phi)*sin(theta);...
% 			                  cos(theta)*sin(phi)*sin(theta),                     cos(phi)*cos(theta)*sin(theta),          cos(theta)];
	
	E = [	-(cos(theta)*sin(phi))/L, -(cos(phi)*cos(theta))/L, 0;...
			-cos(phi)/(L*sin(theta)),  sin(phi)/(L*sin(theta)), 0;...
			                       0,                        0, 1];					  
	
	rcondaa(i) = rcond(E);
	rankaa(i) = rank(E);
end

mean(rcondaa)
mean(rankaa)	

%%
length(find(rankaa-3))
length(find(rankaa-2))
length(find(rankaa-1))