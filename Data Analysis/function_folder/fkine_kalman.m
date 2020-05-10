function yk = fkine_kalman(xk, Arm_DH)
% TEST

% The measurement is the forward kinematics of the angular joint
[Quat_T12,Tr_T12]				= fkine_PAD(Arm_DH,xk(1),1);
[Quat_T8,Tr_T8]					= fkine_PAD(Arm_DH,xk(1:2),2);
[Quat_Upperarm,Tr_Upperarm]		= fkine_PAD(Arm_DH,xk(1:5),5);
[Quat_Forearm,Tr_Forerarm]		= fkine_PAD(Arm_DH,xk(1:6),6);
[Quat_Hand,Tr_Hand]				= fkine_PAD(Arm_DH,xk(1:10),10);

yk = [	
% 		Quat_T12; 
%		Tr_T12; ...
% 		Quat_T8; 
%		Tr_T8; ...
%		Quat_Upperarm; ...

%		Tr_Upperarm;...
%		Quat_Forearm];
%		Tr_Forerarm];
		Quat_Hand]; 
%		Tr_Hand];
end