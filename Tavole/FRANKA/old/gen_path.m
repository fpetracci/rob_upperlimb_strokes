function [arm_right, traj_real, traj_fpc] = gen_path(nfpc, plot_mode )
% Questo funzione carica nel workspace:
% 	- traj_real		posa EE braccio umano
% 	- traj_fpc		posa EE braccio umano semplificata
% 	- arm_right		SerialLink braccio destro umano
% Possibile avere alcuni Plot inserendo plot_mode = 1

if nargin < 1
	plot_mode = 0;
	nfpc = 4;
elseif nargin < 2
	plot_mode = 0;
end
%% Costruzione generico braccio destro

d3		= 0.1494;
a3		= 0.3912;
d6		= -0.3180;
d8		= -0.2603;
d10		= 0;
th3_r	= -1.9598;
al4_r	= 1.9598;

Tg0 = [1 0 0 -0.2401; 0 0 1 0.0161; 0 -1 0 0.8730; 0 0 0 1];

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

arm_right = SerialLink(Link_r, 'name', 'Right arm');
arm_right.base = Tg0;

%% Trial reale

ngroup = 1;
fPCA_struct = fpca_hsla(ngroup);
q_stacked =  fpca_stacker_hsla(ngroup);
nobs = 135;

q_real = q_stacked.q_matrix_h(nobs,:,:); % seleziono un singolo trial, angoli in gradi
[temp, n, njoints] = size(q_real); % n = time
q_real = reshape(q_real, n, njoints, temp); % time x joints

% arm fkine
traj_real	= zeros(4, 4, n);	% Pose of human EE: Homogeneous matrices 
for i = 1:n
	traj_real(:,:, i) = arm_fkine(arm_right, q_real(i,:).*(pi/180), 10); %fkine want angles in rad
	% 10 ottiene matrice omogenea della mano
end

%% Trial semplificato con un numero limitato di fPCs
% nfpc = 4;	% numero di fPC che vogliamo usare nel ricostruire, 
% 			% +1 per la media
q_fpc = zeros(n,njoints,1);

for j = 1:10 % joint
	[qmat, ~] = fpca2q(fPCA_struct.h_joint(j));
	
	mean_mat	= mean(q_stacked.q_matrix_h,2);
	mean_tmp	= mean_mat(nobs,1,j);

	q_fpc(:,j) = qmat(:,nobs,nfpc+1)+mean_tmp;
	% +1 per la media calcolata nella fPC che e` nulla
end

% arm fkine
traj_fpc	= zeros(4, 4, n);	% human EE 
for i = 1:n
	traj_fpc(:,:, i) = arm_fkine(arm_right, q_fpc(i,:).*(pi/180), 10);
	% 10 ottiene matrice omogenea della mano
end

%% Plot & Debug
if plot_mode == 1

	pos_real = hgmat2pos(traj_real)';
	pos_fpc = hgmat2pos(traj_fpc)';

	dim_linea = 1;

	figure(1)
	clf
	axis equal
	plot3(  pos_fpc(:,1), pos_fpc(:,2),pos_fpc(:,3),...
				'-','color', [0, 0, 255]./255, 'LineWidth', dim_linea,...
				'DisplayName','Traj fPCs')
	hold on
	plot3(pos_real(:,1), pos_real(:,2), pos_real(:,3),...
				'-','color', [255, 0, 0]./255, 'LineWidth', dim_linea,...
				'DisplayName','Traj real')
	legend

	figure(2)
	clf
	axis equal
	plot3(  pos_fpc(:,1), pos_fpc(:,2),pos_fpc(:,3),...
				'-','color', [0, 0, 255]./255, 'LineWidth', dim_linea/10,...
				'DisplayName','Traj fPCs')
	hold on
	plot3(pos_real(:,1), pos_real(:,2), pos_real(:,3),...
				'-','color', [255, 0, 0]./255, 'LineWidth', dim_linea/10,...
				'DisplayName','Traj real')
	quiver3(pos_real(:,1), pos_real(:,2), pos_real(:,3),...
		pos_fpc(:,1)-pos_real(:,1), pos_fpc(:,2)-pos_real(:,2),pos_fpc(:,3)-pos_real(:,3), 0, 'g',...
		'DisplayName','Vettore Differenza')
	for i = 1:2:n
		txt = num2str(norm([pos_fpc(i,1)-pos_real(i,1),...
					pos_fpc(i,2)-pos_real(i,2),...
					pos_fpc(i,3)-pos_real(i,3)],2), 3);
		text(pos_real(i,1), pos_real(i,2), pos_real(i,3),txt)
	end

	legend
	axis equal
end


end
