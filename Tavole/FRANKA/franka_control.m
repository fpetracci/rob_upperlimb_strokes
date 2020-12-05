%% Intro

clear all ; clc ;close all
% modello cinematico e generazione traiettoria

mdl_franka 

light_grey	= [0.99, 0.99, 0.99];
black		= [0, 0, 0];


franka.plotopt = {	'workspace',[-1,1,-1,1,0,1.5],...
					'floorlevel',0,...
					'trail','b',...
					'linkcolor',light_grey,...
					'jointcolor',black,...
					'view', [-49.1620,25.8980],...
					'raise'				};


% qualche configurazione iniziale, utile per dopo
qv1 = qv;
qv1(6) = pi/2;

%% Setup e parametri

t_in	= 0;	% [s]
t_fin	= 10;	% [s]
delta_t = 0.1;	% [s]
timeSpan= 10;

% vettore tempo
t = t_in:delta_t:t_fin;

njoints = 7;

Q = zeros(njoints,length(t));
dQ = zeros(njoints,length(t));
ddQ = zeros(njoints,length(t));
TAU = zeros(njoints,length(t));

n_steps = 100;

% posizioni iniziali
pos0 = franka.fkine(qv);
pos1 = franka.fkine(qv1);

% parametri curve
r = 0.1; % raggio del cerchio

%% parto dalla posizione iniziale pos0, raggiungo pos1 

% Per prima cosa vi è la necessità di passare da una configurazione
% iniziale ad una finale, path planning point to point.Per il momento
% lascio jtraj, ma non vi è alcuna menzione del jacobiano. Per questo credo
% sia meglio utilizzare ctraj, in modo da ottenere una traiettoria in cui
% la velocità ha andamento trapezoidale e subito dopo inversione cinematica 
% per ottenere gli angoli di giunto. Si veda libro siciliano pag 168

[q,qd,qdd] = jtraj(qv, qv1, n_steps);

% tc = ctraj(pos0, pos1, n);

franka.plot(q)



%% a seguito del raggiungimento punto pos1 eseguo un cerchio di raggio r
% center = pos1(1:3,4) - [0;0;r];% partendo dal punto pos1 calcolo il cechio nel pianonel piano XZ
% p = zeros(3,size(t,2));
% for i=1:size(t,2)
% 	p(:,i) = center + rotx(t(i)/t(end)*2*pi)*[0;0;r]  ;
% end
% 
% theta = zeros(size(p(1,:)));
% phi =  zeros(size(p(1,:)));
% psi =  zeros(size(p(1,:)));
% xi = [p(1,:);p(2,:);p(3,:); theta; phi; psi]; % twist
% q_des = generate_trajectory(xi,qv1,franka);
% dq_des = gradient(q_des)*1000;
% ddq_des = gradient(dq_des)*1000;
% figure(1) 
% hold on
% plot3(p(1,:),p(2,:),p(3,:))
% franka.plot(q_des','floorlevel',0,'trail','-b','linkcolor',light_grey,'jointcolor',black)

%% a seguito del raggiungimento punto pos1 eseguo una spirale figa di raggio r
center = pos1(1:3,4) - [0;0;r];% partendo dal punto pos1 calcolo il cechio nel pianonel piano XZ
p = zeros(3,size(t,2));
for i=1:size(t,2)
	p(:,i) = center + rotx(t(i)/t(end)*2*pi)*[0;0;r] +[2*r;r;0]*t(i)/t(end)  ;
end

theta = zeros(size(p(1,:)));
phi =  zeros(size(p(1,:)));
psi =  zeros(size(p(1,:)));
xi = [p(1,:);p(2,:);p(3,:); theta; phi; psi]; % pose ee nel tempo
%q_des = generate_trajectory(xi,qv1,franka);
[q_des, dq_des, ddq_des] = ikine_franka(xi,qv1,franka, delta_t);
% dq_des = gradient(q_des)*1000;
% ddq_des = gradient(dq_des)*1000;

figure(1) 
hold on
plot3(p(1,:),p(2,:),p(3,:), ':c')
franka.plot(q_des')

%% clotoide

punto1zy = hgmat2pos(pos1); punto1zy = flip(punto1zy(2:3));

fig2 = figure(2);
clf
hold on
x_shaded = [-0.5 0.5 0.5 -0.5];
y_shaded = [0.5 0.5 1 1];
fill(x_shaded, y_shaded, 'g' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

x_shaded = [-0.5 0.5 0.5 -0.5];
y_shaded = [0 0 0.5 0.5];
fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

x_shaded = [-0.5 0.5 0.5 -0.5];
y_shaded = [1 1 1.2 1.2];
fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

x_shaded = [-0.6 -0.5 -0.5 -0.6];
y_shaded = [0 0 1.2 1.2];
fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

x_shaded = [0.6 0.5 0.5 0.6];
y_shaded = [0 0 1.2 1.2];
fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

xlim([-0.6 0.6]);
ylim([0 1.2]);
xlabel('-Y [m]')
ylabel('Z [m]')
grid on

points_clot = ginput;

% handling ginput_frame to franka globalframe
for i = 1 :size(points_clot,1)
	points_clot(i,:) = [cos(-pi/2) -sin(-pi/2); sin(-pi/2) cos(-pi/2)] * points_clot(i,:)';
end

% gen points on clothoid and path
zy_clot = gen_clot(points_clot);
clot_sizes = size(zy_clot,1);
p_clot = [0.3* ones(clot_sizes,1)';zy_clot(:,2)';zy_clot(:,1)'];

posclot_ini = [pos1(1:3,1:3) , p_clot(:,1); [0 0 0 1] ];
T_appr = ctraj(pos1, posclot_ini, n_steps);	% matrix hom approach al punto 
											% iniziale clotoide
p_appr = hgmat2pos(T_appr);
p = [p_appr, p_clot];

% generating xi
theta	= zeros(size(p(1,:)));
phi		= zeros(size(p(1,:)));
psi		= zeros(size(p(1,:)));

xi		= [p(1,:);p(2,:);p(3,:); theta; phi; psi];

q_des = generate_trajectory(xi,qv1,franka);
dq_des = gradient(q_des)*1000;
ddq_des = gradient(dq_des)*1000;

% figure
fig1 = figure(1);
clf
plot3(p(1,:),p(2,:),p(3,:), ':c')
hold on
axis equal

franka.plot(q_des')

%% modello dinamico
%% scelta della traiettoria, per il momento sarà u
% M = get_MassMatrix([0 0 0 0 0 0 0]);
% G = get_GravityVector([0 0 0 0 0 0 0]);