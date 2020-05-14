function yk = fkine_kalman(qk, Arm)
% This function generates the measurement vector (21x1) for kalman filter.
%
% The measurement is the forward kinematics of the angular joints.
% The output vector is ordered as follow:
% 		yk = [	eul_L5; ...
% 				tr_shoulder; ...
% 				eul_shoulder; ...
% 				tr_elbow; ...
% 				eul_elbow; ...
% 				tr_wrist; ...
% 				eul_wrist];

% xsense frame = global (g) frame
% eul_* are the ZYZ Euler angles

%% L5
% Tg0 = arm_fkine(Arm, qk, 0);
% tr_L5 = Tg0(1:3, 4);			
% We are not going to use this variable since we can't move the origin of
% the 0-frame. Including it in the meas vector could lead into
% computational errors.

Tg3	= arm_fkine(Arm, qk, 3);
rot_L5 = Tg3(1:3, 1:3);
eul_L5 = tr2eul(rot_L5)';

%% shoulder
% Tg3 = arm_fkine(Arm, qk, 3);
tr_shoulder = Tg3(1:3, 4);

Tg6	= arm_fkine(Arm, qk, 6);
rot_shoulder = Tg6(1:3, 1:3);
eul_shoulder = tr2eul(rot_shoulder)';

%% elbow
% Tg6 = arm_fkine(Arm, qk, 6);
tr_elbow = Tg6(1:3, 4);

Tg8	= arm_fkine(Arm, qk, 8);
rot_elbow = Tg8(1:3, 1:3);
eul_elbow = tr2eul(rot_elbow)';

%% wrist
% Tg8 = arm_fkine(Arm, qk, 8);
tr_wrist = Tg8(1:3, 4);

Tg10 = arm_fkine(Arm, qk, 10);
rot_wrist = Tg10(1:3, 1:3);
eul_wrist = tr2eul(rot_wrist)';


%% creation of measurement(qk) vector using Euler angles and traslations
% yk = [	eul_L5; ...
% 		tr_shoulder; ...
% 		eul_shoulder; ...
% 		tr_elbow; ...
% 		eul_elbow; ...
% 		tr_wrist; ...
% 		eul_wrist];

% PROVE
yk = [	tr_shoulder; ...
		%eul_elbow; ...
		tr_wrist; ...
		eul_wrist];

end