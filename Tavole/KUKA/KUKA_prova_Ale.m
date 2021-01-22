%% Clean ENV

clear all;
close all;
clc;
%% Choose Trajectory

fprintf('Choose trajectory: \n');

fprintf('1: Circumference \n');

fprintf('2: Helix \n');

choiche = input(' ...\n');
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
num_of_joints = size(KUKA.links, 2);

% matrices initialization
Q = zeros(num_of_joints,length(t));
dQ = zeros(num_of_joints,length(t));
ddQ = zeros(num_of_joints,length(t));
TAU = zeros(num_of_joints,length(t));
%% Select Trajectory

switch choiche                  
    case 1 % Circonferenza
        
        q0 = [0 pi/2 pi/2 pi/2 0]';
        q_dot0 = [0 0 0 0 0]';
        
        pos0 = KUKA.fkine(q0');

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
        
        figure(1)
        KUKA.plotopt = {'workspace',[-0.75,0.75,-0.75,0.75,0,1]};
        KUKA.plot(q0')
        hold on
        plot3(x,y,z,'b','Linewidth',1.5)
		title('Desired trajectory: circumference')
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
%% Select controller

fprintf('Choose controller: \n');

fprintf('1: Computed Torque No Adaptive \n');

fprintf('2: Backstepping No Adaptive \n');

fprintf('3: Backstepping Adaptive \n');

fprintf('4: Computed Torque Adaptive \n');
controller = input(' ... \n');
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
Kp = 20*diag([3 3 3 3 5]);
Kv = 10*diag([1 1 1 1 1]);
%% Computed torque with correct estimation
results_computed_torque1 = q0;
index = 1;
q = q0;
dq = q_dot0;
ddq = [0 0 0 0 0]';

for i=1:length(t)
	
   % Error and derivate of the error  
    err = q_des(:,i) - q;
    derr = dq_des(:,i) - dq;
    
%     %Get dynamic matrices
    M = (KUKA.inertia(q'))'; 
    C = (KUKA.coriolis(q', dq'))'; 
    G = (KUKA.gravload(q'))'; 
    
    tau = M*(ddq_des(:,i) + Kv*(derr) + Kp*(err)) + (C*dq) + G;
      
    % Robot joint accelerations
    ddq_old = ddq;
    ddq = pinv(M)*(tau - (C*dq)- G);
        
    % Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
    % Store result for the final plot
    results_computed_torque1(:, index) = q;
    index = index + 1;

end
%% Computed torque with wrong estimation
results_computed_torque2 = q0;
index = 1;
q = q0;
dq = q_dot0;
ddq = [0 0 0 0 0]';
for i=1:length(t)

   % Error and derivate of the error   
    err = q_des(:,i) - q;
    derr = dq_des(:,i) - dq;
    
%     %Get dynamic matrices
    M1 = (KUKAmodel.inertia(q'))'; 
    C1 = (KUKAmodel.coriolis(q',dq'))'; 
    G1 = (KUKAmodel.gravload(q'))'; 
    
    %% Computed Torque Controller with wrong estimation'
    
    tau = M1*(ddq_des(:,i) + Kv*(derr) + Kp*(err)) + (C1*dq) + G1;
      
    % Robot joint accelerations
    ddq_old = ddq;
    ddq = pinv(M)*(tau - (C*dq)- G);
        
    % Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
    % Store result for the final plot
    results_computed_torque2(:, index) = q;
    index = index + 1;

end
%% Plot computed torque results for trajectory tracking
%save('computed_torque_NO_adaptive','results_computed_torque1','results_computed_torque2','q_des')
%load('computed_torque_NO_adaptive.mat')
num_of_joints = size(KUKA.links, 2);

figure(2)
clf;
for j=1:num_of_joints
    subplot(4,2,j);
    plot(t(1:length(t)),results_computed_torque1(j, 1:length(t)), 'DisplayName', 'Computed Torque')
    hold on
    plot (t,q_des(j, 1:length(t)), 'DisplayName', 'Desired angle')
    plot(t(1:length(t)),results_computed_torque2(j, 1:length(t)), 'DisplayName', 'Computed Torque with wrong estimation')
    grid on
	axis tight
	legend
	title(['Joint: ', num2str(j)])
end
sgtitle('Computed torque')

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
% Kp = 0.1*diag([1 1 1 1 1 ]);
%% Trajectory tracking: Backstepping control good parameter estimation
Mat = 0.1*diag([1 1 1 1 1 ]);
results_backstepping1 = q0;
index = 1;
q = q0;
dq = q_dot0;
ddq = [0 0 0 0 0]';
for i=1:length(t)

   % Error and derivate of the error
   
   q_ref = q;
   dq_ref = dq;
   ddq_ref = ddq;
   
   err = q_des(:,i) - q_ref;
   derr = dq_des(:,i) - dq_ref;
    
   dq_ref = dq_des(:,i) + Mat*err;
   ddq_ref = ddq_des(:,i) + Mat*derr;
   % s = dq_ref - dq;
   s = derr + Mat*err;
     
    %Get dynamic matrices
	M = (KUKAmodel.inertia(q'))'; 
    C = (KUKAmodel.coriolis(q',dq'))'; 
    G = (KUKAmodel.gravload(q'))'; 

    % Backstepping Controller
    tau = M*(ddq_ref) + C*(dq_ref) + G + Mat*(s) + err;        
    
    % Robot joint accelerations
    ddq_old = ddq;
    ddq = pinv(M)*(tau - C*dq- G);
        
    % Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
    % Store result for the final plot
    results_backstepping1(:, index) = q;
    index = index + 1;
end
index = 1;
 %% Trajectory tracking: Backstepping control wrong parameter estimation
% Good Circumference parameters
Mat = 0.1* diag([1 5 5 5 1]);

results_backstepping2 = q0;
index = 1;
q = q0;
dq = q_dot0;
ddq = [0 0 0 0 0]';
for i=1:length(t)
	% prima fase: controllo velocità ai giunti dqr
	% Error and derivate of the error   
    
	q_ref = q;
	dq_ref = dq;
	ddq_ref = ddq;
	
	err = q_des(:,i) - q_ref;
    derr = dq_des(:,i) - dq_ref;
    
    dq_ref = dq_des(:,i) + Mat*err;
    ddq_ref = ddq_des(:,i) + Mat*derr;
    s = derr + Mat*err;
  
    %Get dynamic matrices
	M1 = (KUKAmodel.inertia(q'))'; 
    C1 = (KUKAmodel.coriolis(q',dq')'); 
    G1 = (KUKAmodel.gravload(q'))'; 

    % Backstepping Controller
    tau = M1*(ddq_ref) + C1*(dq_ref) + G + Mat*(s) + err;        
    
    % Robot joint accelerations
    ddq_old = ddq;
    ddq = pinv(M)*(tau - C*(dq)- G);
        
    % Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
    % Store result for the final plot
    results_backstepping2(:, index) = q;
    index = index + 1;
end
%% Plot backstepping results for trajectory tracking
%save('backstepping_NO_adaptive','results_backstepping1','results_backstepping2','q_des')
%load('backstepping_NO_adaptive.mat')
num_of_joints = size(KUKA.links, 2);

figure(2)
clf;
for j=1:num_of_joints
    subplot(4,2,j);
    plot(t(1:length(t)),results_backstepping1(j, 1:length(t)), 'DisplayName', 'BackStepping')
    hold on
    plot (t,q_des(j, 1:length(t)), 'DisplayName', 'Desired angle')
    plot(t(1:length(t)),results_backstepping2(j, 1:length(t)), 'DisplayName', 'BackStepping with wrong estimation')
    grid on
	axis tight
	legend
	title(['Joint: ', num2str(j)])
end
sgtitle('BackStepping')
%
KUKA.plot(q_des(:,1:50:end)','trail','black')
	case 3
%% ---------------------BACKSTEPPING_ADAPTIVE------------------------------
%% Perturbazione iniziale dei parametri
% 	q_des = q_des';
% 	dq_des  = dq_des';
% 	ddq_des = ddq_des';

	int = 2.5; % intensità percentuale della perturbazione sui parametri
	n = size(KUKA.links, 2);
	for j = 1:n 
		KUKAmodel.links(j).m = KUKAmodel.links(j).m .* (1+int/100); 
	end
%% Simulazione
% q = zeros(n, length(t)); 
% dq = zeros(n, length(t)); 
results_bs_ad_q = zeros(n, length(t));
results_bs_ad_dq = zeros(n, length(t));
results_bs_ad_ddq = zeros(n, length(t));

tau_save = zeros(n, length(t)); 
piArray = zeros(n*10, length(t)); % vettore dei parametri dinamici 

q0 = ([0 pi/2 -pi/2 0 0] + pi/6*[0.3 0.4 0.2 0.8 0] - pi/12)'; % partiamo in una posizione diversa da quella di inizio traiettoria
q = q0; 
dq = q_dot0; 
ddq = [0 0 0 0 0]';

%dq_ref = zeros(n, length(t)); 
%ddq_ref = zeros(n, length(t)); 

pi0 = zeros(n*10, 1); 
for j = 1:n
    pi0((j-1)*10+1:j*10, 1) = [KUKAmodel.links(j).m KUKAmodel.links(j).m*KUKAmodel.links(j).r ...
        KUKAmodel.links(j).I(1,1) 0 0 KUKAmodel.links(j).I(2,2) 0 KUKAmodel.links(j).I(3,3)]';
end
piArray(:, 1) = pi0; 

Kp = 1*diag([200 200 200 20 10]);
Kv = 0.1*diag([200 200 200 10 1]); 
Kd = 0.1*diag([200 200 200 20 1]);

% P e R fanno parte della candidata di Lyapunov, quindi devono essere definite positive
R = diag(repmat([1e1 repmat(1e3,1,3) 1e2 1e7 1e7 1e2 1e7 1e2],1,n)); 
P = 0.01*eye(10);
lambda = diag([200, 200, 200, 200, 200])*0.03;

index = 1;
tic
for i = 1:length(t)
%% Interruzione della simulazione se q diverge
    if any(isnan(q)) && (i ~= 1)
        fprintf('Simulazione interrotta! \n')
        return
	end
	
%% Calcolo dell'errore: e, e_dot
	
	q_ref = q;
	dq_ref = dq;
	ddq_ref = ddq;

	err = q_des(:, i) - q_ref; 
    derr = dq_des(:, i) - dq_ref; 
    
    dq_ref = dq_des(:, i) + lambda*err;
	ddq_ref = ddq_des(:,i) + lambda*derr;
%     if(i > 1)
%         q_ref_ddot(:, i-1) = (q_ref_dot(:, i-1) - q_ref_dot(:, i-2)) / delta_t;
% 	end
	s = derr + lambda*err;
	
	for j = 1:n 
		KUKAmodel.links(j).m = piArray((j-1)*10+1, i); % elemento 1 di pi
	end
	
	Mtilde = (KUKAmodel.inertia(q'))'; 
    Ctilde = (KUKAmodel.coriolis(q',dq'))'; 
    Gtilde = (KUKAmodel.gravload(q'))'; 
	tau = Mtilde*ddq_ref + Ctilde*dq_ref + Gtilde + Kd*s + Kp*err;
	
%% Dinamica del manipolatore (reale)
    % entrano tau, q e dq, devo calcolare M, C e G e ricavare q_ddot
    % integro q_ddot due volte e ricavo q e dq
    M = (KUKA.inertia(q'))'; 
    C = (KUKA.coriolis(q',dq'))'; 
    G = (KUKA.gravload(q'))'; 
    
	ddq_old = ddq;
    ddq = pinv(M)*(tau - C*dq - G); 
    
	% Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
%     dq(:, i) = dq(:, i-1) + delta_t*ddq; 
%     q(:, i) = q(:, i-1) + delta_t*dq(:, i);
	 
	% Store result for the final plot
    results_bs_ad_q(:, index) = q;
	results_bs_ad_dq(:, index) = dq;
	results_bs_ad_ddq(:, index) = ddq;
	tau_save(:, index)= tau;
    index = index + 1;

%% Dinamica dei parametri

	Y = KUKA_regressor(q, dq, dq_des, ddq_des);
	%Y = KUKA_regressor(q, dq, dq_ref, ddq_ref);
	
	piArray_dot = R^(-1) * Y' * s;
	
	if i<length(t)
		piArray(:, i+1) = piArray(:, i) + delta_t*piArray_dot;
	end
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

figure(2)
clf;
for j=1:num_of_joints
    subplot(3,2,j);
    plot(t(1:length(t)),results_bs_ad_q(j, 1:length(t))*180/pi, 'DisplayName', 'Adaptive BackStepping')
    hold on
    plot(t,q_des(j, 1:length(t))*180/pi, 'DisplayName', 'Desired angle')
    grid on
	axis tight
	xlabel('Time [s]')
	ylabel('Angle [deg]')
	legend('Location', 'best')
	title(['Joint: ', num2str(j)])
end
sgtitle('Adaptive BackStepping')

	case 4
%%---------------------COMPUTED_TORQUE_ADAPTIVE---------------------------
%%	Perturbazione iniziale dei parametri
	n = size(KUKA.links, 2);
	int = 2.5; % intensità percentuale della perturbazione sui parametri
	for j = 1:n 
		KUKAmodel.links(j).m = KUKAmodel.links(j).m .* (1+int/100); 
	end
% 	q_des = q_des';
% 	dq_des  = dq_des';
% 	ddq_des = ddq_des';
	q = zeros(n, length(t));
	dq = zeros(n, length(t)); 
	tau = zeros(n, length(t)); 
	piArray = zeros(length(t),n*10); % vettore dei parametri dinamici 
	q0 = ([0 pi/2 -pi/2 0 0] + pi/6*[0.3 0.4 0.2 0.8 0] - pi/12)'; % partiamo in una posizione diversa da quella di inizio traiettoria
	q(:, 1) = q0; 
	dq(:, 1) = q_dot0; 

	q_ref_dot = zeros(n, length(t)); 
	q_ref_ddot = zeros(n, length(t)); 

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
		if any(isnan(q(:, i-1)))
			fprintf('Simulazione interrotta! \n')
			return
		end
%% Calcolo dell'errore: e, e_dot
		e = q_des(:, i-1) - q(:, i-1); 
		e_dot = dq_des(:, i-1) - dq(:, i-1); 
		s = (e_dot + lambda*e);

		q_ref_dot(:, i-1) = dq_des(:, i-1) + lambda*e;
		if (i > 2)
			q_ref_ddot(:, i-1) = (q_ref_dot(:, i-1) - q_ref_dot(:, i-2)) / delta_t;
		end
%% Calcolo della coppia (a partire dal modello)
		for j = 1:n
            KUKAmodel.links(j).m = piArray(i-1,(j-1)*10+1); % elemento 1 di pi
		 end
		Mtilde = (KUKAmodel.inertia(q(:, i-1)'))'; 
		Ctilde = (KUKAmodel.coriolis(q(:, i-1)',dq(:, i-1)'))'; 
		Gtilde = (KUKAmodel.gravload(q(:, i-1)'))'; 
		tau(:, i) = Mtilde*ddq_des(:, i-1) + Ctilde*dq(:, i-1) + Gtilde + Kv*e_dot + Kp*e; 
%% Dinamica del manipolatore (reale)
		% entrano tau, q e dq, devo calcolare M, C e G e ricavare ddq
		% integro ddq due volte e ricavo q e dq
		M = (KUKA.inertia(q(:, i-1)'))'; 
		C = (KUKA.coriolis(q(:, i-1)',dq(:, i-1)'))'; 
		G = (KUKA.gravload(q(:, i-1)'))'; 

		ddq = pinv(M)*(tau(:, i) - C*dq(:, i-1) - G); 

		dq(:, i) = dq(:, i-1) + delta_t*ddq; 
		q(:, i) = q(:, i-1) + delta_t*dq(:, i); 
%% Dinamica dei parametri
        q1 = q(1, i); q2 = q(2, i); q3 = q(3, i); q4 = q(4, i); q5 = q(5, i);

        q1_dot = dq(1, i); q2_dot = dq(2, i); q3_dot = dq(3, i); 
        q4_dot = dq(4, i); q5_dot = dq(5, i);

        qd1_dot = dq_des(1, i); qd2_dot = dq_des(2, i); qd3_dot = dq_des(3, i);
        qd4_dot = dq_des(4, i); qd5_dot = dq_des(5, i);

        qd1_ddot = ddq_des(1, i); qd2_ddot = ddq_des(2, i); qd3_ddot = ddq_des(3, i); 
        qd4_ddot = ddq_des(4, i); qd5_ddot = ddq_des(5, i);

        g = 9.81;

        regressore;
		% controllo sulla pi
		piArray_dot = R^(-1) * Y' * (Mtilde')^(-1) * [zeros(n); eye(n)] * P * [e; e_dot]; 
        piArray(:, i) = piArray(:, i-1) + delta_t*piArray_dot; 
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