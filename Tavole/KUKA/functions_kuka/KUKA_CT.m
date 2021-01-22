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

disp('Simulation Ended!') 