function arm_10R = create_arms(trial)
%% Intro
% load only a single trial in order to test this script (in future, it is
% going to become a function(trial)).

% load('healthy_task.mat');
% trial = healthy_task(1).subject(1).left_side_trial(1);
% clear healthy_task;

%trial = struct_dataload('H01_T07_L1.mvnx');

%% initialization of robot parameters

par = par_10R(trial);

%first omogeneous transform from xsens to our frame_0
Tg0 = rt2tr(rotx(-pi/2), par.L5_pos); 
%% Costruction, right arm

d3 = par.depth_shoulder.right;
a3 = par.L5_shoulder.right;
d6 = -par.upperarm.right;
d8 = -par.forearm.right;
d10 = par.hand;

th3_r = -pi/2 - par.theta_shoulder.right;
al4_r = +pi/2 + par.theta_shoulder.right;

% serial links connection
Link_r = [	Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% L5-L5:				theta torso flexion  (pitch)
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', +pi/2),...	% L5-L5:				theta torso twist
			Link('d', d3,	'a',	a3,		'alpha', +pi/2,	'offset', +th3_r),...	% L5-shoulder:			theta shoulder "raise" 
			Link('d', 0,	'a',	0,		'alpha', al4_r, 'offset', +pi/2),...% shoulder1-shoulder2:	theta shoulder front opening
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', -pi/2),...	% shoulder2-shoulder3:	theta shoulder lateral opening
			Link('d', d6,	'a',	0,		'alpha', +pi/2),...						% shoulder3-elbow1:		theta shoulder pronosupination
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', pi),...		% elbow1-elbow2:		theta elbow flexion
			Link('d', d8,	'a',	0,		'alpha', -pi/2),...						% elbow2-wrist1:		theta forearm pronosupination
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2),...	% wrist1-wrist2:		theta wrist flexion
			Link('d', d10,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2)];		% wrist2-hand:			theta wrist (yaw)

Right_Arm = SerialLink(Link_r, 'name', 'Right arm');
Right_Arm.base = Tg0;

%% Costruction, left arm

d3 = -par.depth_shoulder.left;
a3 = par.L5_shoulder.left;
d6 = par.upperarm.left;
d8 = par.forearm.left;
d10 = par.hand;

th3_l = -pi/2 - par.theta_shoulder.left;
al4_l = +pi/2 + par.theta_shoulder.left;

% serial links connection
Link_l = [	Link('d', 0,	'a',	0,		'alpha', -pi/2),...						% L5-L5:				theta torso flexion  (pitch)
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2),...	% L5-L5:				theta torso twist
			Link('d', d3,	'a',	a3,		'alpha', -pi/2,	'offset', +th3_l),...	% L5-shoulder:			theta shoulder "raise" 
			Link('d', 0,	'a',	0,		'alpha', al4_l,	'offset', -pi/2),...	% shoulder1-shoulder2:	theta shoulder pronosupination
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', -pi/2),...	% shoulder2-shoulder3:	theta shoulder lateral opening
			Link('d', d6,	'a',	0,		'alpha', -pi/2, 'offset', +pi),...						% shoulder3-elbow1:		theta shoulder front opening
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', +pi),...	% elbow1-elbow2:		theta elbow flexion
			Link('d', d8,	'a',	0,		'alpha', +pi/2),...						% elbow2-wrist1:		theta forearm pronosupination
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', +pi/2),...	% wrist1-wrist2:		theta wrist flexion
			Link('d', d10,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2)];		% wrist2-hand:			theta wrist (yaw)

Left_Arm = SerialLink(Link_l, 'name', 'Left arm');
Left_Arm.base = Tg0;

% attenzione: il sistema di riferimento dell'ambiente 3D di Bot.plot e` il
% sistema di riferimento del primo Link (che crede essere il telaio) A MENO
% CHE non si specifichi Bot.base

%% output struct definition
arm_10R = struct('left', Left_Arm, 'right', Right_Arm);

end