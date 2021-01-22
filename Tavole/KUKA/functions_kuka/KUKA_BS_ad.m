%% ---------------------BACKSTEPPING_ADAPTIVE------------------------------
%% Init per simulazione adaptive

% joints
n = size(KUKA.links, 2);			% number of joints
results_q = zeros(n, length(t));	% angles for export
results_dq = zeros(n, length(t));	% dangles for export
results_ddq = zeros(n, length(t));	% ddangles for export
q0 = [pi/6 pi/2 pi/3 pi/2 pi/4]';	% initial pose
q = q0;								% joint angle vector	
dq = q_dot0;						% joint dangle vector
ddq = [0 0 0 0 0]';					% joint ddangle vector

% tau
tau_save = zeros(n, length(t));		% torques vector for export
soglia_sat = Inf;					% soglia di saturazione (Inf, no sat)

% pi vettore dei parametri dinamici 
piArray = zeros(n*10, length(t)); 
	% each column of pi contains for all joints:
	% 1.	mass
	% 2.	mass * x of Center Of Gravity
	% 3.	mass * y of Center Of Gravity
	% 4.	mass * z of Center Of Gravity
	% 5.	Element 1,1, inertial tensor
	% 6.	?
	% 7.	?
	% 8.	Element 2,2, inertial tensor
	% 9.	?
	% 10.	Element 2,3, inertial tensor

pi0 = zeros(n*10, 1); % starting dynamic parameters vector
for j = 1:n
	pi0((j-1)*10+1:j*10, 1) = [KUKAmodel.links(j).m KUKAmodel.links(j).m*KUKAmodel.links(j).r ...
        KUKAmodel.links(j).I(1,1) 0 0 KUKAmodel.links(j).I(2,2) 0 KUKAmodel.links(j).I(3,3)]';
end
piArray(:, 1) = pi0; 

% gains
Kp = 1*diag([200 200 200 20 10]);
Kv = 0.1*diag([200 200 200 10 1]); 
Kd = 0.1*diag([200 200 200 20 1]);
% P e R fanno parte della candidata di Lyapunov, quindi devono essere definite positive
R = diag(repmat([1e1 repmat(1e3,1,3) 1e2 1e7 1e7 1e2 1e7 1e2],1,n)); 
P = 0.01*eye(10);
% lambda = diag([200, 200, 200, 200, 200])*0.005; %0.03
lambda = diag([5 0.8 0.5 0.3 0.3]);

% code stuff
index = 1;

%% Simulazione adaptive
tic
for i = 1:length(t)
	% Interruzione della simulazione se q diverge
    if any(isnan(q)) && (i ~= 1)
        fprintf('Simulazione interrupted! \n')
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
	s = derr + lambda*err;
	
	%% update KUKAmodel and get robotic matrices
	for j = 1:n
		% link mass
		KUKAmodel.links(j).m = piArray((j-1)*10+1, i); % elemento 1 di pi
		
		% link inertia
		KUKAmodel.links(1).I = diag([	piArray((j-1)*10+5, i), ...
										piArray((j-1)*10+8, i), ...
										piArray((j-1)*10+10, i) ]);
	end
	
	Mtilde = (KUKAmodel.inertia(q'))'; 
    Ctilde = (KUKAmodel.coriolis(q',dq'))'; 
    Gtilde = (KUKAmodel.gravload(q'))'; 
	tau = Mtilde*ddq_ref + Ctilde*dq_ref + Gtilde + Kd*s + Kp*err;
	
% 	% saturazione tau
	for j = 1:n
		if tau(j) > soglia_sat
			tau(j) = soglia_sat;
		elseif tau(j) < -soglia_sat
			tau(j) = -soglia_sat;
		end
	end
	
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
    
	%% store result for the final plot
    results_q(:, index) = q;
	results_dq(:, index) = dq;
	results_ddq(:, index) = ddq;
	tau_save(:, index)= tau;
    index = index + 1;

	%% Dinamica dei parametri
% 	Y = KUKA_regressor(q, dq, dq_des(:,i), ddq_des(:,i));
	Y = KUKA_regressor(q, dq, dq_ref, ddq_ref);
	
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

%% Init Simulazione "Sbagliata" _wr

% joints
results_q_wr = zeros(n, length(t));	% angles for export
results_dq_wr = zeros(n, length(t));	% dangles for export
results_ddq_wr = zeros(n, length(t));	% ddangles for export
q0 = [pi/6 pi/2 pi/3 pi/2 pi/4]';	% initial pose
q = q0;								% joint angle vector	
dq = q_dot0;						% joint dangle vector
ddq = [0 0 0 0 0]';					% joint ddangle vector

% tau
tau_save_wr = zeros(n, length(t));		% torques vector for export


% gains
lambda = diag([5 0.8 0.5 0.3 0.3]);

% code stuff
index = 1;

 %% Simulazione "Sbagliata" _wr
tic
for i=1:length(t)
	% Interruzione della simulazione se q diverge
    if any(isnan(q)) && (i ~= 1)
        fprintf('Simulazione interrupted! \n')
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
	s = derr + lambda*err;

	%% Dinamica del manipolatore
    % entrano tau, q e dq, devo calcolare M, C e G e ricavare q_ddot
    % integro q_ddot due volte e ricavo q e dq
	M = (KUKA.inertia(q'))'; 
	C = (KUKA.coriolis(q',dq'))'; 
	G = (KUKA.gravload(q'))'; 

	% Backstepping Controller
	tau = M*(ddq_ref) + C*(dq_ref) + G + lambda*(s) + err;        
% 	% saturazione tau
	for j = 1:n
		if tau(j) > soglia_sat
			tau(j) = soglia_sat;
		elseif tau(j) < -soglia_sat
			tau(j) = -soglia_sat;
		end
	end
	
	% Real model accelerations
	ddq_old = ddq;
	M = (KUKAmodel.inertia(q'))'; 
	C = (KUKAmodel.coriolis(q',dq'))'; 
	G = (KUKAmodel.gravload(q'))'; 
	ddq = pinv(M)*(tau - C*dq- G);

	% Tustin integration
	dq_old = dq;
	dq = dq + (ddq_old + ddq) * delta_t / 2;
	q = q + (dq + dq_old) * delta_t /2;

	%% store result for the final plot
    results_q_wr(:, index) = q;
	results_dq_wr(:, index) = dq;
	results_ddq_wr(:, index) = ddq;
	tau_save_wr(:, index)= tau;
    index = index + 1;
	
	%% Progresso Simulazione
    if mod(i,100) == 0
        
        fprintf('Percent complete: %0.1f%%.',100*i/(length(t)-1));
        hms = fix(mod(toc,[0, 3600, 60])./[3600, 60, 1]);
        fprintf(' Elapsed time: %0.0fh %0.0fm %0.0fs. \n', ...
            hms(1),hms(2),hms(3));
	end
end


%% Export for plots

if ~exist('results', 'var')
	results = struct();
end
results.q		= results_q;
results.dq		= results_dq;
results.ddq		= results_ddq;
results.tau		= tau_save;
results.piArray = piArray;
results.name	= 'Adaptive BackStepping';

results.model_wr		= struct();
results.model_wr.q		= results_q_wr;
results.model_wr.dq		= results_dq_wr;
results.model_wr.ddq	= results_ddq_wr;
results.model_wr.tau	= tau_save_wr;
results.model_wr.name	= 'BackStepping Wrong Model';
