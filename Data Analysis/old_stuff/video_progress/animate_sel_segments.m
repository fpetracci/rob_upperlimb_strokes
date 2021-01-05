function animate_sel_segments(trial, nfig, movie_mode, movie_title)

%% parse inputs
if nargin < 3
	movie_mode = 1;
end

if nargin < 4
	movie_title = 'movie_hand';
end

%% figure
skipframe = 1;
figh = figure(nfig);
clf

%% Constant definition
nSamples = size(trial.L5.Pos,1);

% colours
col_L5.Pos = 'ko';	% colour Head.Pos, Neck.Pos and Pelvis.Pos
col_L5.Pos_in = 'k';	% colour inside of the Head.Pos and Neck.Pos
col_h = 'go';		% colour healthy arm
col_h_in = 'g';		% colour inside healthy arm
col_s = 'ro';		% colour stroke arm
col_s_in = 'r';		% colour stroke arm inside
col_segm = 'k-';	% colour segment

% check if right / left arm is healthy or not
% upper limb with strokes 0-->Left 1--> Right, -1-->Both arm healthy
if trial.stroke_side == -1
	col_r = col_h;			% colour right arm
	col_r_in = col_h_in;	% colour inside right arm
	col_l = col_h;			% colour left arm
	col_l_in = col_h_in;	% colour left arm inside
elseif trial.stroke_side == 0
	col_r = col_h;			% colour right arm
	col_r_in = col_h_in;	% colour inside right arm
	col_l = col_s;			% colour stroke - left arm 
	col_l_in = col_s_in;	% colour inside stroke - left arm 
elseif trial.stroke_side == 1
	col_r = col_s;			% colour stroke - right arm
	col_r_in = col_s_in;	% colour inside stroke - right arm
	col_l = col_h;			% colour left arm
	col_l_in = col_h_in;	% colour left arm inside
else
	warning('stroke_side not found! Grey colour used instead')
	col_r = 'e';			% colour right arm
	col_r_in = 'e';			% colour inside right arm
	col_l = 'e';			% colour left arm
	col_l_in = 'e';			% colour left arm inside
	
end

% marker dimensions
dim_small	= 8;		% small marker dimension (shoulder, Neck.Pos, elbow)
dim_big		= 10;		% big marker dimension (hands, Head.Pos)

% limits for plot
lims = plot_lims(trial);

% movie parameters
k = 1;				% init of movie's frames counter
movie_fps = 20;		% movie frame per second

%% Animation
for i=1:skipframe:(nSamples)
	
	 
	%% L5
	plot3(trial.L5.Pos(i,1),...
        trial.L5.Pos(i,2),...
        trial.L5.Pos(i,3),...
        col_L5.Pos,'MarkerSize', dim_big,'MarkerFaceColor',col_L5.Pos_in)
	%plot1.Color(4) = 0.2;
    grid on
    hold on
	
	% L5 - Upperarm_R
    plot3([trial.L5.Pos(i,1); trial.Upperarm_R.Pos(i,1)],...
        [trial.L5.Pos(i,2); trial.Upperarm_R.Pos(i,2)],...
        [trial.L5.Pos(i,3); trial.Upperarm_R.Pos(i,3)],...
         col_segm)
	 % L5 - Upperarm_L
	 plot3([trial.L5.Pos(i,1); trial.Upperarm_L.Pos(i,1)],...
        [trial.L5.Pos(i,2); trial.Upperarm_L.Pos(i,2)],...
        [trial.L5.Pos(i,3); trial.Upperarm_L.Pos(i,3)],...
         col_segm)
	 

	%% right arm 
   
    % right upper arm
    plot3(trial.Upperarm_R.Pos(i,1),...
        trial.Upperarm_R.Pos(i,2),...
        trial.Upperarm_R.Pos(i,3),...
         col_r,'MarkerSize', dim_small,'MarkerFaceColor', col_r_in)
    
    % right upper arm - right forearm
    plot3([trial.Upperarm_R.Pos(i,1); trial.Forearm_R.Pos(i,1)],...
        [trial.Upperarm_R.Pos(i,2); trial.Forearm_R.Pos(i,2)],...
        [trial.Upperarm_R.Pos(i,3); trial.Forearm_R.Pos(i,3)],...
         col_segm)
	 
    % right forearm
    plot3(trial.Forearm_R.Pos(i,1),...
        trial.Forearm_R.Pos(i,2),...
        trial.Forearm_R.Pos(i,3),...
         col_r,'MarkerSize', dim_small,'MarkerFaceColor', col_r_in)
    
    % right forearm - right hand
	plot3([trial.Forearm_R.Pos(i,1); trial.Hand_R.Pos(i,1)],...
        [trial.Forearm_R.Pos(i,2); trial.Hand_R.Pos(i,2)],...
        [trial.Forearm_R.Pos(i,3); trial.Hand_R.Pos(i,3)],...
         col_segm)
	
    % right hand
    plot3(trial.Hand_R.Pos(i,1),...
        trial.Hand_R.Pos(i,2),...
        trial.Hand_R.Pos(i,3),...
         col_r,'MarkerSize', dim_big,'MarkerFaceColor', col_r_in)
	 draw_frame(trial.Hand_R.Pos(i,:), quat2rotm(trial.Hand_R.Quat(i,:)), 0.2)

	%% left arm
	   
    % left upper arm
    plot3(trial.Upperarm_L.Pos(i,1),...
        trial.Upperarm_L.Pos(i,2),...
        trial.Upperarm_L.Pos(i,3),...
         col_l,'MarkerSize', dim_small,'MarkerFaceColor', col_l_in)
    
    % left upper arm - left forearm
    plot3([trial.Upperarm_L.Pos(i,1); trial.Forearm_L.Pos(i,1)],...
        [trial.Upperarm_L.Pos(i,2); trial.Forearm_L.Pos(i,2)],...
        [trial.Upperarm_L.Pos(i,3); trial.Forearm_L.Pos(i,3)],...
         col_segm)
	 
    % left forearm
    plot3(trial.Forearm_L.Pos(i,1),...
        trial.Forearm_L.Pos(i,2),...
        trial.Forearm_L.Pos(i,3),...
         col_l,'MarkerSize', dim_small,'MarkerFaceColor', col_l_in)
    
    % left forearm - left hand
	plot3([trial.Forearm_L.Pos(i,1); trial.Hand_L.Pos(i,1)],...
        [trial.Forearm_L.Pos(i,2); trial.Hand_L.Pos(i,2)],...
        [trial.Forearm_L.Pos(i,3); trial.Hand_L.Pos(i,3)],...
         col_segm)
	
    % left hand
    plot3(trial.Hand_L.Pos(i,1),...
        trial.Hand_L.Pos(i,2),...
        trial.Hand_L.Pos(i,3),...
         col_l,'MarkerSize', dim_big,'MarkerFaceColor', col_l_in)
	draw_frame(trial.Hand_L.Pos(i,:), quat2rotm(trial.Hand_L.Quat(i,:)), 0.2)
	 

    %% option plot
    xlabel('x [m]');    ylabel('y [m]');    zlabel('z [m]');
    axis equal
	title([' Recorded trial animation (frame: ' num2str(i) ' of ' num2str(nSamples) ')'])
	
    xlim([lims(1), lims(2)]);  ylim([lims(3), lims(4)]); zlim([lims(5), lims(6)]);
    hold off 
	view([45 12]);
	
	
    drawnow()
    
    hold off
	
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