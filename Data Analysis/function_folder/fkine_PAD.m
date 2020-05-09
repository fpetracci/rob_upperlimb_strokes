function [Quat, Tr] = fkine_PAD(Arm_DH, q, n) 
% n number of joint to calculate the desidered EE rotation matrix and traslation 
% for example: 10 for the hand, 
% 			    7 for the forearm(elbow), 
% 				6 for the upperarm(shoulder)
%				3 for T8
a = Arm_DH.base * Arm_DH.links(1).A(q(1));
b = eye(4);
if n == 1
	[Rt, Tr] = tr2rt(a);
	Quat = rotm2quat(Rt)';
	
elseif n > 1 && n <= length(q)
	for i = 2:n
		b = Arm_DH.links(i).A(q(i));
		a = a*b;
	end
	[Rt, Tr] = tr2rt(a);
	Quat = rotm2quat(Rt)';
	
elseif n > length(q)
	error('index exceeds number of joint angles')
	
elseif n <= 0
	error('index is negative or zero, all joint angles have a positive index')
	
end
										

end

