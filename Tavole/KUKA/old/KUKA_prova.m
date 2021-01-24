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
%% Initialization
% time definition
t_in = 0; % [s]
t_fin = 10; % [s]
delta_t = 0.001; % [s]
timeSpan= 10;

t = t_in:delta_t:t_fin;

% Kuka parameters
num_of_joints = 5;

% matrices initialization
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

        radius = 0.1; % raggio della circonferenza [m]
        center = pos0(1:3,4) - [radius;0;0];
        
%       Fast Trajectory
        x = center(1) + radius * cos(t/t(end)*2*pi);
        y = center(2) * ones(size(x));
        z = center(3) + radius * sin(t/t(end)*2*pi);
%       theta	= 0.5*sin(t/3*2*pi);
       
		% end effector orientation
		theta	= zeros(size(x));
        phi		= zeros(size(x));
        psi		= zeros(size(x));

        xi = [x; y; z; theta; phi; psi]; 
        
        q_des = generate_trajectoryKUKA(xi,q0,KUKA, delta_t);
        dq_des = gradient(q_des)/delta_t;
        ddq_des = gradient(dq_des)/delta_t;
        
        figure
        KUKA.plotopt = {'workspace',[-0.75,0.75,-0.75,0.75,0,1]};
%         KUKA.plot(q0)
%         hold
%         plot3(x,y,z,'b','Linewidth',1.5)
%         KUKA.plot(q_des(:,1:50:end)')

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
%        KUKA.plot(q0,'floorlevel',0,'linkcolor',orange,'jointcolor',grey)
        plot3(p(1,:),p(2,:),p(3,:),'k','Linewidth',1.5)
		hold on
        KUKA.plot(q_des(:,1:50:end)','trail','r')
	case 3
	%% clotoide

end
%% Select controller

fprintf('Choose controller: \n');

fprintf('1: COMPUTED TORQUE_NO_ADAPTIVE \n');

fprintf('2: BACKSTEPPING_NO_ADAPTIVE \n');

fprintf('3:	BACKSTEPPING_ADAPTIVE \n');

fprintf('4: COMPUTED TORQUE_ADAPTIVE \n');
controller = input(' ... ');
switch controller
                    
    case 1 

%% ---------------------COMPUTED TORQUE_NO_ADAPTIVE------------------------
%% Trajectory Tracking: Computed Torque Method

n = size(KUKA.links, 2);
d = 1;
for j = 1:n 
    KUKAmodel.links(j).m = KUKAmodel.links(j).m .* (1.1); 
end

% 
% Gain circumference parameters matrix
Kp = 20*diag([3 3 3 3 5 ]);
Kv = 10*diag([1 1 1 1 1]);
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
    C = KUKA.coriolis(q, dq); 
    G = KUKA.gravload(q); 
    
    tau = (M*(ddq_des(:,i) + Kv*(derr') + Kp*(err')) + (dq*C)' + G')';
      
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
%load('computed_torque_NO_adaptive.mat')
num_of_joints = size(KUKA.links, 2);
figure
for j=1:num_of_joints
    subplot(4,2,j);
    plot(t(1:length(t)),results_computed_torque1(1:length(t),j))
    hold on
    plot (t,q_des(j,1:length(t)))
    plot(t(1:length(t)),results_computed_torque2(1:length(t),j))
    legend ('Computed Torque','Desired angle', 'Computed Torque with wrong estimation')
    grid;
end
%
	case 2
%% ---------------------BACKSTEPPING_NO_ADAPTIVE---------------------------
%% Trajectory Tracking: Backstepping Method
n = size(KUKA.links, 2);
d = 1;
for j = 1:n 
    KUKAmodel.links(j).m = KUKAmodel.links(j).m .* (1.1); 
end

% 
% Gain circumference parameters matrix
Kp = 0.1*diag([1 1 1 1 1 ]);
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
%save('backstepping_NO_adaptive','results_backstepping1','results_backstepping2','q_des')
%load('backstepping_NO_adaptive.mat')
num_of_joints = 5;
figure
for j=1:num_of_joints
    subplot(4,2,j);
    plot(t(1:length(t)), results_backstepping1(1:10001,j))
    hold on
    plot (t,q_des(j,1:length(t)))
    plot(t(1:length(t)), results_backstepping2(1:length(t),j))
    legend ('BackStepping','Desired angle', 'BackStepping with wrong estimation')
    grid;
end
%
KUKA.plot(q_des(:,1:50:end)','trail','black')
	case 3
%% ---------------------BACKSTEPPING_ADAPTIVE------------------------------
%% Perturbazione iniziale dei parametri
	q_des = q_des';
	dq_des  = dq_des';
	ddq_des = ddq_des';
	int = 2.5; % intensità percentuale della perturbazione sui parametri
	n = 5;
	for j = 1:n 
		KUKAmodel.links(j).m = KUKAmodel.links(j).m .* (1+int/100); 
	end
%% Simulazione
q = zeros(length(t),n); 
q_dot = zeros(length(t),n); 
tau = zeros(length(t),n); 
piArray = zeros(length(t),n*10); % vettore dei parametri dinamici 
q0 = [0 pi/2 -pi/2 0 0] + pi/6*[0.3 0.4 0.2 0.8 0] - pi/12; % partiamo in una posizione diversa da quella di inizio traiettoria
q(1,:) = q0; 
q_dot(1,:) = q_dot0; 

qr_dot = zeros(length(t),n); 
qr_ddot = zeros(length(t),n); 

pi0 = zeros(1,n*10); 
for j = 1:n
    pi0((j-1)*10+1:j*10) = [KUKAmodel.links(j).m KUKAmodel.links(j).m*KUKAmodel.links(j).r ...
        KUKAmodel.links(j).I(1,1) 0 0 KUKAmodel.links(j).I(2,2) 0 KUKAmodel.links(j).I(3,3)];
end
piArray(1,:) = pi0; 

Kp = 1*diag([200 200 200 20 10]);
Kv = 0.1*diag([200 200 200 10 1]); 
Kd = 0.1*diag([200 200 200 20 1]);

% P e R fanno parte della candidata di Lyapunov, quindi devono essere definite positive
R = diag(repmat([1e1 repmat(1e3,1,3) 1e2 1e7 1e7 1e2 1e7 1e2],1,n)); 
P = 0.01*eye(10);
lambda = diag([200, 200, 200, 200, 200])*0.03;



tic
for i = 2:length(t)
%% Interruzione della simulazione se q diverge
    if any(isnan(q(i-1,:)))
        fprintf('Simulazione interrotta! \n')
        return
	end
	
%% Calcolo dell'errore: e, e_dot
    e = q_des(i-1,:) - q(i-1,:); 
    e_dot = dq_des(i-1,:) - q_dot(i-1,:); 
    s = (e_dot + e*lambda);
    
    qr_dot(i-1,:) = dq_des(i-1,:) + e*lambda;
    if (i > 2)
        qr_ddot(i-1,:) = (qr_dot(i-1) - qr_dot(i-2)) / delta_t;
	end
	
	for j = 1:n 
		KUKAmodel.links(j).m = piArray(i-1,(j-1)*10+1); % elemento 1 di pi
	end
	Mtilde = KUKAmodel.inertia(q(i-1,:)); 
    Ctilde = KUKAmodel.coriolis(q(i-1,:),q_dot(i-1,:)); 
    Gtilde = KUKAmodel.gravload(q(i-1,:)); 
	tau(i,:) = qr_ddot(i-1,:)*Mtilde' + qr_dot(i-1,:)*Ctilde' + Gtilde + s*Kd' + e*Kp';
	%% Dinamica del manipolatore (reale)
    % entrano tau, q e q_dot, devo calcolare M, C e G e ricavare q_ddot
    % integro q_ddot due volte e ricavo q e q_dot
    M = KUKA.inertia(q(i-1,:)); 
    C = KUKA.coriolis(q(i-1,:),q_dot(i-1,:)); 
    G = KUKA.gravload(q(i-1,:)); 
    
    q_ddot = (tau(i,:) - q_dot(i-1,:)*C' - G) * (M')^(-1); 
    
    q_dot(i,:) = q_dot(i-1,:) + delta_t*q_ddot; 
    q(i,:) = q(i-1,:) + delta_t*q_dot(i,:);
	 %% Dinamica dei parametri
	q1 = q(i,1); q2 = q(i,2); q3 = q(i,3); q4 = q(i,4); q5 = q(i,5);
	q1_dot = q_dot(i,1); q2_dot = q_dot(i,2); q3_dot = q_dot(i,3); 
	q4_dot = q_dot(i,4); q5_dot = q_dot(i,5);

	qd1_dot = dq_des(i,1); qd2_dot = dq_des(i,2); qd3_dot = dq_des(i,3);
	qd4_dot = dq_des(i,4); qd5_dot = dq_des(i,5);

	qd1_ddot = ddq_des(i,1); qd2_ddot = ddq_des(i,2); qd3_ddot = ddq_des(i,3); 
	qd4_ddot = ddq_des(i,4); qd5_ddot = ddq_des(i,5);
	g = 9.81;

	regressore;
	piArray_dot = (R^(-1) * Y' * s')';  
    piArray(i,:) = piArray(i-1,:) + delta_t*piArray_dot;
	%% Progresso Simulazione
    if mod(i,100) == 0
        
        fprintf('Percent complete: %0.1f%%.',100*i/(length(t)-1));
        hms = fix(mod(toc,[0, 3600, 60])./[3600, 60, 1]);
        fprintf(' Elapsed time: %0.0fh %0.0fm %0.0fs. \n', ...
            hms(1),hms(2),hms(3));
    end
    
end
%% Plot backstepping results for trajectory tracking
%save('backstepping_adaptive','results_backstepping1','results_backstepping2','q_des')
%load('backstepping_adaptive.mat')
% num_of_joints = 5;
% figure
% for j=1:num_of_joints
%     subplot(4,2,j);
%     plot(t(1:10001), q(1:10001,j))
%     hold on
%     plot (t,q_des(j,1:length(t)))
%     legend ('BackStepping_adattivo','Desired angle')
%     grid;
% end
	case 4
%%---------------------COMPUTED_TORQUE_ADAPTIVE---------------------------
%%	Perturbazione iniziale dei parametri
	n = 5;
	int = 2.5; % intensità percentuale della perturbazione sui parametri
	for j = 1:n 
		KUKAmodel.links(j).m = KUKAmodel.links(j).m .* (1+int/100); 
	end
	q_des = q_des';
	dq_des  = dq_des';
	ddq_des = ddq_des';
	q = zeros(length(t),n);
	q_dot = zeros(length(t),n); 
	tau = zeros(length(t),n); 
	piArray = zeros(length(t),n*10); % vettore dei parametri dinamici 
	q0 = [0 pi/2 -pi/2 0 0] + pi/6*[0.3 0.4 0.2 0.8 0] - pi/12; % partiamo in una posizione diversa da quella di inizio traiettoria
	q(1,:) = q0; 
	q_dot(1,:) = q_dot0; 

	qr_dot = zeros(length(t),n); 
	qr_ddot = zeros(length(t),n); 

	pi0 = zeros(1,n*10); 
	for j = 1:n
		pi0((j-1)*10+1:j*10) = [KUKAmodel.links(j).m KUKAmodel.links(j).m*KUKAmodel.links(j).r ...
			KUKAmodel.links(j).I(1,1) 0 0 KUKAmodel.links(j).I(2,2) 0 KUKAmodel.links(j).I(3,3)];
	end
	piArray(1,:) = pi0; 

	Kp = 1*diag([200 200 200 20 10]);
	Kv = 0.1*diag([200 200 200 10 1]); 
% 	Kd = 0.1*diag([200 200 200 20 1]);
 
	% P e R fanno parte della candidata di Lyapunov, quindi devono essere definite positive
	R = diag(repmat([1e1 repmat(1e3,1,3) 1e2 1e7 1e7 1e2 1e7 1e2],1,n)); 
	P = 0.005*eye(10);
	lambda = diag([200, 200, 200, 200, 200])*0.03;
	tic
	for i = 2:length(t)
%% Interruzione della simulazione se q diverge
		if any(isnan(q(i-1,:)))
			fprintf('Simulazione interrotta! \n')
			return
		end
%% Calcolo dell'errore: e, e_dot
		e = q_des(i-1,:) - q(i-1,:); 
		e_dot = dq_des(i-1,:) - q_dot(i-1,:); 
		s = (e_dot + e*lambda);

		qr_dot(i-1,:) = dq_des(i-1,:) + e*lambda;
		if (i > 2)
			qr_ddot(i-1,:) = (qr_dot(i-1) - qr_dot(i-2)) / delta_t;
		end
%% Calcolo della coppia (a partire dal modello)
		for j = 1:n
            KUKAmodel.links(j).m = piArray(i-1,(j-1)*10+1); % elemento 1 di pi
		 end
		Mtilde = KUKAmodel.inertia(q(i-1,:)); 
		Ctilde = KUKAmodel.coriolis(q(i-1,:),q_dot(i-1,:)); 
		Gtilde = KUKAmodel.gravload(q(i-1,:)); 
		tau(i,:) = ddq_des(i-1,:)*Mtilde' + q_dot(i-1,:)*Ctilde' + Gtilde + e_dot*Kv' + e*Kp'; 
%% Dinamica del manipolatore (reale)
		% entrano tau, q e q_dot, devo calcolare M, C e G e ricavare q_ddot
		% integro q_ddot due volte e ricavo q e q_dot
		M = KUKA.inertia(q(i-1,:)); 
		C = KUKA.coriolis(q(i-1,:),q_dot(i-1,:)); 
		G = KUKA.gravload(q(i-1,:)); 

		q_ddot = (tau(i,:) - q_dot(i-1,:)*C' - G) * (M')^(-1); 

		q_dot(i,:) = q_dot(i-1,:) + delta_t*q_ddot; 
		q(i,:) = q(i-1,:) + delta_t*q_dot(i,:); 
%% Dinamica dei parametri
        q1 = q(i,1); q2 = q(i,2); q3 = q(i,3); q4 = q(i,4); q5 = q(i,5);

        q1_dot = q_dot(i,1); q2_dot = q_dot(i,2); q3_dot = q_dot(i,3); 
        q4_dot = q_dot(i,4); q5_dot = q_dot(i,5);

        qd1_dot = dq_des(i,1); qd2_dot = dq_des(i,2); qd3_dot = dq_des(i,3);
        qd4_dot = dq_des(i,4); qd5_dot = dq_des(i,5);

        qd1_ddot = ddq_des(i,1); qd2_ddot = ddq_des(i,2); qd3_ddot = ddq_des(i,3); 
        qd4_ddot = ddq_des(i,4); qd5_ddot = ddq_des(i,5);

        g = 9.81;

        regressore;
		piArray_dot = ( R^(-1) * Y' * (Mtilde')^(-1) * [zeros(n) eye(n)] * P * [e e_dot]' )'; 
        piArray(i,:) = piArray(i-1,:) + delta_t*piArray_dot; 
%% Progresso Simulazione 
		if mod(i,100) == 0
        
        fprintf('Percent complete: %0.1f%%.',100*i/(length(t)-1));
        hms = fix(mod(toc,[0, 3600, 60])./[3600, 60, 1]);
        fprintf(' Elapsed time: %0.0fh %0.0fm %0.0fs. \n', ...
            hms(1),hms(2),hms(3));
		end
	end
end
%% plot
% q = q';
% q_des = q_des';
for j=1:num_of_joints
    subplot(4,2,j);
	
    plot(t(1:10001), q(1:10001,j))
    hold on
	
    plot (t(1:10001), q_des(1:10001,j))
    %plot(t(1:10001), results_backstepping2(1:10001,j))
    %legend ('BackStepping','Desired angle', 'BackStepping with wrong estimation')
    grid;
end

figure
set(gcf,'Position',[300 400 1200 400])
plot(piArray(:,1),'b')
hold on
plot(piArray(:,11),'r')
plot(piArray(:,21),'g')
plot(piArray(:,31),'k')
plot(piArray(:,41),'m')
grid on
xlabel('time [s]')
ylabel('mass [kg]')
legend('link 1','link 2','link 3','link 4','link 5')