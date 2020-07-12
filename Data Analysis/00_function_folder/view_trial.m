function debug = view_trial(task, subject, hORs, lORr, ntrial)
%view_trial plots and animates all relevant steps of our process to analyze
% a single trial specified by task, healthy or stroke subject, left or
% right side trial.
%	In order this function generates:
%	0. Brief description of the chosen task and some info on the subject.
%	1. Animation of the recorded given trial
%	2. Animation of the 10Rarm doing that task, Plot errors???
%	3. Animation of the warped task done by the 10Rarm, plot joint angles
%	before and after
%	4. Animation of the prime componenti analisi cose belle
%
%	How to use:
%	view_trial(task, subject, hORs, lORr, trial)
%	task:			1-30
%	subject:		1-5 for healthy, 1-19 for stroke
%	hORs:			'h' for healthy, 's' stroke subject
%	lORR:			'l' left or 'r' right side
%	ntrial:			1-3 trial number

%% TO DO LIST

% animation of chosen trial
% animation of 10R robot

% capire che fare dopo


%% 0. Brief description of the chosen task and some info on the subject & load data
% check if input is correct
check_input(task, subject, hORs, lORr, ntrial)

% info on task
info_task(task)

% load
disp('Loading structs.mat...')
oldfolder = cd;
cd ../
cd 99_folder_mat
load('healthy_task.mat');
load('strokes_task.mat');
load('q_task.mat');
% load q warped
cd(oldfolder);
clear oldfolder;

% check if trial exist
trial = check_trial(task, subject, hORs, lORr, ntrial, strokes_task, healthy_task);

% info on subject and trial
info_subj_trial(trial)

%% 1. Animation of the recorded given trial
disp('Press any key to watch the animation of the recorded given trial.')
disp('Only relevant points and reference system are drawn,')
pause

animate_trial(trial, 10)
debug = trial;

%% 2.  Animation of the 10Rarm doing that task

end


%% Functions 0.
%check_input---------------------------------------------------------------
function check_input(task, subject, hORs, lORr, ntrial)
%task
if not(isa(task, 'double'))
	error('task number must be an integer number between 1-30')
else
	if task < 1 || task > 30 || (floor(task)-task ~= 0 )
		error('task number must be an integer number between 1-30')
	end
end
%hORs
if not(isa(hORs, 'char')) || norm(size(hORs)) ~= norm([1 1])
	error('hORs must be a char, either ''h'' or ''s'' ')
else
	if hORs == 'h'
	elseif hORs == 's'
	else
		error('hORs must be a char, either ''h'' or ''s'' ')
	end
end

%subject
if not(isa(subject, 'double'))
	error('subject number must be an integer number')
elseif  hORs == 'h' && (subject < 1 || subject > 5 || (floor(subject)-subject ~= 0 ) )
	error('healthy subject number must be an integer number between 1-5')
elseif hORs == 's' && (subject < 1 || subject > 19 || (floor(subject)-subject ~= 0 ) )
	error('stroke subject number must be an integer number between 1-19')

end

%lORr
if not(isa(lORr, 'char')) || norm(size(lORr)) ~= norm([1 1])
	error('lORr must be a char, either ''l'' or ''r'' ')
else
	if lORr == 'l'
	elseif lORr == 'r'
	else
		error('lORr must be a char, either ''l'' or ''r'' ')
	end
end

%ntrial
if not(isa(ntrial, 'double'))
	error('ntrial number must be an integer number between 1-3')
else
	if ntrial < 1 || ntrial > 3 || (floor(ntrial)-ntrial ~= 0 )
		error('ntrial number must be an integer number between 1-3')
	end
end

str_trial = ['Task ' num2str(task) ' executed by ' hORs '-subject ' ...
				num2str(subject) ' with ' lORr '-arm on the ' ...
				num2str(ntrial) ' trial'];
			
disp(str_trial)

end

