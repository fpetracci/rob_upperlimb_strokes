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
xi = [xi_1; xi_2; xi_3; xi_4; xi_5; xi_6];
% lo stato osservabile del sistema linearizzato

syms zeta_1 zeta_2 zeta_3 zeta_4 real
zeta = [zeta_1; zeta_2; zeta_3; zeta_4]; 
% lo stato non osservabile del sistema linearizzato

% La dinamica di ζ e` data da:
%		ζ_dot = q(ζ, ξ) + p(ζ, ξ)ν
% Ma in ζ_dot compaiono direttamente gli ingressi u dato che:
%		ζ = [x_t; x_t_dot; y_t; y_t_dot]
% e 
%		u = [ x_t_ddot;  y_t_ddot]
%
% Dobbiamo ricavare u(ξ) cosi` da avere tutto in funzione di ξ, ζ

% Partendo da
%		u = −inv(E(x)) Γ(x) + inv(E(x)) ν
% e ponendo ν = 0 ( studiamo solo zero dinamica)

u_zerodin = -inv(E)*T;
u_zerodin_12 = simplify(u_zerodin(1:2,1)); 
% Ci occorre solo: x_t_ddot e y_t_ddot dato che L_ddot non entra nel 
% calcolo della dinamica di zeta

PHI = [Lf_full_mimo;x_t;x_t_dot;y_t;y_t_dot];
% PHI = [xi; zeta]
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

solution = linsolve(M,B);

L_dot_zerodin = simplify(solution(1));
phi_dot_zerodin = simplify(solution(2));
theta_dot_zerodin = simplify(solution(3));

% sanity check
% M*solution = B 

%
%-(sin(phi)*(g*sin(theta) + L*b*theta_dot))/cos(theta)
% -(cos(phi)*(g*sin(theta) + L*b*theta_dot))/cos(theta)
u_zerodin_xi = [	-(sin(phi_zerodin)*(g*sin(theta_zerodin) + L_zerodin*b*theta_dot_zerodin))/cos(theta_zerodin);...
					-(cos(phi_zerodin)*(g*sin(theta_zerodin) + L_zerodin*b*theta_dot_zerodin))/cos(theta_zerodin)];

% error				
% u_zerodin_xi0 = subs(u_zerodin_xi, xi, [0; 0; 0; 0; 0; 0])


%% Prova Con limiti

% j e` una singola variabile che tende a zero. Facciamo convergere a zero
% ogni elemento di xi nello stesso modo di j
syms j real
xi_4lim = subs(xi, xi, [ j; j; j; j; j; j]);

u_zerodin_xi_4lim = subs(u_zerodin_xi, xi, xi_4lim);
% j si semplifica ovunque
u_zerodin_xi0 = limit(u_zerodin_xi_4lim, j, 0) % u(xi=0)

%% Studio della Dinamica di zeta
% in generale
% ζ_dot =  q(ξ; ζ) + p(ξ; ζ) * upsi
zeta_dot = [ 0 1 0 0;...
			0 0 0 0;...
			0 0 0 1;...
			0 0 0 0] * zeta + [0; u_zerodin_xi(1); 0; u_zerodin_xi(2)]

% zeta_dot(xi = 0, zeta)
% ζ_dot = q(0; ζ) sia asintoticamente stabile
zeta_dot0 = subs(zeta_dot, u_zerodin_xi, u_zerodin_xi0);

% A = [ 0 1 0 0;...
% 	0 0 0 0;...
% 	0 0 0 1;...
% 	0 0 0 0];
% forma di jordan, modi propri 1,t quindi instabile polinomialmente.


	