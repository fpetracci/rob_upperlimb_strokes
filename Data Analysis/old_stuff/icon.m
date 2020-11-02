[	Link('d', 0,	'a',	0,		'alpha', -pi/2,'qlim', [-pi/4, +pi/2]),...								% L5-L5:				theta torso flexion  (pitch)
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2,'qlim',[-pi/4, +pi/4]),...		% L5-L5:				theta torso twist
			Link('d', d3,	'a',	a3,		'alpha', 0,		'offset', +th3_l,'qlim', [-0.26, +0.26]),...	% L5-shoulder:			theta shoulder "raise" 
			Link('d', 0,	'a',	0,		'alpha', +pi/2,	'offset', +th4_l,'qlim', [-pi/2, +pi]),...		% shoulder1-shoulder2:	theta shoulder pronosupination
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2, 'qlim', [-pi, +0.87]),...		% shoulder2-shoulder3:	theta shoulder lateral opening
			Link('d', 0,	'a',	a6,		'alpha', -pi/2, 'qlim', [-2.96, +pi/2]),...						% shoulder3-elbow1:		theta shoulder front opening
			Link('d', 0,	'a',	0,		'alpha', -pi/2, 'offset', -pi/2,'qlim', [-0.17, 2.53]),...		% elbow1-elbow2:		theta elbow flexion
			Link('d', d8,	'a',	0,		'alpha', +pi/2,'qlim', [-pi/2, pi/2]),...						% elbow2-wrist1:		theta forearm pronosupination
			Link('d', 0,	'a',	0,		'alpha', +pi/2, 'offset', +pi/2,'qlim', [-pi/2, 1.22]),...		% wrist1-wrist2:		theta wrist flexion
			Link('d', d10,	'a',	0,		'alpha', -pi/2, 'offset', -pi/2,'qlim', [-0.26, 0.7])];			% wrist2-hand:			theta wrist (yaw)
