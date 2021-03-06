function [q_des, dq_des, ddq_des] = ikine_franka(xi_ee, q_0, franka, dt)
% Inversione della cinematica con Jacobiano pseudoinverso pesato per la
% definizione di una traiettoria desiderata in termini di angoli di giunto

	%% load
	if exist('franka','var')+1 == 1 % exist ritorna 0 nel caso non abbia trovato nulla
		mdl_franka;
	end
	
	%% parametri
	% wi è il peso del giunto i-esimo
	weights = ones(1,7);
	% weights  = {w1, w2, w3, w4, w5, w6, w7};

	% forma matriciale
	W = weights .* eye(7);

	% istanti temporali
	ntime = length(xi_ee);
	xi_dot= gradient(xi_ee)/dt;

	%% Jacobiano geometrico a partire da Denavit
	% Jacobiano
	% J0 = franka.jacob0(q);			

	% jacobiano inverso pesato destro
	% J0_wr = (W)^(-1)*(J0)'*(Ja*(W)^(-1)*(J0)')^(-1);

	% proiettore al nullo del jacobiano 
	% P = eye(7)*J0_wr*J0;

	% calcolo della traiettoria desiderata in termini di velocità ai giunti
	q_dot = zeros(franka.n, ntime);
	q_des = zeros(franka.n, ntime);

	if size(q_0, 1) == franka.n
		q_0 = q_0';
	end
	q_prev = q_0; % vettore riga (jacob0 vuole riga in ingresso)
	
	for i = 1:(length(xi_dot))
		J = franka.jacob0(q_prev);
		Jwr = ((W)^(-1)*J'*(J*(W)^(-1)*J')^(-1));
		P = eye(franka.n) - Jwr * J;

		q_dot(:,i) = Jwr * xi_dot(:,i) + P * gradH(q_prev);
		q_des(:, i) = q_prev' + q_dot(:,i)*dt;
		q_prev = q_des(:, i)';
	end
	
	dq_des = q_dot;
    ddq_des = gradient(dq_des)/dt;
end

%% gradH
function out = gradH(q)
	
%{ 
	q1 = sym('q1');
	q2 = sym('q2');
	q3 = sym('q3');
	q4 = sym('q4');
	q5 = sym('q5');
	q6 = sym('q6');
	q7 = sym('q7');

	q = [q1; q2; q3; q4; q5; q6; q7];

	% matrice H(q) per gestione della ridondanza a centro corsa

	q_cc = mean(franka.qlim, 2);	% q centro corsa
	q_range = franka.qlim(:,2) - franka.qlim(:,1);

	q_diff = (q - q_cc);
	tmp = (q_diff./q_range).^2;
	H = (1/franka.n) * sum(tmp, 1);
	dH(1, 1) = diff(H, q1);
	dH(2, 1) = diff(H, q2);
	dH(3, 1) = diff(H, q3);
	dH(4, 1) = diff(H, q4);
	dH(5, 1) = diff(H, q5);
	dH(6, 1) = diff(H, q6);
	dH(7, 1) = diff(H, q7);
%}

 q1 = q(1);
 q2 = q(2);
 q3 = q(3);
 q4 = q(4);
 q5 = q(5);
 q6 = q(6);
 q7 = q(7);
 
 out=[(50000000 * q1) / 5876043103;...
      (3125000 * q2) / 135951543;...
      (50000000 * q3) / 5876043103;...
	  (500000 * q4) / 15771007 + 112200 / 2253001;...
      (50000000 * q5) / 5876043103;...
      (20000 * q6) / 994903 - 37350 / 994903;...
      (50000000 * q7) / 5876043103];
end
