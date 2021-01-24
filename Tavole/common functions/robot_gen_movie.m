function robot_gen_movie(arm, q, rep, nfig, movie_mode, movie_title, spins, View, rob_col)
%ARM_GEN_MOVIE generates a movie in which a given robotic arm execute the 
% movement with given q as input. 
%	INPUT:
%			arm		- SerialLink generated through PeterCorke Toolbox
%			q			- angle joint. can be either njoint x ntime or 
%							ntime x njoint.
%			rep			- optional input number of repetition of q. 
%							Default = 1
%			nfig		- optional input number of the fig. Default = 1
%			movie_mode	- 1 for movie writing, 2 for HD movie, 0 for only 
%							matlab animation. Default = 1
%			movie_title - string with title of the movie we want to save.
%							Default = 'movie_hand'
%			spins		- vector containing azimuth and elevation spin
%							angles
%			View		- initial view angles 
%			rob_col		- changes the colour scheme of the robot. 0 default
%							red and blue, 1 KUKA, 2 Franka
%			
%
%% check input
if nargin < 3
	rep = 1;
end

if nargin < 4
	nfig = 1;
end

if nargin < 5
	movie_mode = 1;
end

if nargin < 6
	movie_title = 'movie_robot';
end

if nargin < 7
	spinlon = -90;
	spinlat = 0;
else
	spinlon = spins(1);
	spinlat = spins(2);
end

if nargin < 8
	View = [110 10];
end

%% q
% check q
if size(q,2) ~= size(arm.links, 2)
	q = q';
end

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

% movie parameters
k = 1;				% init of movie's frames counter
movie_fps = 20;		% movie frame per second


% trajectory
col_traj	= [230, 153, 0]./255;
width_traj	= 2;

% robot
switch rob_col
	case 0
		% Default
		joint_col	= [255, 0, 0]./255;
		link_col	= [0, 0, 255]./255;
		joint_diam	= 0.5;
		
	case 1
		% KUKA
		joint_col	= [51, 26, 0]./255;
		link_col	= [255, 85, 0]./255;
		joint_diam	= 0.5;
	case 2
		% FRANKA
		joint_col	= [161, 161, 161]./255;
		link_col	= [255,247,230]./255;
		joint_diam	= 0.5;
end
	
	
tile1_col	= [208, 208, 225]./255; 
tile2_col	= [1 1 1];

%% animation&movie

t_tot = size(q_plot,1);		% time frames
EE_traj = [];				% EE trajectory

figh = figure(nfig);
clf

lighting phong;
set(gcf, 'Renderer', 'zbuffer');
axis equal
axis tight
hold on
grid on

% iteration
for i = 1:fr_skip:t_tot
	if i ~= 1
		delete(traj);
	end
	
	% update now vectors
	q_plot_now	= q_plot(i,:);
	EE_pos_now	= hom2vett(arm_fkine(arm, q_plot_now, size(arm.links, 2)));
	EE_traj = cat(1, EE_traj, EE_pos_now');
	
	%----------------------------------------------------------------------
	% robot update
	arm.plot(q_plot_now,...
		'noname',...
		'nobase',...
		'scale', 0.8,...
		'jointdiam',joint_diam,...
		'ortho',...
		'raise',...
		'shading',...
		'noshadow',...%'jaxes',...
		'jointcolor', joint_col,...
		'noarrow',...
		'tile1color', tile1_col,...
		'tile2color', tile2_col,...
		'linkcolor', link_col,...
		'floorlevel', 0);
	
	if i == 1 && movie_mode == 2
		figh.WindowState = 'maximize';
	elseif movie_mode ~= 2  
		% do nothing
	end
	
	% trajectory "so far" of EE
	traj =	plot3(  EE_traj(:,1), EE_traj(:,2),EE_traj(:,3),...
            '--','color', col_traj, 'LineWidth', width_traj);
	
	%----------------------------------------------------------------------
	% lims  plot
	xlim([-1 1])
	ylim([-1 1])
	zlim([0 1.2])
	xlabel('X [m]')
	ylabel('Y [m]')
	zlabel('Z [m]')

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
	disp([movie_title ' saved!'])

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

