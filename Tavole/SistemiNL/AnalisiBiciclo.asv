%% Analisi proprietà Biciclo
syms x_M y_M theta_A theta_P
x = [x_M y_M theta_A theta_P];
Lm = 0.2;
L = 3;
phi = theta_A-theta_P;
g1 = [cos(phi)*cos(theta_P)-(Lm/L)*sin(phi)*sin(theta_P);...
	 cos(phi)*sin(theta_P)+(Lm/L)*sin(phi)*cos(theta_P) ;...
									0					;...
							(1/L)*sin(phi)					];
g2 = [ 0;...
	   0;...
	   1;...
	   0];
%% studio della raggiungibilità
% Da notare come il sistema del biciclo presenta f(x)=0
% è espresso nella forma x_dot = g1(x)u1+g2(x)u2
% come prima cosa va applicato il teorema di Chow per verificare la
% s.t.l.a.
[Lg1g2] = lie_bracket(g1,g2,x);
% c = subs(g1,theta_A,0);
% c = subs(c,theta_P,0);
%% studio dell'osservabilità