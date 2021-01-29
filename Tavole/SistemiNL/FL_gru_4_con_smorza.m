% Questo script analizza il controllo del sistema carroponte e calcola le
% funzioni necessarie per simulare correttamente in ambiente simulink.


%% Intro e Definizioni
clear all
clc

% stato
syms x_t x_t_dot y_t y_t_dot theta theta_dot phi phi_dot L L_dot real
x = [x_t; x_t_dot; y_t; y_t_dot; theta; theta_dot; phi; phi_dot; L ; L_dot];

% parametri
syms  g b real
z_t = 0;

% Stato iniziale Numerico
x0 = [0; 0; 0; 0; pi/4; pi/20; pi/4; pi/20; 2; 0] ;

% posizione palla 
x_ball = x_t + L*sin(theta)*sin(phi);
y_ball = y_t + L*sin(theta)*cos(phi);
z_ball = z_t + L*cos(theta);


%% funzioni dinamica e feedback linearization

% forma affine:
%	x_dot = f(x) + [g1 g2 g3] * [x_t_ddot; y_t_ddot; L_ddot]
%		y = h(x)

% Stato
f = [ x_t_dot;...
	  0;...
	  y_t_dot;...
	  0;...
	  theta_dot;...
	  -2*(L_dot/L)*theta_dot+0.5*phi_dot^2*sin(2*theta)-(g/L)*sin(theta) - b * theta_dot;...
	  phi_dot;...
	  -2*(L_dot/L)*phi_dot-2*phi_dot*theta_dot*cot(theta);...
	  L_dot;...
	  0];
 
% Input
g1 = [0;...
	  1;...
	  0;...
	  0;...
	  0;...
	  -cos(theta)*sin(phi)/L;...
	  0;...
	  -cos(phi)/(sin(theta)*L);...
	  0;...
	  0];
  
g2 = [0;...
	  0;...
	  0;...
	  1;...
	  0;...
	  -cos(theta)*cos(phi)/L;...
	  0;...
	  sin(phi)/(sin(theta)*L);...
	  0;...
	  0];
  
g3 = [0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  1];
G = [g1 g2 g3];

% Uscite 
y = [x_ball - x_t; y_ball - y_t; z_ball-z_t ]; % pos relativa palla


% Altre uscite considerate:
% y = [x_ball;y_ball; z_ball];	% pos assoluta palla
% y = [x_t; y_t; L]				% pos assoluta trailer
% y = [theta;phi;L]				% angoli palla e lunghezza filo
% y = [x_t; y_t; theta;phi;L]	% pos assoluta trailer e angoli

% Funzioni controllo
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x);

%% Cambio variabili
syms xi_1 xi_2 xi_3 xi_4 xi_5 xi_6
xi = [xi_1; xi_2; xi_3;xi_4;xi_5; xi_6];
% lo stato osservabile del sistema linearizzato

syms zeta_1 zeta_2 zeta_3 zeta_4 real
zeta = [zeta_1; zeta_2; zeta_3; zeta_4]; 
% lo stato non osservabile del sistema linearizzato

% con controllo perfetto xi->0
u_zerodin = -inv(E)*T;
u_zerodin_12 = simplify(u_zerodin(1:2,1)); 
% prendo solo: x_t_ddot e y_t_ddot
% L_ddot non entra nel calcolo della dinamica di zeta

PHI = [Lf_full_mimo;x_t;x_t_dot;y_t;y_t_dot];
% PHI = [zeta; xi]
% stato "completo" del sistema linearizzato


% calcolo trasformazione inversa

% calcolo phi, theta ed L da xi_1,xi_3;xi_5 viene abbastanza semplice
phi_zerodin = atan(xi_1/xi_3);
theta_zerodin = atan(xi_3/(xi_5*cos(phi_zerodin)));
L_zerodin = xi_5/cos(theta_zerodin);

