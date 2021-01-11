clc; clear all ; close all
%% variabili simboliche
syms x_p y_p theta real
syms x_p0 y_p0 theta0 real
syms t real
syms Tinf real
%% stato del sistema
x = [x_p; y_p; theta];
x_0 = [x_p0; y_p0; theta0];
fprintf('lo stato iniziale considerato è \n:')
x0 = subs(x_0, x_0, [0; 0; 0])
%% sistema dell'uniciclo
fprintf('il sistema è dato da:')
f = [0; 0; 0];
g1 = [cos(theta); sin(theta); 0]
g2 = [0;0;1]
G = [g1 g2];
%% uscite prese in considerazione
fprintf('le uscite del sistema sono :')
y1 = x_p
y2 = y_p
y = [x_p;y_p];
%% calcolo del grado relativo del sistema
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)
% aggiunta di un integratore a monte sulla velocità per ritardarne
% l'effetto
fprintf('Sistema con integratore a monte sulla velocità :')
syms v
x = [x ; v]
fprintf('il sistema aumentato risulta essere:')
f = [cos(theta)*v;...
	 sin(theta)*v;...
		0;...
		0] 
g1 = [0;...
	  0;...
	  0;...
	  1]
g2 = [0;...
	  0;...
	  1;...
	  0]
 G = [g1 g2]
 %% calcolo del grado relativo del sistema aumentato
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)