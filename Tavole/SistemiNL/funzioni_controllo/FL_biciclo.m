%% Analisi proprietà Biciclo
clear all
syms x_M y_M phi theta_P
x = [x_M; y_M; phi; theta_P];
fprintf('lo stato iniziale considerato è \n:')
x0 = [0; 0; 0; 0];
Lm = 0;
L = 3;
fprintf('il sistema è dato da:')
f = [0;...
	 0;...
	 0;...
	 0];
g1 = [cos(theta_P);...
	  sin(theta_P);...
			0	  ;...
	 (1/L)*tan(phi)]
g2 = [ 0;...
	   0;...
	   1;...
	   0]

G = [g1 g2];
y1 = x_M
y2 = y_M
y = [y1;y2];
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)
fprintf('il rango di E è :\n')
rank(E)
%% integratore sulla velocità
fprintf('Sistema con integratore a monte sulla velocità :\n')
syms v_P
x = [x ; v_P]
f = [g1*v_P;...
	   0]
g1 = [0;...
	  0;...
	  0;...
	  0;...
	  1]
g2 = [ 0;...
	   0;...
	   1;...
	   0;...
	   0]
G = [g1 g2];
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x) 
fprintf('il rango di E è :\n')
rank(E)
eq = transpose(x)*G == 0
x_M*cos(theta_P)+y_M*sin(theta_P)
fprintf('cambio rimanente indipendente dalle variabili precedenti e dall''ingresso')
%% integratore theta e velocità
% clearvars -except x f g1 g2 y
% syms omega
% x = [x ; omega]
% f = [f+g2*omega;...
% 		0]
% g1 = [g1;...
% 	   0]
% g2 = [0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  1]
% G = [g1 g2];
% [r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)
%% doppio integratore velocità commentare il blocco precedente
clearvars -except x f g1 g2 y
syms v_P_dot
x = [x ; v_P_dot]
f = [f+g1*v_P_dot;...
	 0]
g1 = [0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  1]
g2 = [ 0;...
	   0;...
	   1;...
	   0;...
	   0;...
	   0]
G = [g1 g2];
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)
clearvars -except T E