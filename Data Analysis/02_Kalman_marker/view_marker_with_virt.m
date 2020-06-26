function view_marker_with_virt(trial)
clf
% %% DA ELIMINARE, SOLO PER TEST
% % folder
% oldfolder = cd;
% cd ../
% cd 99_folder_mat
% load('healthy_task.mat');
% load('strokes_task.mat');
% cd(oldfolder);
% clear oldfolder;
% trial = healthy_task(7).subject(1).left_side_trial(1);

%% build marker
arms = create_arms(trial);
par = par_10R(trial);

% general time initialization
nsamples = size(trial.Hand_L.Quat,1); % number of time step in the chosen trial

% left side
Rs210_l = rotx(-pi/2);
Rs28_l = roty(-pi/2);
Rs26_l = rotx(+pi);
Rs23_l = rotx(pi/2 - par.theta_shoulder.left)*rotz(pi/2);

% right side
Rs210_r = rotx(pi/2);
Rs28_r = roty(pi/2)*rotz(pi);
Rs26_r = eye(3); 
Rs23_r = rotx(pi/2 + par.theta_shoulder.right)*rotz(pi/2); 

% distance between center of frame and virtual marker on x and y axis.
d_trasl = 0.5;

% preallocating for speed efficiency
rot_wrist_meas		= zeros(3,3,nsamples);
rot_elbow_meas		= zeros(3,3,nsamples);
rot_shoulder_meas	= zeros(3,3,nsamples);
rot_L5_meas			= zeros(3,3,nsamples);
T_wrist				= zeros(4,4,nsamples);
T_wrist_x			= zeros(4,4,nsamples);
T_wrist_y			= zeros(4,4,nsamples);
T_elbow				= zeros(4,4,nsamples);
T_elbow_x			= zeros(4,4,nsamples);
T_elbow_y			= zeros(4,4,nsamples);
T_shoulder			= zeros(4,4,nsamples);
T_shoulder_x		= zeros(4,4,nsamples);
T_shoulder_y		= zeros(4,4,nsamples);
T_L5				= zeros(4,4,nsamples);
T_L5_x				= zeros(4,4,nsamples);
T_L5_y				= zeros(4,4,nsamples);



