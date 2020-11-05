function arm_gen_movie(q, rep, nfig, movie_mode, movie_title)
%ARM_GEN_MOVIE generates a movie in which a general right arm does the 
% movement with given q as input. It also puts in the scene a hand and a 
% head.
%	INPUT:
%			q			- angle joint. can be either njoint x ntime or 
%							ntime x njoint.
%			rep			- optional input number of repetition of q. 
%							Default = 1
%			nfig		- optional input number of the fig. Default = 1
%			movie_mode	- 1 for movie writing, 2 for HD movie, 0 for only 
%							matlab animation. Default = 1
%			movie_title - string with title of the movie we want to save.
%							Default = 'movie_hand'
%			
%
%% check input
if nargin < 2
	rep = 1;
end

if nargin < 3
	nfig = 1;
end

if nargin < 4
	movie_mode = 1;
end

if nargin < 5
	movie_title = 'movie_hand';
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

%% animation parameters

% how many frames we want to skip
fr_skip = 1;

% pause time in the animation
time_pause = 0;

% view angles
View = [110 10];				% initial view

spinlon = -90;
spinlat = 0;

% movie parameters
k = 1;				% init of movie's frames counter
movie_fps = 20;		% movie frame per second

% stl handling
alpha_edge		= 0.1;
%hand
col_hand_edge	= [100,100,100]./255;	% hand edge colour RGB
col_hand_face	= [0,0,0]./255;			% hand face colour RGB
scale_hand		= 1/1000;				% hand stl is in mm.
stl_hand_offset = [+0.03; 0; 0];		% recenter  the stl in [0;0;0].
stl_hand_rotate = rotz(25/180*pi);		% rotate the stl so the thumb is in
										% the positive x direction, index 
										% in the positive z direction.
%head
col_head_edge = [255,255,255]./255;
col_head_face = [50,50,50]./255;
scale_head	= 0.7*1/1000;					% hand stl is in mm
shoulder_pos = hom2vett(arm_fkine(arm, zeros(10,1), 6)); % armfkine to get shoulder height
L5_pos = hom2vett(arm_fkine(arm, zeros(10,1), 1)); % armfkine to get shoulder height


head_offset = [-0.26 - shoulder_pos(1); -0.2 - L5_pos(2); shoulder_pos(3)];
head_rotate = rotz(pi/2);

% trajectory
col_traj	= [0,0,0]./255;
width_traj	= 2;

%% animation&movie

t_tot = size(q_plot,1);		% time frames
hand_traj = [];				% hand trajectory

figh = figure(nfig);
clf

xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')

% figure settings
%set(gca, 'drawmode', 'fast');
lighting phong;
set(gcf, 'Renderer', 'zbuffer');
axis equal
axis tight
hold on
grid on



% init head model
p_head = patch(stlread('head_david.stl'));
T_head = hgmat(head_rotate*scale_head, [0;0;0]+head_offset);
t_head = hgtransform('Parent',gca);
set(t_head,'Matrix',T_head);
set(p_head,'Parent',t_head);
set(p_head, 'FaceColor', col_head_face);	% Set the face colour
set(p_head, 'EdgeColor', col_head_edge);	% Set the edge colour
set(p_head, 'EdgeAlpha', alpha_edge);		% Set the edge transparency (0 transparent)

% init hand model
p_hand = patch(stlread('Hand_model.stl'));
T_hand_offset = hgmat(stl_hand_rotate*scale_hand, [0;0;0]+stl_hand_offset);
t_hand = hgtransform('Parent',gca);
set(t_hand,'Matrix',T_hand_offset);
set(p_hand,'Parent',t_hand);
set(p_hand, 'FaceColor', col_hand_face);	% Set the face colour
set(p_hand, 'EdgeColor', col_hand_edge);	% Set the edge colour
set(p_hand, 'EdgeAlpha', alpha_edge);		% Set the edge transparency (0 transparent)

% 


for i = 1:fr_skip:t_tot
	if i ~= 1
		delete(traj);
	end
	
	% update now vectors
	q_plot_now	= q_plot(i,:);
	T_wrist_now	= arm_fkine(arm, q_plot_now, 10);
	pos_wrist = hom2vett(T_wrist_now);
	hand_traj = cat(1, hand_traj, pos_wrist');
	
	%----------------------------------------------------------------------
	% robot update
	arm.plot(q_plot_now,...
		'noname',...
		'scale', 1,...
		'jointdiam',1,...
		'ortho',...
		'raise',...
		'floorlevel', 0);
	
	if i == 1 && movie_mode == 2
		% prompt figure HD
		t1 = text(0.35,0.5,'Maximize this window, then return to matlab and press any key.', 'FontSize',14);
		t2 = text(0.4,0.45,'Note that a 1080p resolution is needed.', 'FontSize',14);
		pause
		delete(t1)
		delete(t2)
		
		% replot the robot
		arm.plot(q_plot_now,...
		'noname',...
		'scale', 1,...
		'jointdiam',1,...
		'ortho',...
		'raise',...
		'floorlevel', 0);
	end
		
	

	% hand update
	T_hand_now = T_wrist_now * T_hand_offset;
	set(t_hand,'Matrix',T_hand_now);
	
	
	% trajectory "so far" of spacecraft
	traj =	plot3(  hand_traj(:,1), hand_traj(:,2),hand_traj(:,3),...
            'color', col_traj, 'LineWidth', width_traj);
	
	
	
	%----------------------------------------------------------------------
	% lims  plot
	xlim([-1 1])
	ylim([-1 1])
	zlim([0 2])
		
	%----------------------------------------------------------------------
	% end stuff

	% view update
	if spinlon == 0 && spinlat == 0	
		if i == 1
			view(View(1, 1), View(1, 2));
		end
	else
		view(View(1, 1) + spinlon * i/t_tot, View(1, 2) + spinlat* i/t_tot);
	end
	
	% pause time
	if time_pause ~= 0
		pause(time_pause)
	end
	
	drawnow
	
	%----------------------------------------------------------------------
	% write video
	if movie_mode ~= 0
		if movie_mode == 1
			movieVector(k) = getframe(figh);
		elseif movie_mode == 2
			movieVector(k) = getframe(figh, [10,10,1910,960]);
		end		
		k = k+1;
	end
	
end

%--------------------------------------------------------------------------
% Video stuff
if movie_mode
	movie = VideoWriter( movie_title, 'MPEG-4');
	movie.FrameRate = movie_fps;

	open(movie);
	writeVideo(movie, movieVector);
	close(movie);
	disp('Movie saved!')

end

end

%% custom fuctions
%% hgmat
function T = hgmat(rot, vett)

T = [rot, vett; 0 0 0 1];

end

%%  hom2vett
function vett = hom2vett(T)

vett = T(1:3,4);

end

