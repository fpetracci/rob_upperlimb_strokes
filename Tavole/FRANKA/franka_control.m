clear all ; clc ;close all
%modello cinematico e generazione traiettoria

mdl_franka 

white = [1, 1, 1];
black = [0, 0, 0];
qv1 = qv;
qv1(6) = pi/2;
franka.plotopt = {'workspace',[-0.75,0.75,-0.75,0.75,0,1]};
franka.plot(qv1,'floorlevel',0,'linkcolor',white,'jointcolor',black)
%% Setup
t_in = 0; % [s]
t_fin = 10; % [s]
delta_t = 0.1; % [s]
timeSpan= 10;

t = t_in:delta_t:t_fin;

num_of_joints = 7;

Q = zeros(num_of_joints,length(t));
dQ = zeros(num_of_joints,length(t));
ddQ = zeros(num_of_joints,length(t));
TAU = zeros(num_of_joints,length(t));

%% parto dalla posizione iniziale pos0, raggiungo pos1 
n = 100;
pos0 = franka.fkine(qv);
pos1 = franka.fkine(qv1);
% Per prima cosa vi è la necessità di passare da una configurazione
% iniziale ad una finale, path planning point to point.Per il momento
% lascio jtraj, ma non vi è alcuna menzione del jacobiano. Per questo credo
% sia meglio utilizzare ctraj, in modo da ottenere una traiettoria in cui
% la velocità ha andamento trapezoidale e subito dopo inversione cinematica 
% per ottenere gli angoli di giunot. Si veda libro siciliano pag 168
 [q,qd,qdd] = jtraj(qv, qv1, n);
% tc = ctraj(pos0, pos1, n);
r = 0.1; % raggio del cerchio 
for i=1:n
	franka.plot(q(i,:),'floorlevel',0,'linkcolor',white,'jointcolor',black)
end
%% a seguito del raggiungimento punto pos1 eseguo un cerchio di raggio r
center = pos1(1:3,4) - [r;0;0];% partendo dal punto pos1 calcolo il cechio nel pianonel piano XZ
x = center(1) + r * cos(t/t(end)*2*pi);
y = center(2) * ones(size(x));
z = center(3) + r * sin(t/t(end)*2*pi);
theta = 0.1*sin(t/3*2*pi);
phi = zeros(size(x));
psi = zeros(size(x));
xi = [x; y; z; theta; phi; psi]; % twist
q_des = generate_trajectory(xi,qv1,franka);
dq_des = gradient(q_des)*1000;
ddq_des = gradient(dq_des)*1000;
for i=1:length(t)
	franka.plot(q_des(:,i)','floorlevel',0,'linkcolor',white,'jointcolor',black)
	hold on
	plot3(x,y,z,'k','Linewidth',1.5)
end
%% modello dinamico
%% scelta della traiettoria, per il momento sarà u
M = get_MassMatrix([0 0 0 0 0 0 0]);
G = get_GravityVector([0 0 0 0 0 0 0]);