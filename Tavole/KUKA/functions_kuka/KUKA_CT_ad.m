
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