function [q, q_dot] = ikine_franka(franka, q_0, pose_ee)
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

%% Jacobiano geometrico a partire da Denavit
for i = 1:
q_cc = mean(franka.qlim, 2);	% q centro corsa
J0 = franka.jacob0(q_prev);			% Jacobiano

% jacobiano inverso pesato destro
J0_wr = inv(W)*transpose(J0)*inv(Ja*inv(W)*transpose(J0));

% proiettore al nullo del jacobiano 
P = eye(7)*J0_wr*J0;

%% inversione

% def matrice H(q) per gestione della ridondanza a centro corsa
H = (1/franka.n) * 

q0_dot = zeros(1,7);
q_dot = Ja_wr*vel_ee + P*q0_dot;


