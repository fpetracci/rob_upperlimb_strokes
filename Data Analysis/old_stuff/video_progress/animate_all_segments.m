function animate_all_segments(file_mvnx, nfig, movie_mode, movie_title)

%% parse inputs
if nargin < 3
	movie_mode = 1;
end

if nargin < 4
	movie_title = 'movie_hand';
end

%% import

data = struct_export(file_mvnx);

%% figure stuff
nSamples = size(data.L5.Pos,1);

% limits for plot
lims = plot_lims(data, 0.2, 1);

% movie parameters
k = 1;				% init of movie's frames counter
movie_fps = 20;		% movie frame per second

%% iteration
figh = figure(nfig);
for i = 1:nSamples
	
	plot_update(i, data)
	
	% end stuff
	xlabel('x [m]');    ylabel('y [m]');    zlabel('z [m]');
    axis equal
	title([' Recorded trial animation (frame: ' num2str(i) ' of ' num2str(nSamples) ')'])
	
    xlim([lims(1), lims(2)]);  ylim([lims(3), lims(4)]); zlim([lims(5), lims(6)]);
	%view([-135 12])
	view([45 12])
	hold off
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = struct_export(struct_mvnx)
%struct_export loads all the segments positions from the file .mvnx specified.
% filename should be a char with the file path of the chosen .mvnx file.
% Example: data = struct_DataLoad('folder\P19_T07_L3.mvnx')

%Any file contains data about a single task, a single subject and a single
%trial.


%% In this part is checked which row the data start at

nSamples_plus = length(struct_mvnx.subject.frames.frame);
i = 1;
while isempty(struct_mvnx.subject.frames.frame(i).index)
	skip = i; %number of lines not to be considered since data listed in temporal values ??is not provided
	i = i+1;
end

nSamples = nSamples_plus - skip; % number of sample with temporal values

%% Import files outside tree struct

data = struct; %struct definition
%% Position and quaternions
%Pelvis
segment = 1;
data.Pelvis.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Pelvis.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%L5
segment = 2;
data.L5.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.L5.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%L3
segment = 3;
data.L3.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.L3.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%T12
segment = 4;
data.T12.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.T12.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%T8
segment = 5;
data.T8.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.T8.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Neck
segment = 6;
data.Neck.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Neck.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Head
segment = 7;
data.Head.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Head.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Right Shoulder
segment = 8;
data.Shoulder_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Shoulder_R.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end


%Right Upperarm
segment = 9;
data.Upperarm_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i= 1:nSamples
		data.Upperarm_R.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Right Forearm
segment = 10;
data.Forearm_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Forearm_R.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end


