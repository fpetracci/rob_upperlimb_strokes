function [Rt,Tr] = fkine_PAD(Arm_DH,State,n) 
% n number of joint to calculate the desidered EE rotation matrix and traslation 
% for example: 10 for the hand, 
% 			    7 for the forearm(elbow), 
% 				6 for the upperarm(shoulder)
%				3 for T8

a = Arm_DH.links(1).A(State(1)');
b = 1;
for i = 2:n
	a = a*b;
	b = Arm_DH.links(i).A(State(i)');
end
a = a*b;										
[Rt,Tr] = tr2rt(a)
end