% le dot vengono più complicate, ma prendendo i coefficienti che
% moltiplicano le derivate, si può vedere come un sistema lineare, ora
% prendiamo xi_2, xi_4, x_6
% xi_2 = L_dot*sin(phi)*sin(theta) + L*phi_dot*cos(phi)*sin(theta) + L*theta_dot*cos(theta)*sin(phi)
%	   = L_dot*alpha+phi_dot*beta+theta_dot*gamma
% xi_4 = L_dot*cos(phi)*sin(theta) + L*theta_dot*cos(phi)*cos(theta) - L*phi_dot*sin(phi)*sin(theta)
%	   = L_dot*a+phi_dot*b+theta_dot*c
% xi_6 = L_dot*cos(theta) - L*theta_dot*sin(theta)
%	   = L_dot*A+theta_dot*C
% Tale sistema lineare e` costruito in questo modo:
%		[xi_2; xi_4; xi_6] = M * [L_dot; phi_dot; theta_dot]
% e adesso si vuole invertire:
%		[L_dot; phi_dot; theta_dot] = M^-1 * [xi_2; xi_4; xi_6]
%		X = M^-1 * B

M_11 =	sin(phi_zerodin)*sin(theta_zerodin);				% L_dot
M_12 =	L_zerodin*cos(phi_zerodin)*sin(theta_zerodin);		% phi_dot
M_13 =	L_zerodin*cos(theta_zerodin)*sin(phi_zerodin);		% theta_dot
M_21 =	cos(phi_zerodin)*sin(theta_zerodin);				% L_dot		
M_22 =	- L_zerodin*sin(phi_zerodin)*sin(theta_zerodin);	% phi_dot
M_23 =	L_zerodin*cos(phi_zerodin)*cos(theta_zerodin);		% theta_dot	
M_31 =	cos(theta_zerodin);									% L_dot
M_33 =	-L_zerodin*sin(theta_zerodin);						% theta_dot

M = [M_11	M_12	M_13;...
	M_21	M_22	M_23;...
	M_31	0		M_33];

B = [xi_2; xi_4; xi_6]; % termine "noto"



%% ARRIVATI QUI
X = linsolve(M,B);
L_dot = simplify(X(1))
phi_dot = simplify(X(2))
theta_dot = simplify(X(3))
U_1_2 = [-(sin(phi)*(g*sin(theta) + L*b*theta_dot))/cos(theta)...;
		 -(cos(phi)*(g*sin(theta) + L*b*theta_dot))/cos(theta)];
U_1_2 = simplify(U_1_2);
%subs(U_1_2,XI,[0; 0; 0; 0; 0; 0]) error division by zero
 

%% Zero dinamica

syms x_t_ddot y_t_ddot L_ddot
u = [x_t_ddot; y_t_ddot; L_ddot]
upsi = T + E * u
upsi = simplify(upsi,5)

% creazione uspilon ingressi "linearizzati"
ddy1 = L_dot*(phi_dot*cos(phi)*sin(theta) + theta_dot*cos(theta)*sin(phi)) + phi_dot*(L_dot*cos(phi)*sin(theta) + L*theta_dot*cos(phi)*cos(theta) - L*phi_dot*sin(phi)*sin(theta)) + theta_dot*(L_dot*cos(theta)*sin(phi) + L*phi_dot*cos(phi)*cos(theta) - L*theta_dot*sin(phi)*sin(theta)) - L*cos(theta)*sin(phi)*(b*theta_dot - (phi_dot^2*sin(2*theta))/2 + (g*sin(theta))/L + (2*L_dot*theta_dot)/L) - L*cos(phi)*sin(theta)*(2*phi_dot*theta_dot*cot(theta) + (2*L_dot*phi_dot)/L) + ...
		(- cos(phi)^2 - cos(theta)^2*sin(phi)^2) * u(1,:) +...
		(cos(phi)*sin(phi) - cos(phi)*cos(theta)^2*sin(phi)) * u(2,:) + ...
		sin(phi)*sin(theta) * u(3,:);

ddy2 = L_dot*(theta_dot*cos(phi)*cos(theta) - phi_dot*sin(phi)*sin(theta)) - theta_dot*(L*phi_dot*cos(theta)*sin(phi) - L_dot*cos(phi)*cos(theta) + L*theta_dot*cos(phi)*sin(theta)) - phi_dot*(L_dot*sin(phi)*sin(theta) + L*phi_dot*cos(phi)*sin(theta) + L*theta_dot*cos(theta)*sin(phi)) - L*cos(phi)*cos(theta)*(b*theta_dot - (phi_dot^2*sin(2*theta))/2 + (g*sin(theta))/L + (2*L_dot*theta_dot)/L) + L*sin(phi)*sin(theta)*(2*phi_dot*theta_dot*cot(theta) + (2*L_dot*phi_dot)/L)+...
	(cos(phi)*sin(phi) - cos(phi)*cos(theta)^2*sin(phi))* u(1,:) +...
	(- sin(phi)^2 - cos(phi)^2*cos(theta)^2)* u(2,:) + ...
	cos(phi)*sin(theta) * u(3,:);

ddy3 = L*sin(theta)*(b*theta_dot - (phi_dot^2*sin(2*theta))/2 + (g*sin(theta))/L + (2*L_dot*theta_dot)/L) - L_dot*theta_dot*sin(theta) - theta_dot*(L_dot*sin(theta) + L*theta_dot*cos(theta))+...
	cos(theta)*sin(phi)*sin(theta) * u(1,:) + ...
	cos(phi)*cos(theta)*sin(theta) * u(2,:) + ...
	cos(theta) *u(3,:);

% suffisso _lin per cercare retroazione linearizzante
upsi_lin = [ddy1; ddy2; ddy3]
upsi_lin = simplify(upsi_lin,5)
u_lin = -inv(E) * T + inv(E) * upsi_lin;
u_lin = simplify(u_lin,5)

zeta =[x_t; x_t_dot; y_t; y_t_dot]
zeta_dot = [jacobian(x_t,x)*(f + G*u);...
	jacobian(x_t_dot,x)*(f + G*u);...
	jacobian(y_t,x)*(f + G*u);...
	jacobian(y_t_dot,x)*(f + G*u)]

% % zeta_dot_mat = 
PHI_full = jacobian([Lf_full_mimo;zeta],x)
rank(PHI_full)

%
upsi_0	= subs(subs(upsi, x, x0), [b g], [1 9.81])
upsi_00 = eval(subs(upsi_0, u, [0;0;0]))
u_lin0	= eval(subs(subs(-inv(E) * T + inv(E) * upsi_00, x, x0), [b g], [1 9.81]) ) 

