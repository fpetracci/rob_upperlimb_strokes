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
 
load('KUKA.mat')
load('KUKAmodel.mat')
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
        
        
        q_des = generate_trajectoryKUKA(xi,q0,KUKA);
        dq_des = gradient(q_des)*1000;
        ddq_des = gradient(dq_des)*1000;
        
        figure
        KUKA.plotopt = {'workspace',[-0.75,0.75,-0.75,0.75,0,1]};
        KUKA.plot(q0)
        hold
        plot3(x,y,z,'b','Linewidth',1.5)
        KUKA.plot(q_des(:,1:50:end)')

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

end

%% ---------------------COMPUTED TORQUE_NO_ADAPTIVE------------------------
%% Trajectory Tracking: Computed Torque Method

n = 5;
d = 1;
for j = 1:n 
    KUKAmodel.links(j).m = KUKAmodel.links(j).m .* (1.1); 
end

% 
% Gain circumference parameters matrix
Kp = 20*diag([3 3 3 3 5 ]);
Kv = 10*diag([1 1 1 1 1]);

% Good Helix parameters matrix
% Kp = 200*diag([3 3 3 3 5 3 5]);
% Kv = 25*diag([1 1 1 1 70 2 70]);
%% Computed torque with correct estimation
results_computed_torque1 = q0;
index = 1;
q = q0;
dq = q_dot0;
ddq = [0 0 0 0 0 ];
for i=1:length(t)

   % Error and derivate of the error  
   
    err = transpose(q_des(:,i)) - q;
    derr = transpose(dq_des(:,i)) - dq;
    
%     %Get dynamic matrices

    M = KUKA.inertia(q); 
    C = KUKA.coriolis(q,dq); 
    G = KUKA.gravload(q); 
    
    tau = ( M*(ddq_des(:,i) + Kv*(derr') + Kp*(err')) + (dq*C)' + G' )';
      
    % Robot joint accelerations
    ddq_old = ddq;
    ddq = (pinv(M)*(tau' - (dq*C)'- G'))';
        
    % Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
    % Store result for the final plot
    results_computed_torque1(index,:) = q;
    index = index + 1;

end
%% Computed torque with wrong estimation
results_computed_torque2 = q0;
index = 1;
q = q0;
dq = q_dot0;
ddq = [0 0 0 0 0 ];
for i=1:length(t)

   % Error and derivate of the error   
    err = transpose(q_des(:,i)) - q;
    derr = transpose(dq_des(:,i)) - dq;
    
%     %Get dynamic matrices
    M1 = KUKAmodel.inertia(q); 
    C1 = KUKAmodel.coriolis(q,dq); 
    G1 = KUKAmodel.gravload(q); 
    
    %% Computed Torque Controller with wrong estimation'
    
    tau = ( M1*(ddq_des(:,i) + Kv*(derr') + Kp*(err')) + (dq*C1)' + G1' )';
      
    % Robot joint accelerations
    ddq_old = ddq;
    ddq = (pinv(M)*(tau' - (dq*C)'- G'))';
        
    % Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
    % Store result for the final plot
    results_computed_torque2(index,:) = q;
    index = index + 1;

end
%% Plot computed torque results for trajectory tracking
%save('computed_torque_NO_adaptive','results_computed_torque1','results_computed_torque2','q_des')
load('computed_torque_NO_adaptive.mat')
num_of_joints = 5;
figure
for j=1:num_of_joints
    subplot(4,2,j);
    plot(t(1:10001),results_computed_torque1(1:10001,j))
    hold on
    plot (t,q_des(j,1:length(t)))
    plot(t(1:10001),results_computed_torque2(1:10001,j))
    legend ('Computed Torque','Desired angle', 'Computed Torque with wrong estimation')
    grid;
end
%

%% ---------------------BACKSTEPPING_NO_ADAPTIVE---------------------------
%% Trajectory Tracking: Backstepping Method
n = 5;
d = 1;
for j = 1:n 
    KUKAmodel.links(j).m = KUKAmodel.links(j).m .* (1.1); 
end

% 
% Gain circumference parameters matrix
Kp = 0.1*diag([1 5 5 5 1 ]);
%% Trajectory tracking: Backstepping control good parameter estimation

results_backstepping1 = q0;
index = 1;
q = q0;
dq = q_dot0;
ddq = [0 0 0 0 0 ];
for i=1:length(t)

   % Error and derivate of the error   
    err = transpose(q_des(:,i)) - q;
    derr = transpose(dq_des(:,i)) - dq;
    
    dqr = transpose(dq_des(:,i)) + err*(Kp);
    ddqr = transpose(ddq_des(:,i)) + derr*(Kp);
    s = derr + err*(Kp');
     
    %Get dynamic matrices
	M = KUKAmodel.inertia(q); 
    C = KUKAmodel.coriolis(q,dq); 
    G = KUKAmodel.gravload(q); 

    % Backstepping Controller
    tau = (M*(ddqr') + C*(dqr') + G' + Kp*(s') + err')';        
    
    % Robot joint accelerations
    ddq_old = ddq;
    ddq = (pinv(M)*(tau - (C*(dq'))'- G)')';
        
    % Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
    % Store result for the final plot
    results_backstepping1(index,  :) = q;
    index = index + 1;
end
 %% Trajectory tracking: Backstepping control wrong parameter estimation
% Good Circumference parameters
Kp = 0.1* diag([1 5 5 5 1 ]);

results_backstepping2 = q0;
index = 1;
q = q0;
dq = q_dot0;
ddq = [0 0 0 0 0 ];
for i=1:length(t)

   % Error and derivate of the error   
    err = transpose(q_des(:,i)) - q;
    derr = transpose(dq_des(:,i)) - dq;
    
    dqr = transpose(dq_des(:,i)) + err*(Kp);
    ddqr = transpose(ddq_des(:,i)) + derr*(Kp);
    s = derr + err*(Kp');
     
    %Get dynamic matrices
	M1 = KUKAmodel.inertia(q); 
    C1 = KUKAmodel.coriolis(q,dq); 
    G1 = KUKAmodel.gravload(q); 

    % Backstepping Controller
    tau = (M1*(ddqr') + C1*(dqr') + G' + Kp*(s') + err')';        
    
    % Robot joint accelerations
    ddq_old = ddq;
    ddq = (pinv(M)*(tau - (C*(dq'))'- G)')';
        
    % Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
    % Store result for the final plot
    results_backstepping2(index,  :) = q;
    index = index + 1;
end
%% Plot backstepping results for trajectory tracking
save('backstepping_NO_adaptive','results_backstepping1','results_backstepping2','q_des')
%load('backstepping_NO_adaptive.mat')
num_of_joints = 5;
figure
for j=1:num_of_joints
    subplot(4,2,j);
    plot(t(1:10001), results_backstepping1(1:10001,j))
    hold on
    plot (t,q_des(j,1:length(t)))
    plot(t(1:10001), results_backstepping2(1:10001,j))
    legend ('BackStepping','Desired angle', 'BackStepping with wrong estimation')
    grid;
end
%