%info_task-----------------------------------------------------------------
function info_task(task)
switch task
    case 1
        task_str = ['Ok gesture'];
	case 2
		task_str = ['Thumb down gesture'];
	case 3
		task_str = ['Exultation gesture'];
	case 4
		task_str = ['Hitchhiking'];
	case 5
		task_str = ['Block out sun from own face'];
	case 6
		task_str = ['Greet'];
	case 7
		task_str = ['Military salute'];
	case 8
		task_str = ['stop gesture'];
	case 9
		task_str = ['Pointing of somenthing straight ahead'];
	case 10
		task_str = ['Silence gesture'];
	case 11
		task_str = ['Reach and grasp a small suitcase from the handle, lift it and place it on the floor (close to the chair)'];
	case 12
		task_str = ['Reach and grasp a glass. drink for 3 seconds and place it in the initial position'];
	case 13
		task_str = ['Reach and grasp a phone receiver, carry it to own ear for 3 seconds and place it in the initial postion'];
	case 14
		task_str = ['Reach and grasp a book, put in on the table and open it from right side to left side'];
	case 15
		task_str = ['Reach and grasp a small cup from the handle (2 fingers and thumb), drink for 3 seconds and place it in the initial position'];
	case 16
		task_str = ['Reach and grasp an apple, mimic biting and put it in the initial position'];
	case 17
		task_str = ['Reach and grasp a hat (placed on the right side of the table) from its top and place it on own head'];
	case 18
		task_str = ['Reach and grasp a cup from its top, lift it and put it on the left side of the table'];
	case 19
		task_str = [' Receive a tray from someone (straight ahead, with open hand) and put it in the middle of the table'];
	case 20
		task_str = ['Reach and grasp a key in a lock (vertical axis), extract it from the lock and put it on the left side of the table'];
	case 21
		task_str = ['Reach and grasp a bottle, pour water into a glass, and put the bottle in the initial position'];
	case 22
		task_str = ['Reach and grasp a tennis racket (placed along own frontal plane), and play a forehand (the subject is still seated)'];
	case 23
		task_str = ['Reach and grasp a toothbrush, brush teeth (horizontal axis, one time on left side one time on right side), and put the toothbrush inside a cylindrical holder (placed on the right side of the table)'];
	case 24 
		task_str = ['Reach and grasp a laptop and open the laptop (without changing its position) (4 fingers + thumb)'];
	case 25
		task_str = ['Reach and grasp a pen (placed on the right side of the table) and draw a vertical line on the table (from the top to the bottom)'];
	case 26
		task_str = ['Reach and grasp a pencil (placed along own frontal plane) (3 fingers + thumb) and put it inside a squared pencil holder (placed on the left side of the table)'];
	case 27
		task_str = ['Reach and grasp a tea bag in a cup (1 finger + thumb), remove it from the cup, and place it on the table on the right side of the table'];
	case 28
		task_str = ['Reach and grasp a doorknob (disk shape), turn it clockwise, and counterclockwise and open the door'];
	case 29
		task_str = ['Reach and grasp a tennis ball (with fingertips) and place it in a basket placed on the floor (close to own chair)'];
	case 30
		task_str = ['Reach and grasp a cap (2 fingers + thumb) of a bottle (held by left hand), unscrew it, and place it overhead on a shelf'];
end

disp(['Task number ' num2str(task) ' consists in: ' task_str])


% task description

