function T = arm_fkine(Arm, q, n)
%arm_fkine computes the forward kinematic of given Arm and angle joints.
% The output is the homogenous matrix T given at the n-th joint.

%%
% n number of joints to calculate the desidered EE rotation matrix and traslation 
% for example: 10 for the hand, 
% 			    7 for the forearm(elbow), 
% 				6 for the upperarm(shoulder)
%				3 for L5
a = Arm.base * Arm.links(1).A(q(1));
b = eye(4);

if n == 0
	T = Arm.base;
	
elseif n == 1
	T = a;
	
elseif n > 1 && n <= length(q)
	for i = 2:n
		b = Arm.links(i).A(q(i));
		a = a*b;
	end
	T = a;
	
elseif n > length(q)
	error('index exceeds number of joint angles')
	
elseif n < 0
	error('index is negative or zero, all joint angles have a positive index')
	
end
									
end

