%% Intro
clear; clc; close;

load('healthy.mat');
trial = healthy_task(1).subject(1).left_side_trial(1);
clear healthy_task;


%% define link of our serial links manipulator

P_Shoulder_R = trial.Shoulder_R.Pos(1,:);		% BARBATRUCCO, dobbiamo implementare spost spalla
P_Shoulder_L = trial.Shoulder_L.Pos(1,:);		% BARBATRUCCO, dobbiamo implementare spost spalla
a = lengths_arm(trial);
l_u_l = a(1); l_u_r = a(2); l_f_l = a(3); l_f_r = a(4); 
l_h = 0.15; 	% wrist - hand

% right
%add L1 and L8 to connect our arm to the neck and to the hand
%link definitions (to do) link tra giunti

%% Costruction, right arm

T01_right = rt2tr(rotx(+pi/2), Shoulder_R.Pos');

% serial links connection
Link_r = [	Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% spalla1-spalla2:	theta spalla pronosupinazione
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', +pi/2),...	% spalla2-spalla3:	theta spalla spazzata orizzontale
			Link('d', 0,	'a',	l_u_r,	'alpha', +pi/2),...						% spalla3-gomito:	theta spalla spazzata verticale
			Link('d', 0,	'a',	l_f_r,	'alpha', -pi/2),...						% gomito-polso1:	theta gomito
			Link('d', 0,	'a',	0,		'alpha', +pi/2),...						% polso1-polso2:	theta polso pitch
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', -pi/2),...	% polso2-polso3:	theta polso yaw
			Link('d', -l_h,	'a',	0,		'alpha', +pi, 'offset', +pi/2)];		% polso3-ee:		theta polso pronosupinazione

Right_Arm = SerialLink(Link_r, 'name', 'Right arm');
Right_Arm.base = T01_right;

%% Costruction, left arm

T01_left = rt2tr(rotx(-pi/2)*rotz(pi), Shoulder_L.Pos');

% serial links connection
Link_l = [	Link('d', 0,	'a',	0,		'alpha', +pi/2),...						% spalla1-spalla2:	theta spalla pronosupinazione
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2),...	% spalla2-spalla3:	theta spalla spazzata orizzontale
			Link('d', 0,	'a',	l_u_l,	'alpha', -pi/2),...						% spalla3-gomito:	theta spalla spazzata verticale
			Link('d', 0,	'a',	l_f_l,	'alpha', +pi/2),...						% gomito-polso1:	theta gomito
			Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% polso1-polso2:	theta polso pitch
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', -pi/2),...	% polso2-polso3:	theta polso yaw
 			Link('d', l_h,	'a',	0,		'alpha', 0,		'offset', +pi/2)];		% polso3-ee:		theta polso pronosupinazione

Left_Arm = SerialLink(Link_l, 'name', 'Left arm');
Left_Arm.base = T01_left;
%Left_Arm.tool = rt2tr(rotz(pi/2), [0; 0; l3_l]);

% attenzione: il sistema di riferimento dell'ambiente 3D di Bot.plot e` il
% sistema di riferimento del primo Link (che crede essere il telaio) A MENO
% CHE non si specifichi Bot.base

%% plot
q0_r = zeros(1, Right_Arm.n);		%initial config
q0_l = zeros(1, Left_Arm.n);

% % plot of the 7R in another configuration
% q = q0_l;
% for i=0:0.01:pi/2
% 	q(4) = i/2;
% 	Right_Arm.plot(q);
% 	Left_Arm.plot(q);
% end
% 
% Right_Arm.teach
% figure
% Left_Arm.teach

 
%% inv kine?

T0Hand_l = zeros(4, 4, size(trial.Hand_L.Pos,1));

quat_n = quaternion(trial.Neck.Quat);
quat_s = quaternion(trial.Shoulder_L.Quat);
quat_u = quaternion(trial.Upperarm_L.Quat);
quat_f = quaternion(trial.Forearm_L.Quat);
quat_h = quaternion(trial.Hand_L.Quat);
for i=1:size(quat_s,1)
	quat_hand(i,1) = quat_n(i) * quat_s(i) * quat_u(i) * quat_f(i) * quat_h(i);
end
for i=1:size(trial.P_Hand_L,1)
	T0Hand_l(:,:,i) = rt2tr(quat2rotm(quat_hand(i,1)), trial.Hand_L.Pos(i,:)');
end


qtry = Left_Arm.ikunc(T0Hand_l);

Left_Arm.plot(qtry)
Right_Arm.plot(qtry)