% 1) Ok gesture
% 2) Thumb down gesture
% 3) Exultation gesture
% 4) Hitchhiking
% 5) Block out sun from own face
% 6) Greet
% 7) Military salute
% 8) Stop gesture
% 9) Pointing of somenthing straight ahed
% 10) Silence gesture
% 11) Reach and grasp a small suitcase from the handle, lift it and place
%		it on the floor (close to the chair)
% 12) Reach and grasp a glass. drink for 3 seconds and place it in the
%		initial position
% 13) Reach and grasp a phone receiver, carry it to own ear for 3 seconds
%		and place it in the initial postion
% 14) Reach and grasp a book, put in on the table and open it from right
%		side to left side
% 15) Reach and grasp a small cup from the handle (2 fingers and thumb),
%		drink for 3 seconds and place it in the initial position
% 16) Reach and grasp an apple, mimic biting and put it in the initial
%		position
% 17) Reach and grasp a hat (placed on the right side of the table) from 
%		its top and place it on own head
% 18) Reach and grasp a cup from its top, lift it and put it on the left side of the table
% 19) Receive a tray from someone (straight ahead, with open hand) and put it in the middle of the table
% 20) Reach and grasp a key in a lock (vertical axis), extract it from the lock and put it on the left side of the table
% 21) Reach and grasp a bottle, pour water into a glass, and put the bottle in the initial position
% 22) Reach and grasp a tennis racket (placed along own frontal plane), and play a forehand (the subject is still seated)
% 23) Reach and grasp a toothbrush, brush teeth (horizontal axis, one time on left side one time on right side), and put the
%		toothbrush inside a cylindrical holder (placed on the right side of the table)
% 24) Reach and grasp a laptop and open the laptop (without changing its position) (4 fingers + thumb)
% 25) Reach and grasp a pen (placed on the right side of the table) and draw a vertical line on the table (from the top to the
%		bottom)
% 26) Reach and grasp a pencil (placed along own frontal plane) (3 fingers + thumb) and put it inside a squared pencil
%		holder (placed on the left side of the table)
% 27) Reach and grasp a tea bag in a cup (1 finger + thumb), remove it from the cup, and place it on the table on the right
%		side of the table
% 28) Reach and grasp a doorknob (disk shape), turn it clockwise, and counterclockwise and open the door
% 29) Reach and grasp a tennis ball (with fingertips) and place it in a basket placed on the floor (close to own chair)
% 30) Reach and grasp a cap (2 fingers + thumb) of a bottle (held by left hand), unscrew it, and place it overhead on a shelf

end

%check_trial---------------------------------------------------------------
function trial = check_trial(task, subject, hORs, lORr, ntrial, strokes_task, healthy_task)
if hORs == 'h'
	if lORr == 'l'
		if isempty(healthy_task(task).subject(subject).left_side_trial(ntrial).L5)
			error([str_trial ' is empty']);
		else
			trial = healthy_task(task).subject(subject).left_side_trial(ntrial);
		end
	elseif lORr == 'r'
		if isempty(healthy_task(task).subject(subject).right_side_trial(ntrial).L5)
			error([str_trial ' is empty']);
		else
			trial = healthy_task(task).subject(subject).right_side_trial(ntrial);
		end
	end
elseif hORs == 's'
	if lORr == 'l'
		if isempty(strokes_task(task).subject(subject).left_side_trial(ntrial).L5)
			error([str_trial ' is empty']);
		else
			trial = strokes_task(task).subject(subject).left_side_trial(ntrial);
		end
	elseif lORr == 'r'
		if isempty(strokes_task(task).subject(subject).right_side_trial(ntrial).L5)
			error([str_trial ' is empty']);
		else
			trial = strokes_task(task).subject(subject).right_side_trial(ntrial);
		end
	end
	
end
disp('Trial found and loaded!')

end

%info_subj_trial-----------------------------------------------------------
function info_subj_trial(trial)
switch trial.stroke_side
	case -1
		stroke_side_str = ['a healthy subject'];
	case 0
		stroke_side_str = ['a subject who has impairment on the left arm'];
	case 1
		stroke_side_str = ['a subject who has impairment on the right arm'];
end
switch trial.task_side
	case 0
		task_side_str = [' left arm'];
	case 1
		task_side_str = [' right arm'];
end

switch trial.stroke_task
	case 0
		stroke_task_str = ['healthy'];
	case 1
		stroke_task_str = ['impaired'];
end

disp(['The trial is executed with' task_side_str ' (that is ' stroke_task_str ') by ' stroke_side_str])
 

