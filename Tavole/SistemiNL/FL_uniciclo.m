clc; clear all ; close all
syms x_p y_p theta real
syms x_p0 y_p0 theta0 real
%syms v(t) w(t) real % azioni di controllo
syms t real
syms Tinf real
%global t
%global Tinf
x = [x_p; y_p; theta];
x_0 = [x_p0; y_p0; theta0];
fprintf('lo stato iniziale considerato è \n:')
x0 = subs(x_0, x_0, [0; 0; 0])

lim_inf = x0 - 0.1;
lim_sup = x0 + 0.1;
fprintf('il sistema è dato da:')
f = [0; 0; 0];
g1 = [cos(theta); sin(theta); 0]
g2 = [0;0;1]
G = [g1 g2];
fprintf('le uscite del sistema sono :')
y1 = x_p
y2 = y_p
y = [x_p;y_p];
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)
fprintf('Sistema con integratore a monte sulla velocità :')
syms v
x = [x ; v]

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
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)
