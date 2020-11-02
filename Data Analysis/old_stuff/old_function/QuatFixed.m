%% forse è tutto sbagliato
function [Quat_Hand,Quat_Elbow] = QuatFixed(trial)

quat_t12 = quaternion(trial.T12.Quat);
quat_t8 = quaternion(trial.T8.Quat);
quat_s = quaternion(trial.Shoulder_L.Quat);
quat_u = quaternion(trial.Upperarm_L.Quat);
quat_f = quaternion(trial.Forearm_L.Quat);
quat_h = quaternion(trial.Hand_L.Quat);

for i=1:size(trial.Hand_L.Quat,1)
	Hand_L_Quat = quat_t12*quat_t8(i)*quat_s(i)*quat_u(i)*quat_f(i)*quat_h(i);
	T0Hand_l(:,:,i) = rt2tr(quat2rotm(Hand_L_Quat(i)), trial.Hand_L.Pos(i,:)');
end
Quat_Hand = rotm2quat(tr2rt(T0Hand_l));

for i=1:size(trial.Forearm_L.Quat,1)
	Forearm_L_Quat = quat_t12*quat_t8(i)*quat_s(i)*quat_u(i)*quat_f(i);
	T0Elbow_l(:,:,i) = rt2tr(quat2rotm(Forearm_L_Quat(i)), trial.Forearm_L.Pos(i,:)');
end
Quat_Elbow = rotm2quat(tr2rt(T0Elbow_l));

end