end
%% Functions 1.
%animate_trial-------------------------------------------------------------
function animate_trial(trial, skipframe)
%% Constant definition
if nargin < 2
	skipframe = 2;			% how many frame it skips every update
end
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
	disp('stroke_side not found! Grey colour used instead')
	col_r = 'e';			% colour right arm
	col_r_in = 'e';			% colour inside right arm
	col_l = 'e';			% colour left arm
	col_l_in = 'e';			% colour left arm inside
	
end

% marker dimensions
dim_small	= 8;		% small marker dimension (shoulder, Neck.Pos, elbow)
dim_big		= 10;		% big marker dimension (hands, Head.Pos)

%% limits for plot
lim_gap = 0.2;
xmin = min([ ...
	min(trial.L5.Pos(:,1)), ...
	min(trial.Upperarm_R.Pos(:,1)),...
	min(trial.Upperarm_L.Pos(:,1)),...
	min(trial.Forearm_R.Pos(:,1)),...
	min(trial.Forearm_L.Pos(:,1)),...
	min(trial.Hand_R.Pos(:,1)),...
	min(trial.Hand_L.Pos(:,1)),...
	]) - lim_gap;
xmax = max([ ...
	max(trial.L5.Pos(:,1)), ...
	max(trial.Upperarm_R.Pos(:,1)),...
	max(trial.Upperarm_L.Pos(:,1)),...
	max(trial.Forearm_R.Pos(:,1)),...
	max(trial.Forearm_L.Pos(:,1)),...
	max(trial.Hand_R.Pos(:,1)),...
	max(trial.Hand_L.Pos(:,1)),...
	]) + lim_gap;
ymin = min([ ...
	min(trial.L5.Pos(:,2)), ...
	min(trial.Upperarm_R.Pos(:,2)),...
	min(trial.Upperarm_L.Pos(:,2)),...
	min(trial.Forearm_R.Pos(:,2)),...
	min(trial.Forearm_L.Pos(:,2)),...
	min(trial.Hand_R.Pos(:,2)),...
	min(trial.Hand_L.Pos(:,2)),...
	]) - lim_gap;
ymax = max([ ...
	max(trial.L5.Pos(:,2)), ...
	max(trial.Upperarm_R.Pos(:,2)),...
	max(trial.Upperarm_L.Pos(:,2)),...
	max(trial.Forearm_R.Pos(:,2)),...
	max(trial.Forearm_L.Pos(:,2)),...
	max(trial.Hand_R.Pos(:,2)),...
	max(trial.Hand_L.Pos(:,2)),...
	]) + lim_gap;
zmin = 0;
zmax = max([ ...
	max(trial.L5.Pos(:,3)), ...
	max(trial.Upperarm_R.Pos(:,3)),...
	max(trial.Upperarm_L.Pos(:,3)),...
	max(trial.Forearm_R.Pos(:,3)),...
	max(trial.Forearm_L.Pos(:,3)),...
	max(trial.Hand_R.Pos(:,3)),...
	max(trial.Hand_L.Pos(:,3)),...
	]) + lim_gap;

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
	
    xlim([xmin, xmax]);  ylim([ymin, ymax]); zlim([zmin, zmax]);
    hold off 
	if i == 1
		view([25 10]);
	end
	
    drawnow()
    
    hold off
	
end

end

%% Functions shared between sections
%draw_frame----------------------------------------------------------------
function draw_frame(pos, rot, d)
if nargin < 3
	d = 0.5;
end

x = pos(1);
y = pos(2);
z = pos(3);

qx = rot * [d; 0; 0];
qy = rot * [0; d; 0];
qz = rot * [0; 0; d];

quiver3(x,y,z,qx(1),qx(2),qx(3), 'r', 'ShowArrowHead', false)
quiver3(x,y,z,qy(1),qy(2),qy(3), 'g', 'ShowArrowHead', false)
quiver3(x,y,z,qz(1),qz(2),qz(3), 'b', 'ShowArrowHead', false)

end



