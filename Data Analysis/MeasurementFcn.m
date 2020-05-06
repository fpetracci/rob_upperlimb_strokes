function yk = MeasurementFcn(xk,Arm_DH)

% The measurement is the forward kinematics of the angular joint
[Rt_T8,Tr_T8] =				fkine_PAD(Arm_DH,xk,3);
[Rt_Upperarm,Tr_Upperarm] = fkine_PAD(Arm_DH,xk,6);
[Rt_Forearm,Tr_Forerarm] =	fkine_PAD(Arm_DH,xk,7);
[Rt_Hand,Tr_Hand] =			fkine_PAD(Arm_DH,xk,10);
yk = [Rt_T8 Tr_T8 Rt_Upperarm Tr_Upperarm Rt_Forearm Tr_Forerarm Rt_Hand Tr_Hand]
end

