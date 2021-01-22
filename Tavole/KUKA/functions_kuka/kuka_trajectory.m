% This script is part of the developed code for kuka

%% input choice
fprintf('Choose trajectory by typing the number associated: \n');
fprintf('1: Circumference \n');
fprintf('2: Helix \n');
traj_choice = input('');

if traj_choice ~= 1 && traj_choice ~= 2
	error('Trajectory Number inserted is not supported')
end

%% plot options
light_grey	= [0.99, 0.99, 0.99];
black		= [0, 0, 0];
KUKA.plotopt = {	'workspace',[-1,1,-1,1,0,1.5],...
					'floorlevel',0,...
					'trail','r',...
					'linkcolor',light_grey,...
					'jointcolor',black,...
					'view', [-49.1620,25.8980],...
					'raise'				};
grey = [0.5, 0.5, 0.5];
orange = [0.8, 0.6, 0];

%% Initialization
% time definition
t_in = 0; % [s]
t_fin = 10; % [s]
delta_t = 0.001; % [s]
timeSpan= 10;

t = t_in:delta_t:t_fin;

% Kuka parameters
num_of_joints = size(KUKA.links, 2);

% matrices initialization
Q = zeros(num_of_joints,length(t));
dQ = zeros(num_of_joints,length(t));
ddQ = zeros(num_of_joints,length(t));
TAU = zeros(num_of_joints,length(t));

%% Select Trajectory

switch traj_choice                  
    case 1 % Circonferenza
        
        q0 = [0 pi/2 pi/2 pi/2 0]';
        q_dot0 = [0 0 0 0 0]';
        
        pos0 = KUKA.fkine(q0');

        radius = 0.1; % raggio della circonferenza [m]
        center = pos0(1:3,4) - [radius;0;0];
        
		% quante volte gliela facciamo fare
		nrep = 2;
		
%       Fast Trajectory
        x = center(1) + radius * cos(nrep * t/t(end)*2*pi);
        y = center(2) * ones(size(x));
        z = center(3) + radius * sin(nrep * t/t(end)*2*pi);
%       theta	= 0.5*sin(t/3*2*pi);
       
		% end effector orientation
		theta	= zeros(size(x));
        phi		= zeros(size(x));
        psi		= zeros(size(x));

        xi = [x; y; z; theta; phi; psi]; 
        
        q_des = generate_trajectoryKUKA(xi,q0,KUKA, delta_t);
        dq_des = gradient(q_des)/delta_t;
        ddq_des = gradient(dq_des)/delta_t;
        
        figure(1)
        KUKA.plotopt = {'workspace',[-0.75,0.75,-0.75,0.75,0,1]};
        KUKA.plot(q0')
        hold on
        plot3(x,y,z,'b','Linewidth',1.5)
		title('Desired trajectory: circumference')
		view([-45, 20])
        KUKA.plot(q_des(:,1:50:end)')
		

    case 2 % Traiettoria elicoidale
        
% 		q0 = [0 2/3*pi 2/3*pi pi/3 0]';
% 		q_dot0 = [0 0 0 0 0]';
% 		pos0 = KUKA.fkine(q0);
% 
% 		shift = 0.1; % passo dell'elica [m] 
% 		radius = 0.1; % raggio dell'elica [m]
% 		num = 2; % numero di giri [#]
% 		center = pos0(1:3,4) - [0;radius;0];
% 
% 		x = center(1) + radius * cos(t/t(end)*num*2*pi);
% 		y = center(2) + t/t(end)*num*shift;
% 		z = center(3) + radius * sin(t/t(end)*num*2*pi);
% 		theta = zeros(size(x));
% 		phi = zeros(size(x));
% 		psi = zeros(size(x));

	q0 = [0 pi/4 -pi/4 pi/4 0]';
	q_dot0 = [0 0 0 0 0]';
	pos1 = KUKA.fkine(q0);
	radius = 0.05; % raggio dell'elica [m]
	num = 1; % numero di giri [#]
	center = pos1(1:3,4) - [0;0;radius];% partendo dal punto pos1 calcolo il cerchio nel piano XZ
	p = zeros(3,size(t,2));
	
	for i=1:size(t,2)
		p(:,i) = center + roty(t(i)*num/t(end)*2*pi)*[0;0;radius] -[0;radius;0]*t(i)/t(end);
	end
	
	theta	= 0.5*sin(t/3*2*pi);
	% 		theta = zeros(size(p(1,:)));
	phi =  zeros(size(p(1,:)));
	psi =  zeros(size(p(1,:)));
	xi = [p(1,:);p(2,:);p(3,:); theta; phi; psi]; % pose ee nel tempo

	q_des = generate_trajectoryKUKA(xi, q0, KUKA, delta_t);
	dq_des = gradient(q_des)/delta_t;
	ddq_des = gradient(dq_des)/delta_t;

	figure(1)
		clf
		KUKA.plotopt = {'workspace',[-0.75,0.75,-0.75,0.75,0,1]};
		KUKA.plot(q0)
		hold on
		plot3(x,y,z,'b','Linewidth',1.5)
		title('Desired trajectory: helix')
		KUKA.plot(q_des(:,1:50:end)')
		
	case 3
	%% clotoide

end