%Right Hand
segment = 11;
data.Hand_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Hand_R.Pos(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Left Shoulder
segment = 12;
data.Shoulder_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Shoulder_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Left Upperarm
segment = 13;
data.Upperarm_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Upperarm_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Left Forearm
segment = 14;
data.Forearm_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Forearm_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Left Hand
segment = 15;
data.Hand_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Hand_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Right Upperleg
segment = 16;
data.Upperleg_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Upperleg_R.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Right Lowerleg
segment = 17;
data.Lowerleg_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Lowerleg_R.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Right Foot
segment = 18;
data.Foot_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Foot_R.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Right Toe
segment = 19;
data.Toe_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Toe_R.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Left Upperleg
segment = 20;
data.Upperleg_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Upperleg_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Left Lowerleg
segment = 21;
data.Lowerleg_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Lowerleg_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Left Foot
segment = 22;
data.Foot_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Foot_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

%Left Toe
segment = 23;
data.Toe_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Toe_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end



end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_update(i, data)
	
	%% colours
	colbig.Pos = 'ko';	% colour Head.Pos, Neck.Pos and Pelvis.Pos
	colbig.Pos_in = 'k';	% colour inside of the Head.Pos and Neck.Pos
	
	col_segm = 'k-';	% colour segment
	
	col_r = 'co';		% colour right arm
	col_r_in = 'c';		% colour inside right arm
	col_l = 'co';		% colour left arm
	col_l_in = 'c';		% colour left arm inside
	
	dim_small	= 8;		% small marker dimension (shoulder, Neck.Pos, elbow)
	dim_big		= 10;		% big marker dimension (hands, Head.Pos)

	%% Pelvis
	plot3(data.Pelvis.Pos(i,1),...
        data.Pelvis.Pos(i,2),...
        data.Pelvis.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_big,'MarkerFaceColor',colbig.Pos_in)
	%plot1.Color(4) = 0.2;
    grid on
    hold on
	
	%pelvis - L5
	plot3([data.L5.Pos(i,1); data.Pelvis.Pos(i,1)],...
        [data.L5.Pos(i,2); data.Pelvis.Pos(i,2)],...
        [data.L5.Pos(i,3); data.Pelvis.Pos(i,3)],...
         col_segm)
	 
	% pelvis-upperleg_R
	plot3([data.Upperleg_R.Pos(i,1); data.Pelvis.Pos(i,1)],...
        [data.Upperleg_R.Pos(i,2); data.Pelvis.Pos(i,2)],...
        [data.Upperleg_R.Pos(i,3); data.Pelvis.Pos(i,3)],...
         col_segm)
	 
	% pelvis-upperleg_L
	plot3([data.Upperleg_L.Pos(i,1); data.Pelvis.Pos(i,1)],...
        [data.Upperleg_L.Pos(i,2); data.Pelvis.Pos(i,2)],...
        [data.Upperleg_L.Pos(i,3); data.Pelvis.Pos(i,3)],...
         col_segm)
	 
	%% Torso
	
	% L5
	plot3(data.L5.Pos(i,1),...
        data.L5.Pos(i,2),...
        data.L5.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	%plot1.Color(4) = 0.2;
	
	% L5 - L3
	plot3([data.L5.Pos(i,1); data.L3.Pos(i,1)],...
        [data.L5.Pos(i,2); data.L3.Pos(i,2)],...
        [data.L5.Pos(i,3); data.L3.Pos(i,3)],...
         col_segm)
	% L3
	plot3(data.L3.Pos(i,1),...
        data.L3.Pos(i,2),...
        data.L3.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	 
	 % L3 - T12
	plot3([data.T12.Pos(i,1); data.L3.Pos(i,1)],...
        [data.T12.Pos(i,2); data.L3.Pos(i,2)],...
        [data.T12.Pos(i,3); data.L3.Pos(i,3)],...
         col_segm)
	
	% T12
	plot3(data.T12.Pos(i,1),...
        data.T12.Pos(i,2),...
        data.T12.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	 
	% T12 - T8
	plot3([data.T12.Pos(i,1); data.T8.Pos(i,1)],...
        [data.T12.Pos(i,2); data.T8.Pos(i,2)],...
        [data.T12.Pos(i,3); data.T8.Pos(i,3)],...
         col_segm)

	% T8
	plot3(data.T8.Pos(i,1),...
        data.T8.Pos(i,2),...
        data.T8.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	 
	% T8 - Neck
	plot3([data.T8.Pos(i,1); data.Neck.Pos(i,1)],...
        [data.T8.Pos(i,2); data.Neck.Pos(i,2)],...
        [data.T8.Pos(i,3); data.Neck.Pos(i,3)],...
         col_segm)
	 
	% T8 - Shoulder_R
	plot3([data.T8.Pos(i,1); data.Shoulder_R.Pos(i,1)],...
        [data.T8.Pos(i,2); data.Shoulder_R.Pos(i,2)],...
        [data.T8.Pos(i,3); data.Shoulder_R.Pos(i,3)],...
         col_segm)
	
	% T8 - Shoulder_L
	plot3([data.T8.Pos(i,1); data.Shoulder_L.Pos(i,1)],...
        [data.T8.Pos(i,2); data.Shoulder_L.Pos(i,2)],...
        [data.T8.Pos(i,3); data.Shoulder_L.Pos(i,3)],...
         col_segm)
	 
	 %% neck and head
	 % Neck
	plot3(data.Neck.Pos(i,1),...
        data.Neck.Pos(i,2),...
        data.Neck.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	 
	% Neck - Head
	plot3([data.Head.Pos(i,1); data.Neck.Pos(i,1)],...
        [data.Head.Pos(i,2); data.Neck.Pos(i,2)],...
        [data.Head.Pos(i,3); data.Neck.Pos(i,3)],...
         col_segm)
	
	% Head
	plot3(data.Head.Pos(i,1),...
        data.Head.Pos(i,2),...
        data.Head.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_big, 'MarkerFaceColor',colbig.Pos_in)
	 
	%% right arm 
	
	% right shoulder
    plot3(data.Shoulder_R.Pos(i,1),...
        data.Shoulder_R.Pos(i,2),...
        data.Shoulder_R.Pos(i,3),...
         col_r,'MarkerSize', dim_small,'MarkerFaceColor', col_r_in)
    
    % right shoulder - right upper arm
    plot3([data.Upperarm_R.Pos(i,1); data.Shoulder_R.Pos(i,1)],...
        [data.Upperarm_R.Pos(i,2); data.Shoulder_R.Pos(i,2)],...
        [data.Upperarm_R.Pos(i,3); data.Shoulder_R.Pos(i,3)],...
         col_segm)
   
    % right upper arm
    plot3(data.Upperarm_R.Pos(i,1),...
        data.Upperarm_R.Pos(i,2),...
        data.Upperarm_R.Pos(i,3),...
         col_r,'MarkerSize', dim_small,'MarkerFaceColor', col_r_in)
    
    % right upper arm - right forearm
    plot3([data.Upperarm_R.Pos(i,1); data.Forearm_R.Pos(i,1)],...
        [data.Upperarm_R.Pos(i,2); data.Forearm_R.Pos(i,2)],...
        [data.Upperarm_R.Pos(i,3); data.Forearm_R.Pos(i,3)],...
         col_segm)
	 
    % right forearm
    plot3(data.Forearm_R.Pos(i,1),...
        data.Forearm_R.Pos(i,2),...
        data.Forearm_R.Pos(i,3),...
         col_r,'MarkerSize', dim_small,'MarkerFaceColor', col_r_in)
    
    % right forearm - right hand
	plot3([data.Forearm_R.Pos(i,1); data.Hand_R.Pos(i,1)],...
        [data.Forearm_R.Pos(i,2); data.Hand_R.Pos(i,2)],...
        [data.Forearm_R.Pos(i,3); data.Hand_R.Pos(i,3)],...
         col_segm)
	
    % right hand
    plot3(data.Hand_R.Pos(i,1),...
        data.Hand_R.Pos(i,2),...
        data.Hand_R.Pos(i,3),...
         col_r,'MarkerSize', dim_big,'MarkerFaceColor', col_r_in)

	%% left arm
	% left shoulder
    plot3(data.Shoulder_L.Pos(i,1),...
        data.Shoulder_L.Pos(i,2),...
        data.Shoulder_L.Pos(i,3),...
         col_r,'MarkerSize', dim_small,'MarkerFaceColor', col_r_in)
    
    % left shoulder - left upper arm
    plot3([data.Upperarm_L.Pos(i,1); data.Shoulder_L.Pos(i,1)],...
        [data.Upperarm_L.Pos(i,2); data.Shoulder_L.Pos(i,2)],...
        [data.Upperarm_L.Pos(i,3); data.Shoulder_L.Pos(i,3)],...
         col_segm)
	 
    % left upper arm
    plot3(data.Upperarm_L.Pos(i,1),...
        data.Upperarm_L.Pos(i,2),...
        data.Upperarm_L.Pos(i,3),...
         col_l,'MarkerSize', dim_small,'MarkerFaceColor', col_l_in)
    
    % left upper arm - left forearm
    plot3([data.Upperarm_L.Pos(i,1); data.Forearm_L.Pos(i,1)],...
        [data.Upperarm_L.Pos(i,2); data.Forearm_L.Pos(i,2)],...
        [data.Upperarm_L.Pos(i,3); data.Forearm_L.Pos(i,3)],...
         col_segm)
	 
    % left forearm
    plot3(data.Forearm_L.Pos(i,1),...
        data.Forearm_L.Pos(i,2),...
        data.Forearm_L.Pos(i,3),...
         col_l,'MarkerSize', dim_small,'MarkerFaceColor', col_l_in)
    
    % left forearm - left hand
	plot3([data.Forearm_L.Pos(i,1); data.Hand_L.Pos(i,1)],...
        [data.Forearm_L.Pos(i,2); data.Hand_L.Pos(i,2)],...
        [data.Forearm_L.Pos(i,3); data.Hand_L.Pos(i,3)],...
         col_segm)
	
    % left hand
    plot3(data.Hand_L.Pos(i,1),...
        data.Hand_L.Pos(i,2),...
        data.Hand_L.Pos(i,3),...
         col_l,'MarkerSize', dim_big,'MarkerFaceColor', col_l_in)

	%% right leg

	% Upper leg
	plot3(data.Upperleg_R.Pos(i,1),...
        data.Upperleg_R.Pos(i,2),...
        data.Upperleg_R.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	
	% Upper leg - Lowerleg 
	plot3([data.Upperleg_R.Pos(i,1); data.Lowerleg_R.Pos(i,1)],...
        [data.Upperleg_R.Pos(i,2); data.Lowerleg_R.Pos(i,2)],...
        [data.Upperleg_R.Pos(i,3); data.Lowerleg_R.Pos(i,3)],...
         col_segm)
	 
	% Lower leg
	plot3(data.Lowerleg_R.Pos(i,1),...
        data.Lowerleg_R.Pos(i,2),...
        data.Lowerleg_R.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)

	% Lowerleg - Foot
	plot3([data.Lowerleg_R.Pos(i,1); data.Foot_R.Pos(i,1)],...
        [data.Lowerleg_R.Pos(i,2); data.Foot_R.Pos(i,2)],...
        [data.Lowerleg_R.Pos(i,3); data.Foot_R.Pos(i,3)],...
         col_segm)
	
	% Foot
	plot3(data.Foot_R.Pos(i,1),...
        data.Foot_R.Pos(i,2),...
        data.Foot_R.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	
	% Foot - Toe
	plot3([data.Foot_R.Pos(i,1); data.Toe_R.Pos(i,1)],...
        [data.Foot_R.Pos(i,2); data.Toe_R.Pos(i,2)],...
        [data.Foot_R.Pos(i,3); data.Toe_R.Pos(i,3)],...
         col_segm)
	
	% toe
	plot3(data.Toe_R.Pos(i,1),...
        data.Toe_R.Pos(i,2),...
        data.Toe_R.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	 
	%% left leg

	% Upper leg
	plot3(data.Upperleg_L.Pos(i,1),...
        data.Upperleg_L.Pos(i,2),...
        data.Upperleg_L.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	
	% Upper leg - Lowerleg 
	plot3([data.Upperleg_L.Pos(i,1); data.Lowerleg_L.Pos(i,1)],...
        [data.Upperleg_L.Pos(i,2); data.Lowerleg_L.Pos(i,2)],...
        [data.Upperleg_L.Pos(i,3); data.Lowerleg_L.Pos(i,3)],...
         col_segm)
	 
	% Lower leg
	plot3(data.Lowerleg_L.Pos(i,1),...
        data.Lowerleg_L.Pos(i,2),...
        data.Lowerleg_L.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)

	% Lowerleg - Foot
	plot3([data.Lowerleg_L.Pos(i,1); data.Foot_L.Pos(i,1)],...
        [data.Lowerleg_L.Pos(i,2); data.Foot_L.Pos(i,2)],...
        [data.Lowerleg_L.Pos(i,3); data.Foot_L.Pos(i,3)],...
         col_segm)
	
	% Foot
	plot3(data.Foot_L.Pos(i,1),...
        data.Foot_L.Pos(i,2),...
        data.Foot_L.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	
	% Foot - Toe
	plot3([data.Foot_L.Pos(i,1); data.Toe_L.Pos(i,1)],...
        [data.Foot_L.Pos(i,2); data.Toe_L.Pos(i,2)],...
        [data.Foot_L.Pos(i,3); data.Toe_L.Pos(i,3)],...
         col_segm)
	
	% toe
	plot3(data.Toe_L.Pos(i,1),...
        data.Toe_L.Pos(i,2),...
        data.Toe_L.Pos(i,3),...
        colbig.Pos,'MarkerSize', dim_small,'MarkerFaceColor',colbig.Pos_in)
	 

end
