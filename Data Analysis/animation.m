function animation(task)
% animation
% example: animation(strokes_data.task1.subject1.right_side.trial1)
% this function runs the animation of the selected task, it requires
% strokes_data.mat or healthy_data.mat to run.

% NON SERVE DATO CHE PER LANCIARLO SERVE AVERE NEL WORKSPACE LA STRUCT
% ALTRIMENTI NON GLI PASSA NIENTE, COMODO PER ALTRE VOLTE PERO`
% if ~exist('healthy_data', 'var') || (exist('healthy_data', 'var') && ~isstruct(healthy_data) )
% 	clear healthy_data;
% 	load('healthy_data.mat');
% elseif  ~exist('strokes_data', 'var') || (exist('strokes_data', 'var') && ~isstruct(strokes_data) )
% 	clear strokes_data;
% 	load('strokes_data.mat');
% end

%% Constant definition
animate = task;		% stores into a local variable the selected task structure
skiframe = 2;		% how many frame it skips every update
nSamples = size(animate.Head.Pos,1);

% colours
col_Head.Pos = 'ko';	% colour Head.Pos, Neck.Pos and Pelvis.Pos
col_Head.Pos_in = 'k';	% colour inside of the Head.Pos and Neck.Pos
col_h = 'go';		% colour healthy arm
col_h_in = 'g';		% colour inside healthy arm
col_s = 'ro';		% colour stroke arm
col_s_in = 'r';		% colour stroke arm inside
col_segm = 'k-';	% colour segment

% check if right / left arm is healthy or not
% upper limb with strokes 0-->Left 1--> Right, -1-->Both arm healthy
if task.stroke_side == -1
	col_r = col_h;			% colour right arm
	col_r_in = col_h_in;	% colour inside right arm
	col_l = col_h;			% colour left arm
	col_l_in = col_h_in;	% colour left arm inside
elseif task.stroke_side == 0
	col_r = col_h;			% colour right arm
	col_r_in = col_h_in;	% colour inside right arm
	col_l = col_s;			% colour stroke - left arm 
	col_l_in = col_s_in;	% colour inside stroke - left arm 
elseif task.stroke_side == 1
	col_r = col_s;			% colour stroke - right arm
	col_r_in = col_s_in;	% colour inside stroke - right arm
	col_l = col_h;			% colour left arm
	col_l_in = col_h_in;	% colour left arm inside
else
	disp('stroke_side not found! Grey colour used instead')
	col_r = 'e';			% colour right arm
	col_r_in = 'e';			% colour inside right arm
	col_l = 'e';			% colour left arm
	col_l_in = 'e';			% colour left arm inside
	
end

% marker dimensions
dim_small = 10;		% small marker dimension (shoulder, Neck.Pos, elbow)
dim_big = 15;		% big marker dimension (hands, Head.Pos)

%% limits for plot
lim_gap = 0.2;
xmin = min([ ...
	min(animate.Head.Pos(:,1)), ...
	min(animate.Neck.Pos(:,1)),...
	min(animate.Shoulder_R.Pos(:,1)),...
	min(animate.Shoulder_L.Pos(:,1)),...
	min(animate.Upperarm_R.Pos(:,1)),...
	min(animate.Upperarm_L.Pos(:,1)),...
	min(animate.Forearm_R.Pos(:,1)),...
	min(animate.Forearm_L.Pos(:,1)),...
	min(animate.Hand_R.Pos(:,1)),...
	min(animate.Hand_L.Pos(:,1)),...
	]) - lim_gap;
xmax = max([ ...
	max(animate.Head.Pos(:,1)), ...
	max(animate.Neck.Pos(:,1)),...
	max(animate.Shoulder_R.Pos(:,1)),...
	max(animate.Shoulder_L.Pos(:,1)),...
	max(animate.Upperarm_R.Pos(:,1)),...
	max(animate.Upperarm_L.Pos(:,1)),...
	max(animate.Forearm_R.Pos(:,1)),...
	max(animate.Forearm_L.Pos(:,1)),...
	max(animate.Hand_R.Pos(:,1)),...
	max(animate.Hand_L.Pos(:,1)),...
	]) + lim_gap;
ymin = min([ ...
	min(animate.Head.Pos(:,2)), ...
	min(animate.Neck.Pos(:,2)),...
	min(animate.Shoulder_R.Pos(:,2)),...
	min(animate.Shoulder_L.Pos(:,2)),...
	min(animate.Upperarm_R.Pos(:,2)),...
	min(animate.Upperarm_L.Pos(:,2)),...
	min(animate.Forearm_R.Pos(:,2)),...
	min(animate.Forearm_L.Pos(:,2)),...
	min(animate.Hand_R.Pos(:,2)),...
	min(animate.Hand_L.Pos(:,2)),...
	]) - lim_gap;
ymax = max([ ...
	max(animate.Head.Pos(:,2)), ...
	max(animate.Neck.Pos(:,2)),...
	max(animate.Shoulder_R.Pos(:,2)),...
	max(animate.Shoulder_L.Pos(:,2)),...
	max(animate.Upperarm_R.Pos(:,2)),...
	max(animate.Upperarm_L.Pos(:,2)),...
	max(animate.Forearm_R.Pos(:,2)),...
	max(animate.Forearm_L.Pos(:,2)),...
	max(animate.Hand_R.Pos(:,2)),...
	max(animate.Hand_L.Pos(:,2)),...
	]) + lim_gap;
zmin = 0;
zmax = max([ ...
	max(animate.Head.Pos(:,3)), ...
	max(animate.Neck.Pos(:,3)),...
	max(animate.Shoulder_R.Pos(:,3)),...
	max(animate.Shoulder_L.Pos(:,3)),...
	max(animate.Upperarm_R.Pos(:,3)),...
	max(animate.Upperarm_L.Pos(:,3)),...
	max(animate.Forearm_R.Pos(:,3)),...
	max(animate.Forearm_L.Pos(:,3)),...
	max(animate.Hand_R.Pos(:,3)),...
	max(animate.Hand_L.Pos(:,3)),...
	]) + lim_gap;

%% Animation
for i=1:skiframe:(nSamples)
%     %% Pelvis
% 	plot3(animate.Pelvis.Pos(i,1),...
%         animate.Pelvis.Pos(i,2),...
%         animate.Pelvis.Pos(i,3),...
%         col_Head.Pos,'MarkerSize', dim_big,'MarkerFaceColor',col_Head.Pos_in)
%     grid on
%     hold on
% 	
% 	% Pelvis - T12
%     plot3([animate.Pelvis.Pos(i,1); animate.T12.Pos(i,1)],...
%         [animate.Pelvis.Pos(i,2); animate.T12.Pos(i,2)],...
%         [animate.Pelvis.Pos(i,3); animate.T12.Pos(i,3)],...
%          col_segm)
	 
	%% T12
	plot3(animate.T12.Pos(i,1),...
        animate.T12.Pos(i,2),...
        animate.T12.Pos(i,3),...
        col_Head.Pos,'MarkerSize', dim_big,'MarkerFaceColor',col_Head.Pos_in)
    grid on
    hold on
	
	% T12 - T8
    plot3([animate.T8.Pos(i,1); animate.T12.Pos(i,1)],...
        [animate.T8.Pos(i,2); animate.T12.Pos(i,2)],...
        [animate.T8.Pos(i,3); animate.T12.Pos(i,3)],...
         col_segm)
	 
	 %% T8
	plot3(animate.T8.Pos(i,1),...
        animate.T8.Pos(i,2),...
        animate.T8.Pos(i,3),...
        col_Head.Pos,'MarkerSize', dim_small,'MarkerFaceColor',col_Head.Pos_in)
    grid on
    hold on
	
	% T8 - Neck
    plot3([animate.Neck.Pos(i,1); animate.T8.Pos(i,1)],...
        [animate.Neck.Pos(i,2); animate.T8.Pos(i,2)],...
        [animate.Neck.Pos(i,3); animate.T8.Pos(i,3)],...
         col_segm)
	
	
	%% Head.Pos
	plot3(animate.Head.Pos(i,1),...
        animate.Head.Pos(i,2),...
        animate.Head.Pos(i,3),...
        col_Head.Pos,'MarkerSize', dim_big,'MarkerFaceColor',col_Head.Pos_in)
    
    % Head.Pos - Neck.Pos
    plot3([animate.Head.Pos(i,1); animate.Neck.Pos(i,1)],...
        [animate.Head.Pos(i,2); animate.Neck.Pos(i,2)],...
        [animate.Head.Pos(i,3); animate.Neck.Pos(i,3)],...
         col_segm)
    
    % Neck.Pos
    plot3(animate.Neck.Pos(i,1),...
        animate.Neck.Pos(i,2),...
        animate.Neck.Pos(i,3),...
        col_Head.Pos,'MarkerSize', dim_small,'MarkerFaceColor',col_Head.Pos_in)
    
	%% right arm
    % Neck.Pos - right shoulder
    plot3([animate.Neck.Pos(i,1); animate.Shoulder_R.Pos(i,1)],...
        [animate.Neck.Pos(i,2); animate.Shoulder_R.Pos(i,2)],...
        [animate.Neck.Pos(i,3); animate.Shoulder_R.Pos(i,3)],...
         col_segm)
    
    % right shoulder
    plot3(animate.Shoulder_R.Pos(i,1),...
        animate.Shoulder_R.Pos(i,2),...
        animate.Shoulder_R.Pos(i,3),...
         col_r,'MarkerSize', dim_small,'MarkerFaceColor', col_r_in)
    
    % right shoulder - right upper arm
     plot3([animate.Shoulder_R.Pos(i,1); animate.Upperarm_R.Pos(i,1)],...
        [animate.Shoulder_R.Pos(i,2); animate.Upperarm_R.Pos(i,2)],...
        [animate.Shoulder_R.Pos(i,3); animate.Upperarm_R.Pos(i,3)],...
         col_segm)
    
    % right upper arm
    plot3(animate.Upperarm_R.Pos(i,1),...
        animate.Upperarm_R.Pos(i,2),...
        animate.Upperarm_R.Pos(i,3),...
         col_r,'MarkerSize', dim_small,'MarkerFaceColor', col_r_in)
    
    % right upper arm - right forearm
    plot3([animate.Upperarm_R.Pos(i,1); animate.Forearm_R.Pos(i,1)],...
        [animate.Upperarm_R.Pos(i,2); animate.Forearm_R.Pos(i,2)],...
        [animate.Upperarm_R.Pos(i,3); animate.Forearm_R.Pos(i,3)],...
         col_segm)
	 
    % right forearm
    plot3(animate.Forearm_R.Pos(i,1),...
        animate.Forearm_R.Pos(i,2),...
        animate.Forearm_R.Pos(i,3),...
         col_r,'MarkerSize', dim_small,'MarkerFaceColor', col_r_in)
    
    % right forearm - right hand
	plot3([animate.Forearm_R.Pos(i,1); animate.Hand_R.Pos(i,1)],...
        [animate.Forearm_R.Pos(i,2); animate.Hand_R.Pos(i,2)],...
        [animate.Forearm_R.Pos(i,3); animate.Hand_R.Pos(i,3)],...
         col_segm)
	
    % right hand
    plot3(animate.Hand_R.Pos(i,1),...
        animate.Hand_R.Pos(i,2),...
        animate.Hand_R.Pos(i,3),...
         col_r,'MarkerSize', dim_big,'MarkerFaceColor', col_r_in)

	%% braccio sinistro
	% Neck.Pos - left shoulder
    plot3([animate.Neck.Pos(i,1); animate.Shoulder_L.Pos(i,1)],...
        [animate.Neck.Pos(i,2); animate.Shoulder_L.Pos(i,2)],...
        [animate.Neck.Pos(i,3); animate.Shoulder_L.Pos(i,3)],...
         col_segm)
    
    % left shoulder
    plot3(animate.Shoulder_L.Pos(i,1),...
        animate.Shoulder_L.Pos(i,2),...
        animate.Shoulder_L.Pos(i,3),...
         col_l,'MarkerSize', dim_small,'MarkerFaceColor', col_l_in)
    
    % left shoulder - left upper arm
     plot3([animate.Shoulder_L.Pos(i,1); animate.Upperarm_L.Pos(i,1)],...
        [animate.Shoulder_L.Pos(i,2); animate.Upperarm_L.Pos(i,2)],...
        [animate.Shoulder_L.Pos(i,3); animate.Upperarm_L.Pos(i,3)],...
         col_segm)
    
    % left upper arm
    plot3(animate.Upperarm_L.Pos(i,1),...
        animate.Upperarm_L.Pos(i,2),...
        animate.Upperarm_L.Pos(i,3),...
         col_l,'MarkerSize', dim_small,'MarkerFaceColor', col_l_in)
    
    % left upper arm - left forearm
    plot3([animate.Upperarm_L.Pos(i,1); animate.Forearm_L.Pos(i,1)],...
        [animate.Upperarm_L.Pos(i,2); animate.Forearm_L.Pos(i,2)],...
        [animate.Upperarm_L.Pos(i,3); animate.Forearm_L.Pos(i,3)],...
         col_segm)
	 
    % left forearm
    plot3(animate.Forearm_L.Pos(i,1),...
        animate.Forearm_L.Pos(i,2),...
        animate.Forearm_L.Pos(i,3),...
         col_l,'MarkerSize', dim_small,'MarkerFaceColor', col_l_in)
    
    % left forearm - left hand
	plot3([animate.Forearm_L.Pos(i,1); animate.Hand_L.Pos(i,1)],...
        [animate.Forearm_L.Pos(i,2); animate.Hand_L.Pos(i,2)],...
        [animate.Forearm_L.Pos(i,3); animate.Hand_L.Pos(i,3)],...
         col_segm)
	
    % left hand
    plot3(animate.Hand_L.Pos(i,1),...
        animate.Hand_L.Pos(i,2),...
        animate.Hand_L.Pos(i,3),...
         col_l,'MarkerSize', dim_big,'MarkerFaceColor', col_l_in)

    %% option plot
    xlabel('x');    ylabel('y');    zlabel('z');
    axis equal
	
    xlim([xmin, xmax]);  ylim([ymin, ymax]); zlim([zmin, zmax]);
    hold off 
	%view([25 10 45])
    drawnow()
    
    hold off
	
end



