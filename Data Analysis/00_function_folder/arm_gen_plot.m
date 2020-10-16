function arm_gen_plot(q, rep, nfig)
%ARM_GEN_PLOT animates a general right arm given q. The parameters of the 
%	arm animated are of a chosen at priori trial and not editable.
%	INPUT:
%			q		- angle joint. can be either njoint x ntime or ntime x
%						njoint.
%			rep		- optional input number of repetition of q. Default = 1
%			nfig	- optional input number of the fig
%			
%
%% check input
if nargin < 2
	rep = 1;
end

if nargin < 3
	nfig = 1;
end

%% parameter of trial = healthy_task(1).subject(1).left_side_trial(1);

d3		= 0.1494;
a3		= 0.3912;
d6		= -0.3180;
d8		= -0.2603;
d10		= 0;
th3_r	= -1.9598;
al4_r	= 1.9598;

Tg0 = [1 0 0 -0.2401; 0 0 1 0.0161; 0 -1 0 0.8730; 0 0 0 1];

%% create arm
% serial links connection
Link_r = [	... % L5-L5:				theta torso flexion  (pitch)
			Link('d', 0,	'a',	0,		'alpha', +pi/2,						'qlim',	[-pi/4, +pi/2]),...
			... % L5-L5:				theta torso twist 
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', +pi/2,	'qlim',	[-pi/4, +pi/4]),...	
			... % L5-shoulder:			theta shoulder "raise" 
			Link('d', d3,	'a',	a3,		'alpha', +pi/2,	'offset', +th3_r,	'qlim', [-0.26, +0.26]),...
			... % shoulder1-shoulder2:	theta shoulder front opening
			Link('d', 0,	'a',	0,		'alpha', al4_r, 'offset', +pi/2,	'qlim', [-2.96, +pi/2]),...
			... % shoulder2-shoulder3:	theta shoulder lateral opening
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', -pi/2,	'qlim', [-pi, +0.87]),...
			... % shoulder3-elbow1:		theta shoulder pronosupination
			Link('d', d6,	'a',	0,		'alpha', +pi/2,						'qlim', [-pi/2, +pi]),...
			... % elbow1-elbow2:		theta elbow flexion
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', pi,		'qlim', [-0.17, 2.53]),...
			... % elbow2-wrist1:		theta 90
			Link('d', d8,	'a',	0,		'alpha', -pi/2,						'qlim', [-pi/2, pi]),...
			... % wrist1-wrist2:		theta wrist flexion
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2,	'qlim', [-pi/2, 1.22]),...
			... % wrist2-hand:			theta wrist (yaw)
			Link('d', d10,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2,	'qlim', [-0.26, 0.26])];		

arm = SerialLink(Link_r, 'name', 'Right arm');
arm.base = Tg0;

%% q
% check q
if size(q,2) ~= 10
	q = q';
end
q = q./180*pi;

% q stack for repetition
q_plot = [];
for i = 1:rep
	q_plot = cat(1, q_plot, q);
end

%% animation
disp('Animation started...')
figure(nfig)
%figure('units','normalized','outerposition',[0 0 1 1])
clf
arm.plot(q_plot,...
		'workspace', [-1 1 -1 1 0 2],...
		'fps', 60,...
		'raise',...
		'ortho',...
		'view', [25 10],...
		'noname',...
		'scale', 0.5,...
		'jointdiam',1,...
		'floorlevel', 0,...
		'trail', 'k.',...
		'noloop');
	
disp('Animation ended!')

end

