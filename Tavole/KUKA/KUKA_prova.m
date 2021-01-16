%% Clean ENV

clear all;
close all;
clc;

%% Choose Trajectory

fprintf('Choose trajectory: \n');

fprintf('1: Circumference \n');

fprintf('2: Helix \n');

choiche = input(' ... ');

%% Setup
 
load('robot.mat')
load('robotmodel.mat')
%% plot options
light_grey	= [0.99, 0.99, 0.99];
black		= [0, 0, 0];
KUKA.plotopt = {	'workspace',[-1,1,-1,1,0,1.5],...
					'floorlevel',0,...
					'trail','b',...
					'linkcolor',light_grey,...
					'jointcolor',black,...
					'view', [-49.1620,25.8980],...
					'raise'				};
grey = [0.5, 0.5, 0.5];
orange = [0.8, 0.6, 0];

t_in = 0; % [s]
t_fin = 10; % [s]
delta_t = 0.001; % [s]
timeSpan= 10;

t = t_in:delta_t:t_fin;

num_of_joints = 5;

Q = zeros(num_of_joints,length(t));
dQ = zeros(num_of_joints,length(t));
ddQ = zeros(num_of_joints,length(t));
TAU = zeros(num_of_joints,length(t));

%% Select Trajectory

switch choiche
                    
    case 1 % Circonferenza
        
        q0 = [0 pi/2 pi/2 pi/2 0 ];
        q_dot0 = [0 0 0 0 0 ];
        
        pos0 = KUKA.fkine(q0);

        radius = 0.1; % raggio dell'elica [m]
        center = pos0(1:3,4) - [radius;0;0];
        
%       Fast Trajectory
        x = center(1) + radius * cos(t/t(end)*2*pi);
        y = center(2) * ones(size(x));
        z = center(3) + radius * sin(t/t(end)*2*pi);
%       theta	= 0.5*sin(t/3*2*pi);
        theta	= zeros(size(x));
        phi		= zeros(size(x));
        psi		= zeros(size(x));

        xi = [x; y; z; theta; phi; psi]; % twist
        
        
        q_des = generate_trajectory2(xi,q0,KUKA);
        dq_des = gradient(q_des)*1000;
        ddq_des = gradient(dq_des)*1000;
        
        figure
        KUKA.plotopt = {'workspace',[-0.75,0.75,-0.75,0.75,0,1]};
        KUKA.plot(q0,'floorlevel',0,'linkcolor',orange,'jointcolor',grey)
        hold
        plot3(x,y,z,'k','Linewidth',1.5)
        KUKA.plot(q_des(:,1:50:end)','floorlevel',0,'linkcolor',orange,'jointcolor',grey)

    case 2 % Traiettoria elicoidale
        
%         q0 = [0 2/3*pi 2/3*pi pi/3 0 ];
%         q_dot0 = [0 0 0 0 0 ];
%         pos0 = KUKA.fkine(q0);
%        
%         shift = 0.1; % passo dell'elica [m] 
%         radius = 0.1; % raggio dell'elica [m]
%         num = 2; % numero di giri [#]
%         center = pos0(1:3,4) - [0;radius;0];
% 
%         x = center(1) + radius * cos(t/t(end)*num*2*pi);
%         y = center(2) + t/t(end)*num*shift;
%         z = center(3) + radius * sin(t/t(end)*num*2*pi);
%         theta = zeros(size(x));
%         phi = zeros(size(x));
%         psi = zeros(size(x));
		q0 = [0 pi/4 -pi/4 pi/4 0 ];
        q_dot0 = [0 0 0 0 0 ];
        pos1 = KUKA.fkine(q0);
		radius = 0.05; % raggio dell'elica [m]
		num = 1; % numero di giri [#]
		center = pos1(1:3,4) - [0;0;radius];% partendo dal punto pos1 calcolo il cerchio nel pianonel piano XZ
		p = zeros(3,size(t,2));
		for i=1:size(t,2)
			p(:,i) = center + roty(t(i)*num/t(end)*2*pi)*[0;0;radius] -[0;radius;0]*t(i)/t(end)  ;
		end
		theta	= 0.5*sin(t/3*2*pi);
% 		theta = zeros(size(p(1,:)));
		phi =  zeros(size(p(1,:)));
		psi =  zeros(size(p(1,:)));
		xi = [p(1,:);p(2,:);p(3,:); theta; phi; psi]; % pose ee nel tempo
        
        
        q_des = generate_trajectory2(xi,q0,KUKA);
        dq_des = gradient(q_des) * 1000;
        ddq_des = gradient(dq_des) * 1000;
		 
		figure(1)
		clf
%        KUKA.plot(q0,'floorlevel',0,'linkcolor',orange,'jointcolor',grey)
        plot3(p(1,:),p(2,:),p(3,:),'k','Linewidth',1.5)
		hold on
        KUKA.plot(q_des(:,1:50:end)','trail','r')
	case 3
	%% clotoide

	punto1zy = hgmat2pos(pos1); punto1zy = flip(punto1zy(2:3));

	fig2 = figure(2);
	clf
	hold on
	x_shaded = [-0.5 0.5 0.5 -0.5];
	y_shaded = [0.5 0.5 1 1];
	fill(x_shaded, y_shaded, 'g' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

	x_shaded = [-0.5 0.5 0.5 -0.5];
	y_shaded = [0 0 0.5 0.5];
	fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

	x_shaded = [-0.5 0.5 0.5 -0.5];
	y_shaded = [1 1 1.2 1.2];
	fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

	x_shaded = [-0.6 -0.5 -0.5 -0.6];
	y_shaded = [0 0 1.2 1.2];
	fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

	x_shaded = [0.6 0.5 0.5 0.6];
	y_shaded = [0 0 1.2 1.2];
	fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

	xlim([-0.6 0.6]);
	ylim([0 1.2]);
	xlabel('-Y [m]')
	ylabel('Z [m]')
	grid on

	points_clot = ginput;

	% handling ginput_frame to franka globalframe
	for i = 1 :size(points_clot,1)
		points_clot(i,:) = [cos(-pi/2) -sin(-pi/2); sin(-pi/2) cos(-pi/2)] * points_clot(i,:)';
	end

	% gen points on clothoid and path
	dx = 0.3;
	zy_clot = gen_clot(points_clot);
	clot_sizes = size(zy_clot,1);

	x_clot = 0.3 * ones(1, clot_sizes);
	for i = 2:clot_sizes
		x_clot(i) = x_clot(i-1) + dx/(clot_sizes-1);
	end

	p_clot = [x_clot;zy_clot(:,2)';zy_clot(:,1)'];

	posclot_ini = [pos1(1:3,1:3) , p_clot(:,1); [0 0 0 1] ];
	T_appr = ctraj(pos1, posclot_ini, n_steps_appr);	% matrix hom approach al punto 
												% iniziale clotoide
	p_appr = hgmat2pos(T_appr);
	eul_appr = hgmat2eul(T_appr);
	p = [p_appr, p_clot];

	% generating xi
	theta	= zeros(size(p(1,:)));
	phi		= zeros(size(p(1,:)));
	psi		= zeros(size(p(1,:)));

	xi		= [p(1,:);p(2,:);p(3,:); theta; phi; psi];
	t_end = size(xi,2)*delta_t;
	t = (t_in+delta_t):delta_t:t_fin;

	[q_des, dq_des, ddq_des] = generate_trajectory2(xi, qv1, franka, delta_t);
end