%clear; clc; close;

load('healthy_task.mat');
trial = healthy_task(1).subject(1).right_side_trial(1);
clear healthy_task;
 %trial = struct_dataload('H01_T07_L1.mvnx');

%% define link of our serial links manipulator

lengths = lengths_10Rarm(trial);
l_h = 0; 	% wrist - hand

pos_sist0 = trial.T12.Pos(1,:); %BARBATRUCCO

%% Parte DestrA
T01_right = rt2tr(rotz(-pi/2)*rotz(pi/2)*rotx(-pi/2), pos_sist0'); %prima rotazione da xsens a nostro sist di rif

d2 = lengths.h_chest;
d3 = lengths.w_chest.right;
a3 = lengths.shoulder_l.right;
a6 = lengths.upperarm.right;
a7 = lengths.forearm.right;
d10 = -l_h;

% serial links connection
Link_r_shoulder = [	Link('d', 0,	'a',	0,		'alpha', +pi/2 , 'qlim', [-pi/6,+pi/6]),...						% T12-T12:			theta flessione busto (pitch)
					Link('d', d2,	'a',	0,		'alpha', +pi/2, 'offset', -pi/2, 'qlim', [-pi/6,+pi/6]),...	% T12-T8:			theta torsione petto
					Link('d', d3,	'a',	a3,		'alpha', 0, 'qlim', [-pi/6,+pi/6]),...							% T8-spalla1:		theta "alzata" spalla (abduzione?)
					Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% spalla1-spalla2:	theta spalla pronosupinazione
					Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', +pi/2),...	% spalla2-spalla3:	theta spalla spazzata orizzontale
					Link('d', 0,	'a',	a6,		'alpha', +pi/2)]; % spalla3-gomito:	theta spalla spazzata verticale
Right_Shoulder = SerialLink(Link_r_shoulder, 'name', 'Right_Shoulder');
Right_Shoulder.base = T01_right;

Link_r_elbow =	  [ Link_r_shoulder,...
					Link('d', 0,	'a',	a7,		'alpha', -pi/2,'qlim', [0,+pi])];% gomito-polso1:	theta gomito				

Right_Elbow = SerialLink(Link_r_elbow, 'name', 'Right_Elbow');
Right_Elbow.base = T01_right;

Link_r_hand  =    [	Link_r_elbow,...
					Link('d', 0,	'a',	0,		'alpha', +pi/2),...						% polso1-polso2:	theta polso pitch
					Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', -pi/2),...	% polso2-polso3:	theta polso yaw
					Link('d', d10,	'a',	0,		'alpha', +pi, 'offset', +pi/2)];		% polso3-ee:		theta polso pronosupinazione

Right_Hand = SerialLink(Link_r_hand, 'name', 'Right_Hand');
Right_Hand.base = T01_right;
%% IKUNC
q0 = Right_Hand.ikcon( rt2tr(quat2rotm(trial.Hand_R.Quat), trial.Hand_R.Pos') );
Right_Hand.plot(q0)