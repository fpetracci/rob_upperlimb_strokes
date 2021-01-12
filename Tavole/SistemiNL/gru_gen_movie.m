function gru_gen_movie(out, flag_rel, rep, nfig, movie_mode, movie_title, spins, View)
% questa funzione genera l'animazione della gru
%IN:		out			- output simulazione da simulink
%			flag_rel	- flag per animare o meno la palla in posizione
%							relativa al cart o meno.
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
	movie_title = 'movie_gru';
end

if nargin < 7
	spinlon = -90;
	spinlat = 0;
else
	spinlon = spins(1);
	spinlat = spins(2);
end

if nargin < 8
	View = [45 12];
end

%% Get signals
% stato
time		= out.state_ts.Time;
nsteps		= length(time);

% pos palla
ball_traj	= out.pos_ball.Data(:,1:3);

if flag_rel == 1
	z_t = 0;
	for i = 1:nsteps
		ball_traj(i,:) =  ball_traj(i,:) - [out.state_ts.Data(i,1), out.state_ts.Data(i,3), z_t];
	end
	clear z_t;
end

%% animation parameters

% how many frames we want to skip
fr_skip = 100;

% pause time in the animation
time_pause = 0;

% movie parameters
k = 1;				% init of movie's frames counter
movie_fps = 20;		% movie frame per second

% trajectory
col_traj	= [230, 153, 0]./255;
width_traj	= 2;

%% animation&movie

figh = figure(nfig);
clf

% figure settings
axis equal
hold on
grid on

for i = 1:fr_skip:nsteps
	if i ~= 1
		% delete last step stuff
		delete(traj)
		delete(p1)
		delete(p2)
		delete(p3)
	end
	
	
	% gru plot
	[p1, p2, p3] = draw_gru(out, i, flag_rel, nfig);
	

	% trajectory "so far" of ball
	traj =	plot3(  ball_traj(1:i,1), ball_traj(1:i,2), -ball_traj(1:i,3),...
            '--','color', col_traj, 'LineWidth', width_traj);

%----------------------------------------------------------------------
	% lims  plot
	[xlims, ylims, zlims] = get_lims(ball_traj);
	xlim(xlims)
	ylim(ylims)
	zlim(zlims)
	xlabel('X [m]')
	ylabel('Y [m]')
	zlabel('Z [m]')

	%----------------------------------------------------------------------
	% end stuff

	% maximize window
	if i == 1 && movie_mode == 2
		figh.WindowState = 'maximize';
	elseif movie_mode ~= 2  
		% do nothing
	end
	
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

%% Extra Functions
function [p1, p2, p3] = draw_gru(out, i, flag_rel, nfig)
% out			- simulink output
% i				- i.th timeframe
% flag_rel		- if 1 pos_ball relativa

%% get signals
% stato 
x_t			= out.state_ts.Data(i,1);
% x_t_dot		= out.state_ts.Data(i,2);
y_t			= out.state_ts.Data(i,3);
% y_t_dot		= out.state_ts.Data(i,4);
% theta		= out.state_ts.Data(i,5);	
% theta_dot	= out.state_ts.Data(i,6);
% phi			= out.state_ts.Data(i,7);
% phi_dot		= out.state_ts.Data(i,8);
% L			= out.state_ts.Data(i,9);
% L_dot		= out.state_ts.Data(i,10);		
z_t			= 0;

% palla
x_b			= out.pos_ball.Data(i,1);
y_b			= out.pos_ball.Data(i,2);
z_b			= out.pos_ball.Data(i,3);

% plot relativo o meno
if flag_rel == 1
	x_b = x_b - x_t;
	y_b = y_b - y_t;
	z_b = z_b - z_t;
	
	x_t = 0;
	y_t = 0;
	z_t = 0;
end

%% parametri plots

%% plots
figure(nfig)
% asta
p1 = plot3([x_b; x_t], [y_b; y_t], -[z_b; z_t], 'k-', 'LineWidth', 2);
hold on
% palla
p2 = plot3(x_b, y_b, -z_b, 'bo', 'Markersize', 10);
% cart
p3 = plot3(x_t, y_t, -z_t, 'rd', 'Markersize', 5);



end

function [xlims, ylims, zlims] = get_lims(ball_traj)
	
	gap = 2;
	xlims = [min(ball_traj(:,1))-gap, max(ball_traj(:,1))+gap];
	ylims = [min(ball_traj(:,2))-gap, max(ball_traj(:,2))+gap];
	zlims = [min(-ball_traj(:,3))-gap, max(-ball_traj(:,3))+gap];
end
