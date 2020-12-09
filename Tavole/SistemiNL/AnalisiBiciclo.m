%% Analisi proprietà uniciclo
syms x y theta 
x = [x y theta];
g1 = [cos(theta); sin(theta); 0];
g2 = [0;0;1];
[Lg1g2] = lie_bracket(g1,g2,x)

[Dfull, Dfull_1] = chow_filtration([g1 g2],[g1 g2],x);%% ha dimensione 3, il che significa che  è accessibile Rivedere


%% Analisi proprietà Biciclo
clear all
syms x_M y_M theta_A theta_P
x = [x_M y_M theta_A theta_P];
Lm = 0.2;
L = 3;
phi = theta_A-theta_P;
g1 = [cos(phi)*cos(theta_P)-(Lm/L)*sin(phi)*sin(theta_P);...
	  cos(phi)*sin(theta_P)+(Lm/L)*sin(phi)*cos(theta_P);...
									0					;...
							(1/L)*sin(phi)					];
g2 = [ 0;...
	   0;...
	   1;...
	   0];
%% studio della raggiungibilità
% Da notare come il sistema del biciclo presenta f(x)=0,
% è espresso nella forma x_dot = g1(x)u1+g2(x)u2
% come prima cosa va applicato il teorema di Chow per verificare la
% s.t.l.a.
% c = subs(g1,theta_A,0);
% c = subs(c,theta_P,0);
[Lg1g2] = lie_bracket(g1,g2,x);
[Dfull, Dfull_1] = chow_filtration([g1 g2],[g1 g2],x);%% sembra avere dimensione 4, il che significa che è accessibile Rivedere
Dfull = subs(Dfull,theta_A,0);
Dfull = subs(Dfull,theta_P,0)
%% studio dell'osservabilità