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
eul_L5 = rotm2eul(rot_L5,'ZYZ')';

%% shoulder
% Tg3 = arm_fkine(Arm, qk, 3);
tr_shoulder = Tg3(1:3, 4);

Tg6	= arm_fkine(Arm, qk, 6);
Tg6_newx =  Tg6 * ([1 0 0 0.05; 0 1 0 0; 0 0 1 0; 0 0 0 1]);
Tg6_newy =	Tg6 * ([1 0 0 0; 0 1 0 0.05; 0 0 1 0; 0 0 0 1]) ;
	

    ox(1) = Tg6(1,4);
    oy(1) = Tg6(2,4);
    oz(1) = Tg6(3,4);
    ux(1) = Tg6(1,1);
    vx(1) = Tg6(2,1);
    wx(1) = Tg6(3,1);
    uy(1) = Tg6(1,2);
    vy(1) = Tg6(2,2);
    wy(1) = Tg6(3,2);
    uz(1) = Tg6(1,3);
    vz(1) = Tg6(2,3);
    wz(1) = Tg6(3,3);

    % Create graph
	figure(1), hold on
    quiver3(ox, oy, oz, ux, vx, wx,  'r', 'ShowArrowHead', 'on', 'MaxHeadSize', 0.999999, 'AutoScale', 'off');
    quiver3(ox, oy, oz, uy, vy, wy,  'g', 'ShowArrowHead', 'on', 'MaxHeadSize', 0.999999, 'AutoScale', 'off');
    quiver3(ox, oy, oz, uz, vz, wz,  'b', 'ShowArrowHead', 'on', 'MaxHeadSize', 0.999999, 'AutoScale', 'off');
	plot3(Tg6_newx(1,4),Tg6_newx(2,4),Tg6_newx(3,4),'*r')
	plot3(Tg6_newy(1,4),Tg6_newy(2,4),Tg6_newy(3,4),'*r')


rot_shoulder = Tg6(1:3, 1:3);
eul_shoulder = rotm2eul(rot_shoulder,'ZYZ')';


%% elbow
% Tg6 = arm_fkine(Arm, qk, 6);
tr_elbow = Tg6(1:3, 4);

Tg8	= arm_fkine(Arm, qk, 8);
rot_elbow = Tg8(1:3, 1:3);
eul_elbow = rotm2eul(rot_elbow,'ZYZ')';

%% wrist
% Tg8 = arm_fkine(Arm, qk, 8);
tr_wrist = Tg8(1:3, 4);

Tg10 = arm_fkine(Arm, qk, 10);
rot_wrist = Tg10(1:3, 1:3);
eul_wrist = rotm2eul(rot_wrist,'ZYZ')'; 


%% creation of measurement(qk) vector using Euler angles and traslations
% yk = [	eul_L5; ...
% 		tr_shoulder; ...
% 		eul_shoulder; ...
% 		tr_elbow; ...
% 		eul_elbow; ...
% 		tr_wrist; ...
% 		eul_wrist];

yk = [	eul_L5; ...
		tr_shoulder; ...
		eul_shoulder; ...
		tr_elbow; ...
		eul_elbow; ...
		tr_wrist; ...
		eul_wrist];

end