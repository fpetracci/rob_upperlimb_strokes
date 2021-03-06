clear all
syms x_t x_t_dot y_t y_t_dot theta theta_dot phi phi_dot L L_dot real
g = 9.81;
fprintf('lo stato iniziale considerato è \n:')
L_dot = 0;
x0 = [0; 0; 0; 0; pi/4; pi/20; pi/4; pi/20; 2; 0]
%% grafici sistema
% filename = 'system_model.png';
% filename2 = 'system_state.png';
% y = imread(filename);
% y2 = imread(filename2);
% figure(1)
% imshow(y);
% figure(2)
% imshow(y2);

%% funzioni dinamica
x = [x_t; x_t_dot; y_t; y_t_dot; theta; theta_dot; phi; phi_dot; L ; L_dot]; 
fprintf('il sistema è dato da: \n')

f = [ x_t_dot;...
	  0;...
	  y_t_dot;...
	  0;...
	  theta_dot;...
	  -2*(L_dot/L)*theta_dot+0.5*phi_dot^2*sin(2*theta)-(g/L)*sin(theta);...
	  phi_dot;...
	  -2*(L_dot/L)*phi_dot-2*phi_dot*theta_dot*cot(theta);...
	  ]
g1 = [0;...
	  1;...
	  0;...
	  0;...
	  0;...
	  -cos(theta)*sin(phi)/L;...
	  0;...
	  -cos(phi)/(sin(theta)*L)]
g2 = [0;...
	  0;...
	  0;...
	  1;...
	  0;...
	  -cos(theta)*cos(phi)/L;...
	  0;...
	  sin(phi)/(sin(theta)*L)]
% g3 = [0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  1;...
% 	  0]
G = [g1 g2];
x_ball = x_t + L*sin(theta)*sin(phi)
y_ball = y_t + L*sin(theta)*cos(phi)
y = [x_ball;y_ball];
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)

%% aumentiamo il sistema
syms x_t_ddot
x = [x;...
	 x_t_ddot]
f = [f+g1*x_t_ddot;...
		0]
g1 = [0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  1]
g2 = [g2;...
	   0]
% g3 = [g3;...
% 	   0]
G = [g1 g2];
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)
%% aumentiamo il sistema
syms y_t_ddot
x = [x;...
	 y_t_ddot]
f = [f+g2*y_t_ddot;...
		0]
g1 = [g1;...
	   0]
g2 = [0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  0;...
	  1]
% g3 = [g3;...
% 	   0]
	G = [g1 g2];
[r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)
%%
% syms l_ddot
% x = [x;...
% 	 l_ddot]
% f = [f+g3*y_ddot;...
% 		0]
% g1 = [g1;...
% 	   0]
% g3 = [0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  0;...
% 	  1]
%  g2 = [g2;...
% 		0]
% G = [g1 g2 g3];
% [r_mimo,Lf_full_mimo, T, E] = relative_degree_mimo(f,G,y,x)