%% Intro
clear; clc; close;

% load('healthy_task.mat');
% trial = healthy_task(1).subject(1).left_side_trial(1);
% clear healthy_task;
 trial = struct_dataload('H01_T07_L1.mvnx');

%% define link of our serial links manipulator

lengths = lengths_10Rarm(trial);
l_h = 0.15; 	% wrist - hand

pos_sist0 = trial.T12.Pos(1,:); %BARBATRUCCO

%% Costruction, right arm

T01_right = rt2tr(rotz(-pi/2)*rotz(pi/2)*rotx(-pi/2), pos_sist0'); %prima rotazione da xsens a nostro sist di rif

d2 = lengths.h_chest;
d3 = lengths.w_chest.right;
a3 = lengths.shoulder_l.right;
a6 = lengths.upperarm.right;
a7 = lengths.forearm.right;
d10 = -l_h;

% serial links connection
Link_r = [	Link('d', 0,	'a',	0,		'alpha', +pi/2),...						% T12-T12:			theta flessione busto (pitch)
			Link('d', d2,	'a',	0,		'alpha', +pi/2, 'offset', -pi/2),...	% T12-T8:			theta torsione petto
			Link('d', d3,	'a',	a3,		'alpha', 0),...							% T8-spalla1:		theta "alzata" spalla (abduzione?)
			Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% spalla1-spalla2:	theta spalla pronosupinazione
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', +pi/2),...	% spalla2-spalla3:	theta spalla spazzata orizzontale
			Link('d', 0,	'a',	a6,		'alpha', +pi/2),...						% spalla3-gomito:	theta spalla spazzata verticale
			Link('d', 0,	'a',	a7,		'alpha', -pi/2),...						% gomito-polso1:	theta gomito
			Link('d', 0,	'a',	0,		'alpha', +pi/2),...						% polso1-polso2:	theta polso pitch
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', -pi/2),...	% polso2-polso3:	theta polso yaw
			Link('d', d10,	'a',	0,		'alpha', +pi, 'offset', +pi/2)];		% polso3-ee:		theta polso pronosupinazione

Right_Arm = SerialLink(Link_r, 'name', 'Right arm');
Right_Arm.base = T01_right;

%% Costruction, left arm
T01_left = rt2tr(rotz(-pi/2)*rotz(pi/2)*rotx(-pi/2), pos_sist0');

d2 = lengths.h_chest;
d3 = lengths.w_chest.left;
a3 = lengths.shoulder_l.left;
a6 = lengths.upperarm.left;
a7 = lengths.forearm.left;
d10 = l_h;


% serial links connection
Link_l = [	Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi),...		% T12-T12:			theta flessione busto (pitch)
			Link('d', -d2,	'a',	0,		'alpha', -pi/2, 'offset', +pi/2),...	% T12-T8:			theta torsione petto
			Link('d', d3,	'a',	a3,		'alpha', 0),...							% T8-spalla1:		theta "alzata" spalla (abduzione?)
			Link('d', 0,	'a',	0,		'alpha', +pi/2),...						% spalla1-spalla2:	theta spalla pronosupinazione
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2),...	% spalla2-spalla3:	theta spalla spazzata orizzontale
			Link('d', 0,	'a',	a6,		'alpha', -pi/2),...						% spalla3-gomito:	theta spalla spazzata verticale
			Link('d', 0,	'a',	a7,		'alpha', +pi/2),...						% gomito-polso1:	theta gomito
			Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% polso1-polso2:	theta polso pitch
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', -pi/2),...	% polso2-polso3:	theta polso yaw
 			Link('d', d10,	'a',	0,		'alpha', 0,		'offset', +pi/2)];		% polso3-ee:		theta polso pronosupinazione

Left_Arm = SerialLink(Link_l, 'name', 'Left arm');
Left_Arm.base = T01_left;

% attenzione: il sistema di riferimento dell'ambiente 3D di Bot.plot e` il
% sistema di riferimento del primo Link (che crede essere il telaio) A MENO
% CHE non si specifichi Bot.base

%% plot
q0 = zeros(1, Right_Arm.n);		%initial config
q0 = Left_Arm.ikunc( rt2tr(quat2rotm(trial.Hand_L.Quat), trial.Hand_L.Pos') );
Right_Arm.plot(q0)
view([25 10 45])
figure(2)
Left_Arm.plot(q0)

%% inv kine?


