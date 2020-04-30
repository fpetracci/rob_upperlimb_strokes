%% Intro
clear; clc; close;
%% define link of our serial links manipulator

P_Shoulder_R = [0.2 0 1];
l1_r = 0.5;		% upperarm, shoulder - elbow
l2_r= 0.5;		% forearm, elbow - wrist
l3_r = 0.15; 	% wrist - hand

P_Shoulder_L = [-0.2 0 1];
l1_l = 0.5;		% upperarm, shoulder - elbow
l2_l= 0.5;		% forearm, elbow - wrist
l3_l = 0.15; 	% wrist - hand

% right
%add L1 and L8 to connect our arm to the neck and to the hand
%link definitions (to do)link tra giunti

%% Costruction, right arm

T01_right = rt2tr(rotx(+pi/2), P_Shoulder_R');

% serial links connection
Link_r = [	Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% spalla1-spalla2:	theta spalla pronosupinazione
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', +pi/2),...	% spalla2-spalla3:	theta spalla spazzata orizzontale
			Link('d', 0,	'a',	l1_r,	'alpha', +pi/2),...						% spalla3-gomito:	theta spalla spazzata verticale
			Link('d', 0,	'a',	l2_r,	'alpha', -pi/2),...						% gomito-polso1:	theta gomito
			Link('d', 0,	'a',	0,		'alpha', +pi/2),...						% polso1-polso2:	theta polso pitch
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', -pi/2),...	% polso2-polso3:	theta polso yaw
			Link('d', -l3_r,'a',	0,		'alpha', +pi, 'offset', +pi/2)];		% polso3-ee:		theta polso pronosupinazione

Right_Arm = SerialLink(Link_r, 'name', 'Right arm');
Right_Arm.base = T01_right;

%% Costruction, left arm

T01_left = rt2tr(rotx(-pi/2)*rotz(pi), P_Shoulder_L');

% serial links connection
Link_l = [	Link('d', 0,	'a',	0,		'alpha', +pi/2),...						% spalla1-spalla2:	theta spalla pronosupinazione
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2),...	% spalla2-spalla3:	theta spalla spazzata orizzontale
			Link('d', 0,	'a',	l1_l,	'alpha', -pi/2),...						% spalla3-gomito:	theta spalla spazzata verticale
			Link('d', 0,	'a',	l2_l,	'alpha', +pi/2),...						% gomito-polso1:	theta gomito
			Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% polso1-polso2:	theta polso pitch
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', -pi/2),...	% polso2-polso3:	theta polso yaw
 			Link('d', l3_l,	'a',	0,		'alpha', 0,		'offset', +pi/2)];		% polso3-ee:		theta polso pronosupinazione

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

Right_Arm.teach
figure
Left_Arm.teach