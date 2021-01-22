%% ---------------------COMPUTED TORQUE------------------------
%% Init per simulazione

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

% code stuff
index = 1;

% Gain circumference parameters matrix
Kp = 20*diag([3 3 3 3 5]);
Kv = 10*diag([1 1 1 1 1]);

%% Simulazione
tic

for i=1:length(t)
	% Interruzione della simulazione se q diverge
	if any(isnan(q)) && (i ~= 1)
	   fprintf('Simulazione interrupted! \n')
	   return
	end

	% Error and derivate of the error  
	err = q_des(:, i) - q;
	derr = dq_des(:, i) - dq;
   
	%Get dynamic matrices
	M = (KUKA.inertia(q'))'; 
	C = (KUKA.coriolis(q', dq'))'; 
	G = (KUKA.gravload(q'))'; 
    
    tau = M*(ddq_des(:, i) + Kv*(derr) + Kp*(err)) + (C*dq) + G;
      
    % Robot joint accelerations
    ddq_old = ddq;
    ddq = pinv(M)*(tau - (C*dq)- G);
        
    % Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
    % Store result for the final plot
	results_q(:, index) = q;
	results_dq(:, index) = dq;
	results_ddq(:, index) = ddq;
	tau_save(:, index)= tau;
    index = index + 1;
	
	%% Progresso Simulazione
    if mod(i,100) == 0
        
        fprintf('Percent complete: %0.1f%%.',100*i/(length(t)-1));
        hms = fix(mod(toc,[0, 3600, 60])./[3600, 60, 1]);
        fprintf(' Elapsed time: %0.0fh %0.0fm %0.0fs. \n', ...
            hms(1),hms(2),hms(3));
	end
	
end

%% Export structure

if ~exist('results', 'var')
	results = struct();
end
	results.q		= results_q;
	results.dq		= results_dq;
	results.ddq		= results_ddq;
	results.tau		= tau_save;
	results.name	= 'Computed Torque';
