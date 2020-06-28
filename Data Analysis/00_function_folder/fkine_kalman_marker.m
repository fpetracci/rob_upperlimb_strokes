function yk = fkine_kalman_marker(qk, Arm)
% This function generates the measurement vector (33x1) for kalman filter.
%
% The measurement is the forward kinematics of the angular joints.
% The output vector is ordered as follow:
% 
% yk = [tr_L5_x; ...
% 		tr_L5_y; ...
% 		tr_shoulder; ...
% 		tr_shoulder_x; ...
% 		tr_shoulder_y; ...
% 		tr_elbow; ...
% 		tr_elbow_x; ...
% 		tr_elbow_y; ...
% 		tr_wrist; ...
% 		tr_wrist_x; ...
% 		tr_wrist_y];
		

% xsense frame = global (g) frame
% eul_* are the ZYZ Euler angles
d_trasl = 0.20;
%% L5
% Tg0 = arm_fkine(Arm, qk, 0);
% tr_L5 = Tg0(1:3, 4);			
% We are not going to use this variable since we can't move the origin of
% the 0-frame. Including it in the meas vector could lead into
% computational errors.

Tg3	= arm_fkine(Arm, qk, 3);
Tg3_trasl_x =  [Tg3(:,1:3) Arm.base(:,4) ] * [eye(3) [d_trasl 0 0]'; 0 0 0 1]; 
Tg3_trasl_y =  [Tg3(:,1:3) Arm.base(:,4) ] * [eye(3) [0 d_trasl 0]'; 0 0 0 1];

%tr_L5 = Arm.base(1:3,4);
tr_L5_x = Tg3_trasl_x(1:3, 4);
tr_L5_y = Tg3_trasl_y(1:3, 4);

rot_L5 = Tg3(1:3, 1:3);
eul_L5 = rotm2eul(rot_L5,'ZYZ')';

%% shoulder
% Tg3 = arm_fkine(Arm, qk, 3);

Tg6	= arm_fkine(Arm, qk, 6);
Tg6_trasl_x =  [Tg6(:,1:3) Tg3(:,4)] * [eye(3) [d_trasl 0 0]'; 0 0 0 1]; % ho riportato Tg6 nella forma correttta orientazione di Tg6, posizione di Tg3
Tg6_trasl_y =  [Tg6(:,1:3) Tg3(:,4)] * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
	
% plot_arrows(Tg6); %% non è proprio esatto perche la posizione è quella di Tg3

tr_shoulder = Tg3(1:3, 4);
tr_shoulder_x = Tg6_trasl_x(1:3, 4);
tr_shoulder_y = Tg6_trasl_y(1:3, 4);

rot_shoulder = Tg6(1:3, 1:3);
eul_shoulder = rotm2eul(rot_shoulder,'ZYZ')';


%% elbow
% Tg6 = arm_fkine(Arm, qk, 6);

Tg8	= arm_fkine(Arm, qk, 8);
Tg8_trasl_x =  [Tg8(:,1:3) Tg6(:,4)] * [eye(3) [d_trasl 0 0]'; 0 0 0 1]; 
Tg8_trasl_y =  [Tg8(:,1:3) Tg6(:,4)] * [eye(3) [0 d_trasl 0]'; 0 0 0 1];

tr_elbow = Tg6(1:3, 4);
tr_elbow_x = Tg8_trasl_x(1:3, 4);
tr_elbow_y = Tg8_trasl_y(1:3, 4);

rot_elbow = Tg8(1:3, 1:3);
eul_elbow = rotm2eul(rot_elbow,'ZYZ')';

%% wrist
% Tg8 = arm_fkine(Arm, qk, 8);

Tg10 = arm_fkine(Arm, qk, 10);
Tg10_trasl_x =  [Tg10(:,1:3) Tg8(:,4)] * [eye(3) [d_trasl 0 0]'; 0 0 0 1]; 
Tg10_trasl_y =  [Tg10(:,1:3) Tg8(:,4)] * [eye(3) [0 d_trasl 0]'; 0 0 0 1];

tr_wrist = Tg8(1:3, 4);
tr_wrist_x = Tg10_trasl_x(1:3, 4);
tr_wrist_y = Tg10_trasl_y(1:3, 4);

rot_wrist = Tg10(1:3, 1:3);
eul_wrist = rotm2eul(rot_wrist,'ZYZ')'; 


%% creation of measurement(qk) vector using Euler angles and traslations

 yk = [ tr_L5_x; ...
 		tr_L5_y; ...
		tr_shoulder; ...
		tr_shoulder_x; ...
		tr_shoulder_y; ...
		tr_elbow; ...
		tr_elbow_x; ...
		tr_elbow_y; ...
		tr_wrist; ...
		tr_wrist_x; ...
		tr_wrist_y];
		
end