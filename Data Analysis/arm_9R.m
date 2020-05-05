%% Intro
clear; clc; close;

load('healthy.mat');
trial = healthy_task(1).subject(1).left_side_trial(1);
clear healthy_task;


%% define link of our serial links manipulator

lenghts = lengths_arm(trial);
l_h = 0.15; 	% wrist - hand

pos_pelvis = trial.Pelvis.Pos(1,:); %BARBATRUCCO
%% Costruction, right arm
T01_right = rt2tr(eye(3), pos_pelvis');

d1 = lengths.h_torso;
d2 = lengths.d_neck;
a2 = lengths.shoulder.right;
a5 = lenghts.upperarm.right;
a6 = lenghts.forearm.right;
d9 = -l_h;

% serial links connection
Link_r = [	Link('d', d1,	'a',	0,		'alpha', +pi/2),...						% bacino-Neck':		theta torsione busto
			Link('d', d2,	'a',	a2,		'alpha', 0),...							% Neck'-spalla1:	theta "alzata" spalla (abduzione?)
			Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% spalla1-spalla2:	theta spalla pronosupinazione
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', +pi/2),...	% spalla2-spalla3:	theta spalla spazzata orizzontale
			Link('d', 0,	'a',	a5,		'alpha', +pi/2),...						% spalla3-gomito:	theta spalla spazzata verticale
			Link('d', 0,	'a',	a6,		'alpha', -pi/2),...						% gomito-polso1:	theta gomito
			Link('d', 0,	'a',	0,		'alpha', +pi/2),...						% polso1-polso2:	theta polso pitch
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', -pi/2),...	% polso2-polso3:	theta polso yaw
			Link('d', d9,	'a',	0,		'alpha', +pi, 'offset', +pi/2)];		% polso3-ee:		theta polso pronosupinazione

Right_Arm = SerialLink(Link_r, 'name', 'Right arm');
Right_Arm.base = T01_right;

%% Costruction, left arm
T01_right = rt2tr(roty(pi), pos_pelvis');

d1 = lengths.h_torso;
d2 = lengths.d_neck;
a2 = lengths.shoulder.left;
a5 = lenghts.upperarm.left;
a6 = lenghts.forearm.left;
d9 = +l_h;


% serial links connection
Link_l = [	Link('d', d1,	'a',	0,		'alpha', -pi/2),...						% bacino-Neck':		theta torsione busto
			Link('d', d2,	'a',	a2,		'alpha', 0),...							% Neck'-spalla1:	theta "alzata" spalla (abduzione?)
			Link('d', 0,	'a',	0,		'alpha', +pi/2),...						% spalla1-spalla2:	theta spalla pronosupinazione
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2),...	% spalla2-spalla3:	theta spalla spazzata orizzontale
			Link('d', 0,	'a',	a5,		'alpha', -pi/2),...						% spalla3-gomito:	theta spalla spazzata verticale
			Link('d', 0,	'a',	a6,		'alpha', +pi/2),...						% gomito-polso1:	theta gomito
			Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% polso1-polso2:	theta polso pitch
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', -pi/2),...	% polso2-polso3:	theta polso yaw
 			Link('d', d9,	'a',	0,		'alpha', 0,		'offset', +pi/2)];		% polso3-ee:		theta polso pronosupinazione

Left_Arm = SerialLink(Link_l, 'name', 'Left arm');
Left_Arm.base = T01_left;

% attenzione: il sistema di riferimento dell'ambiente 3D di Bot.plot e` il
% sistema di riferimento del primo Link (che crede essere il telaio) A MENO
% CHE non si specifichi Bot.base

%% plot
q0 = zeros(1, Right_Arm.n);		%initial config


%% inv kine?