if trial.task_side == 0 % left side
	
	% quat fix sign ????
	L5_rotm = quat2rotm(trial.L5.Quat);
	L5_quat = rotm2quat(L5_rotm);
	
	%right
	hand_rotm = quat2rotm(trial.Hand_L.Quat);
	hand_quat = rotm2quat(hand_rotm);

	fore_rotm = quat2rotm(trial.Forearm_L.Quat);
	fore_quat = rotm2quat(fore_rotm);

	uppe_rotm = quat2rotm(trial.Upperarm_L.Quat);
	uppe_quat = rotm2quat(uppe_rotm);

	arm = arms.left;
	% rotation matrix 
	for i = 1:nsamples
		rot_wrist_meas(:,:,i)		= quat2rotm(hand_quat(i,:))	* Rs210_l;
		rot_elbow_meas(:,:,i)		= quat2rotm(fore_quat(i,:))	* Rs28_l;
		rot_shoulder_meas(:,:,i)	= quat2rotm(uppe_quat(i,:))	* Rs26_l;
		rot_L5_meas(:,:,i)			= quat2rotm(L5_quat(i,:))	* Rs23_l;
	end
	
	% positions
	pos_shoulder_meas	= reshape_data(trial.Upperarm_L.Pos);
	pos_elbow_meas		= reshape_data(trial.Forearm_L.Pos);
	pos_wrist_meas		= reshape_data(trial.Hand_L.Pos);
	pos_L5_meas			= reshape_data(trial.L5.Pos);
		
	for i = 1:nsamples
		T_wrist(:,:,i)		= [rot_wrist_meas(:,:,i) pos_wrist_meas(:,:,i) ; 0 0 0 1];
		T_wrist_x(:,:,i)	= T_wrist(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_wrist_y(:,:,i)	= T_wrist(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_elbow(:,:,i)		= [rot_elbow_meas(:,:,i) pos_elbow_meas(:,:,i) ; 0 0 0 1];
		T_elbow_x(:,:,i)	= T_elbow(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_elbow_y(:,:,i)	= T_elbow(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_shoulder(:,:,i)	= [rot_shoulder_meas(:,:,i) pos_shoulder_meas(:,:,i) ; 0 0 0 1];
		T_shoulder_x(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_shoulder_y(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_L5(:,:,i)			= [rot_L5_meas(:,:,i) pos_L5_meas(:,:,i) ; 0 0 0 1];
		T_L5_x(:,:,i)		= T_L5(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_L5_y(:,:,i)		= T_L5(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
	end
	
	% positions of virtual marker
	pos_wrist_meas_x	= T_wrist_x(1:3, 4, :);
	pos_wrist_meas_y	= T_wrist_y(1:3, 4, :);
	pos_elbow_meas_x	= T_elbow_x(1:3, 4, :);
	pos_elbow_meas_y	= T_elbow_y(1:3, 4, :);
	pos_shoulder_meas_x = T_shoulder_x(1:3, 4, :);
	pos_shoulder_meas_y = T_shoulder_y(1:3, 4, :);
	pos_L5_meas_x		= T_L5_x(1:3, 4, :);
	pos_L5_meas_y		= T_L5_y(1:3, 4, :);
	
elseif trial.task_side == 1 % right side
	
	% quat fix sign ????
	L5_rotm = quat2rotm(trial.L5.Quat);
	L5_quat = rotm2quat(L5_rotm);
	
	%right
	hand_rotm = quat2rotm(trial.Hand_R.Quat);
	hand_quat = rotm2quat(hand_rotm);

	fore_rotm = quat2rotm(trial.Forearm_R.Quat);
	fore_quat = rotm2quat(fore_rotm);

	uppe_rotm = quat2rotm(trial.Upperarm_R.Quat);
	uppe_quat = rotm2quat(uppe_rotm);
	
	arm = arms.right;
	
	% rotation matrix 
	for i = 1:nsamples
		rot_wrist_meas(:,:,i)		= quat2rotm(hand_quat(i,:))	* Rs210_r;
		rot_elbow_meas(:,:,i)		= quat2rotm(fore_quat(i,:))	* Rs28_r;
		rot_shoulder_meas(:,:,i)	= quat2rotm(uppe_quat(i,:))	* Rs26_r;
		rot_L5_meas(:,:,i)			= quat2rotm(L5_quat(i,:))	* Rs23_r;
	end
	
	% positions
	pos_shoulder_meas	= reshape_data(trial.Upperarm_R.Pos);
	pos_elbow_meas		= reshape_data(trial.Forearm_R.Pos);
	pos_wrist_meas		= reshape_data(trial.Hand_R.Pos);
	pos_L5_meas			= reshape_data(trial.L5.Pos);
		
	for i = 1:nsamples
		T_wrist(:,:,i)		= [rot_wrist_meas(:,:,i) pos_wrist_meas(:,:,i) ; 0 0 0 1];
		T_wrist_x(:,:,i)	= T_wrist(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_wrist_y(:,:,i)	= T_wrist(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_elbow(:,:,i)		= [rot_elbow_meas(:,:,i) pos_elbow_meas(:,:,i) ; 0 0 0 1];
		T_elbow_x(:,:,i)	= T_elbow(:,:,i) * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_elbow_y(:,:,i)	= T_elbow(:,:,i) * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_shoulder(:,:,i)	= [rot_shoulder_meas(:,:,i) pos_shoulder_meas(:,:,i) ; 0 0 0 1];
		T_shoulder_x(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_shoulder_y(:,:,i) = T_shoulder(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
		T_L5(:,:,i)			= [rot_L5_meas(:,:,i) pos_L5_meas(:,:,i) ; 0 0 0 1];
		T_L5_x(:,:,i)		= T_L5(:,:,i)  * [eye(3) [d_trasl 0 0]'; 0 0 0 1];
		T_L5_y(:,:,i)		= T_L5(:,:,i)  * [eye(3) [0 d_trasl 0]'; 0 0 0 1];
		
	end
	
	% positions of virtual marker
	pos_wrist_meas_x	= T_wrist_x(1:3, 4, :);
	pos_wrist_meas_y	= T_wrist_y(1:3, 4, :);
	pos_elbow_meas_x	= T_elbow_x(1:3, 4, :);
	pos_elbow_meas_y	= T_elbow_y(1:3, 4, :);
	pos_shoulder_meas_x = T_shoulder_x(1:3, 4, :);
	pos_shoulder_meas_y = T_shoulder_y(1:3, 4, :);
	pos_L5_meas_x		= T_L5_x(1:3, 4, :);
	pos_L5_meas_y		= T_L5_y(1:3, 4, :);

end

% % array of measurements including virtual markers
% yMeas = [	pos_L5_meas;		...
% 			pos_L5_meas_x;		...
% 			pos_L5_meas_y;		...
% 			pos_shoulder_meas;	...
% 			pos_shoulder_meas_x;...
% 			pos_shoulder_meas_y;...
% 			pos_elbow_meas;		...
% 			pos_elbow_meas_x;	...
% 			pos_elbow_meas_y;	...
% 			pos_wrist_meas;		...
% 			pos_wrist_meas_x;	...
% 			pos_wrist_meas_y];	

%% build virt marker 
data = q_trial2q(trial);
q_sol = data.q_grad/180*pi;

nsamples_calc = size(q_sol,2);

yMeas_virt = zeros(33, nsamples);
for i=1:nsamples_calc
	yMeas_virt(:,i) = fkine_kalman_marker(q_sol(:,i), arm);
end


%% fig par

rate_anim = 1;

figure(1);
hold on; grid on;
View = [30 20];
Xlabel = 'x Axis [m]';
Ylabel = 'y Axis [m]';
Zlabel = 'z Axis [m]';
Title = 'PaSqualo Animazione';

set(gca, 'drawmode', 'fast');
lighting phong;
set(gcf, 'Renderer', 'zbuffer');

axis equal;
grid on;
view(View(1, 1), View(1, 2));
title(Title);
xlabel(Xlabel);
ylabel(Ylabel);
zlabel(Zlabel);

col_segm		= 'k-';		% colour segment
dim_mk			= 4;		% marker dimension
col_mk			= 'bo';		% marker colour
col_mk_in		= 'b';		% marker colour inside
dim_mk_virt		= dim_mk;   % marker dimension virt 
col_mk_virt		= 'ro';		% marker colour virt
col_mk_in_virt	= 'r';		% marker colour inside virt
col_mk_virt2	= 'go';		% marker of virtual position of frame origin
col_mk_in_virt2 = 'g';		% marker of virtual position of frame origin in

%% lim axis
lim_gap = 0.3;
xmin = min([ ...
	min(pos_L5_meas(1,1,:)), ...
	min(pos_L5_meas_x(1,1,:)), ...
	min(pos_L5_meas_y(1,1,:)), ...
	min(pos_shoulder_meas(1,1,:)), ...
	min(pos_shoulder_meas_x(1,1,:)), ...
	min(pos_shoulder_meas_y(1,1,:)), ...
	min(pos_elbow_meas(1,1,:)), ...
	min(pos_elbow_meas_x(1,1,:)), ...
	min(pos_elbow_meas_y(1,1,:)), ...
	min(pos_wrist_meas(1,1,:)), ...
	min(pos_wrist_meas_x(1,1,:)), ...
	min(pos_wrist_meas_y(1,1,:)), ...
	]) - lim_gap;
xmax = max([ ...
	max(pos_L5_meas(1,1,:)), ...
	max(pos_L5_meas_x(1,1,:)), ...
	max(pos_L5_meas_y(1,1,:)), ...
	max(pos_shoulder_meas(1,1,:)), ...
	max(pos_shoulder_meas_x(1,1,:)), ...
	max(pos_shoulder_meas_y(1,1,:)), ...
	max(pos_elbow_meas(1,1,:)), ...
	max(pos_elbow_meas_x(1,1,:)), ...
	max(pos_elbow_meas_y(1,1,:)), ...
	max(pos_wrist_meas(1,1,:)), ...
	max(pos_wrist_meas_x(1,1,:)), ...
	max(pos_wrist_meas_y(1,1,:)), ...
	]) + lim_gap;
ymin = min([ ...
	min(pos_L5_meas(2,1,:)), ...
	min(pos_L5_meas_x(2,1,:)), ...
	min(pos_L5_meas_y(2,1,:)), ...
	min(pos_shoulder_meas(2,1,:)), ...
	min(pos_shoulder_meas_x(2,1,:)), ...
	min(pos_shoulder_meas_y(2,1,:)), ...
	min(pos_elbow_meas(2,1,:)), ...
	min(pos_elbow_meas_x(2,1,:)), ...
	min(pos_elbow_meas_y(2,1,:)), ...
	min(pos_wrist_meas(2,1,:)), ...
	min(pos_wrist_meas_x(2,1,:)), ...
	min(pos_wrist_meas_y(2,1,:)), ...
	]) - lim_gap;
ymax = max([ ...
	max(pos_L5_meas(2,1,:)), ...
	max(pos_L5_meas_x(2,1,:)), ...
	max(pos_L5_meas_y(2,1,:)), ...
	max(pos_shoulder_meas(2,1,:)), ...
	max(pos_shoulder_meas_x(2,1,:)), ...
	max(pos_shoulder_meas_y(2,1,:)), ...
	max(pos_elbow_meas(2,1,:)), ...
	max(pos_elbow_meas_x(2,1,:)), ...
	max(pos_elbow_meas_y(2,1,:)), ...
	max(pos_wrist_meas(2,1,:)), ...
	max(pos_wrist_meas_x(2,1,:)), ...
	max(pos_wrist_meas_y(2,1,:)), ...
	]) + lim_gap;
zmin = 0;
zmax = max([ ...
	max(pos_L5_meas(3,1,:)), ...
	max(pos_L5_meas_x(3,1,:)), ...
	max(pos_L5_meas_y(3,1,:)), ...
	max(pos_shoulder_meas(3,1,:)), ...
	max(pos_shoulder_meas_x(3,1,:)), ...
	max(pos_shoulder_meas_y(3,1,:)), ...
	max(pos_elbow_meas(3,1,:)), ...
	max(pos_elbow_meas_x(3,1,:)), ...
	max(pos_elbow_meas_y(3,1,:)), ...
	max(pos_wrist_meas(3,1,:)), ...
	max(pos_wrist_meas_x(3,1,:)), ...
	max(pos_wrist_meas_y(3,1,:)), ...
	]) + lim_gap;

%% animation
for t = 1:rate_anim:nsamples_calc
	%%%%
	% init anim
	if t ~= 1
		child_each_plot = 3 + 12 + 2*4 +3*4;
		unplot(child_each_plot) ;
		
	end
	
	%L5
	pos_L5_now			= pos_L5_meas(:,1,t);
	rot_L5_now			= rot_L5_meas(:,:,t);
	pos_L5_x_now		= pos_L5_meas_x(:,1,t);
	pos_L5_y_now		= pos_L5_meas_y(:,1,t);
	
	%shoulder
	pos_shoulder_now	= pos_shoulder_meas(:,1,t);
	rot_shoulder_now	= rot_shoulder_meas(:,:,t);
	pos_shoulder_x_now	= pos_shoulder_meas_x(:,1,t);
	pos_shoulder_y_now	= pos_shoulder_meas_y(:,1,t);
	
	%elbow
	pos_elbow_now		= pos_elbow_meas(:,1,t);
	rot_elbow_now		= rot_elbow_meas(:,:,t);
	pos_elbow_x_now		= pos_elbow_meas_x(:,1,t);
	pos_elbow_y_now		= pos_elbow_meas_y(:,1,t);
	
	%wrist
	pos_wrist_now		= pos_wrist_meas(:,1,t);
	rot_wrist_now		= rot_wrist_meas(:,:,t);
	pos_wrist_x_now		= pos_wrist_meas_x(:,1,t);
	pos_wrist_y_now		= pos_wrist_meas_y(:,1,t);
	% yMeas = [	pos_L5_meas;		... 1-3
%				pos_L5_meas_x;		... 4-6
%				pos_L5_meas_y;		... 7-9
%				pos_shoulder_meas;	... 10-12
%				pos_shoulder_meas_x;... 13-15
%				pos_shoulder_meas_y;... 16-18
%				pos_elbow_meas;		... 19-21
%				pos_elbow_meas_x;	... 22-24
%				pos_elbow_meas_y;	... 25-27
%				pos_wrist_meas;		... 28-30
%				pos_wrist_meas_x;	... 31-33
%				pos_wrist_meas_y];		34-36

	%%virt
	%L5
	%pos_L5_virt_now			= yMeas_virt([1:3],t);
	pos_L5_x_virt_now		= yMeas_virt([1:3],t);
	pos_L5_y_virt_now		= yMeas_virt([4:6],t);
	
	%shoulder
	pos_shoulder_virt_now	= yMeas_virt([7:9],t);
	pos_shoulder_x_virt_now	= yMeas_virt([10:12],t);
	pos_shoulder_y_virt_now	= yMeas_virt([13:15],t);
	
	%elbow
	pos_elbow_virt_now		= yMeas_virt([16:18],t);
	pos_elbow_x_virt_now	= yMeas_virt([19:21],t);
	pos_elbow_y_virt_now	= yMeas_virt([22:24],t);
	
	%wrist
	pos_wrist_virt_now		= yMeas_virt([25:27],t);
	pos_wrist_x_virt_now	= yMeas_virt([28:30],t);
	pos_wrist_y_virt_now	= yMeas_virt([31:33],t);
	
	%%%%
	% interconnection %3
	
	% L5 - Shoulder 
    plot3(	[pos_L5_now(1); pos_shoulder_now(1)],...
			[pos_L5_now(2); pos_shoulder_now(2)],...
			[pos_L5_now(3);	pos_shoulder_now(3)],...
			col_segm)
	% Shoulder - Elbow
	plot3(	[pos_elbow_now(1);	pos_shoulder_now(1)],...
			[pos_elbow_now(2);	pos_shoulder_now(2)],...
			[pos_elbow_now(3);	pos_shoulder_now(3)],...
			col_segm)
	
	% Elbow - wrist
	plot3(	[pos_elbow_now(1);	pos_wrist_now(1)],...
			[pos_elbow_now(2);	pos_wrist_now(2)],...
			[pos_elbow_now(3);	pos_wrist_now(3)],...
			col_segm)
	
	% sist ref	%12 elem
	draw_frame(pos_L5_now,			rot_L5_now);		%3 elem
	draw_frame(pos_shoulder_now,	rot_shoulder_now);	%3
	draw_frame(pos_elbow_now,		rot_elbow_now);		%3
	draw_frame(pos_wrist_now,		rot_wrist_now);		%3
	
	% marker
	%L5
	plot3(	pos_L5_x_now(1),...
			pos_L5_x_now(2),...
			pos_L5_x_now(3),...
			col_mk,'MarkerSize', dim_mk,'MarkerFaceColor',col_mk_in)
	plot3(	pos_L5_y_now(1),...
			pos_L5_y_now(2),...
			pos_L5_y_now(3),...
			col_mk,'MarkerSize', dim_mk,'MarkerFaceColor',col_mk_in)
	% shoulder
	plot3(	pos_shoulder_x_now(1),...
			pos_shoulder_x_now(2),...
			pos_shoulder_x_now(3),...
			col_mk,'MarkerSize', dim_mk,'MarkerFaceColor',col_mk_in)
	plot3(	pos_shoulder_y_now(1),...
			pos_shoulder_y_now(2),...
			pos_shoulder_y_now(3),...
			col_mk,'MarkerSize', dim_mk,'MarkerFaceColor',col_mk_in)
	% elbow
	plot3(	pos_elbow_x_now(1),...
			pos_elbow_x_now(2),...
			pos_elbow_x_now(3),...
			col_mk,'MarkerSize', dim_mk,'MarkerFaceColor',col_mk_in)
	plot3(	pos_elbow_y_now(1),...
			pos_elbow_y_now(2),...
			pos_elbow_y_now(3),...
			col_mk,'MarkerSize', dim_mk,'MarkerFaceColor',col_mk_in)
	% wrist
	plot3(	pos_wrist_x_now(1),...
			pos_wrist_x_now(2),...
			pos_wrist_x_now(3),...
			col_mk,'MarkerSize', dim_mk,'MarkerFaceColor',col_mk_in)
	plot3(	pos_wrist_y_now(1),...
			pos_wrist_y_now(2),...
			pos_wrist_y_now(3),...
			col_mk,'MarkerSize', dim_mk,'MarkerFaceColor',col_mk_in)
	
	% marker virt
	%L5
% 	plot3(	pos_L5_virt_now(1),...
% 			pos_L5_virt_now(2),...
% 			pos_L5_virt_now(3),...
% 			col_mk_virt2,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt2)
	plot3(	pos_L5_x_virt_now(1),...
			pos_L5_x_virt_now(2),...
			pos_L5_x_virt_now(3),...
			col_mk_virt,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt)
	plot3(	pos_L5_y_virt_now(1),...
			pos_L5_y_virt_now(2),...
			pos_L5_y_virt_now(3),...
			col_mk_virt,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt)
	% shoulder
	plot3(	pos_shoulder_virt_now(1),...
			pos_shoulder_virt_now(2),...
			pos_shoulder_virt_now(3),...
			col_mk_virt2,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt2)
	plot3(	pos_shoulder_x_virt_now(1),...
			pos_shoulder_x_virt_now(2),...
			pos_shoulder_x_virt_now(3),...
			col_mk_virt,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt)
	plot3(	pos_shoulder_y_virt_now(1),...
			pos_shoulder_y_virt_now(2),...
			pos_shoulder_y_virt_now(3),...
			col_mk_virt,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt)
	% elbow
	plot3(	pos_elbow_virt_now(1),...
			pos_elbow_virt_now(2),...
			pos_elbow_virt_now(3),...
			col_mk_virt2,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt2)
	plot3(	pos_elbow_x_virt_now(1),...
			pos_elbow_x_virt_now(2),...
			pos_elbow_x_virt_now(3),...
			col_mk_virt,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt)
	plot3(	pos_elbow_y_virt_now(1),...
			pos_elbow_y_virt_now(2),...
			pos_elbow_y_virt_now(3),...
			col_mk_virt,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt)
	% wrist
	plot3(	pos_wrist_virt_now(1),...
			pos_wrist_virt_now(2),...
			pos_wrist_virt_now(3),...
			col_mk_virt2,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt2)
	plot3(	pos_wrist_x_virt_now(1),...
			pos_wrist_x_virt_now(2),...
			pos_wrist_x_virt_now(3),...
			col_mk_virt,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt)
	plot3(	pos_wrist_y_virt_now(1),...
			pos_wrist_y_virt_now(2),...
			pos_wrist_y_virt_now(3),...
			col_mk_virt,'MarkerSize', dim_mk_virt,'MarkerFaceColor',col_mk_in_virt)	
	% end stuff	
	Title = ['Animation (frame ', num2str(t), ' di ', num2str(nsamples_calc), ')'];
	title(Title)
	axis equal;
	xlim([xmin, xmax])
	ylim([ymin, ymax])
	zlim([zmin, zmax])
	grid on;
	drawnow;
	
	
end




end

function draw_frame(pos, rot)

x = pos(1);
y = pos(2);
z = pos(3);

d = 0.5;

qx = rot * [d; 0; 0];
qy = rot * [0; d; 0];
qz = rot * [0; 0; d];

quiver3(x,y,z,qx(1),qx(2),qx(3), 'r', 'ShowArrowHead', false)
quiver3(x,y,z,qy(1),qy(2),qy(3), 'g', 'ShowArrowHead', false)
quiver3(x,y,z,qz(1),qz(2),qz(3), 'b', 'ShowArrowHead', false)

end

