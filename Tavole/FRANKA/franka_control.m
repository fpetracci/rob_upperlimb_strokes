clear all ; clc ;close all
% modello cinematico e generazione traiettoria

mdl_franka 

light_grey = [0.99, 0.99, 0.99];
black = [0, 0, 0];
qv1 = qv;
qv1(6) = pi/2;

figure(1)

franka.plotopt = {'workspace',[-0.75,0.75,-0.75,0.75,0,1]};
% lims  plot
xlim([-1 1])
ylim([-1 1])
zlim([0 2])
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
view(30,30)
   
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
% per ottenere gli angoli di giunto. Si veda libro siciliano pag 168
 [q,qd,qdd] = jtraj(qv, qv1, n);
% tc = ctraj(pos0, pos1, n);
r = 0.1; % raggio del cerchio
franka.plot(q,'floorlevel',0,'trail','-r','linkcolor',light_grey,'jointcolor',black)
xlim([-1 1])
ylim([-1 1])
zlim([0 2])
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
view(30,30)

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
plot3(p(1,:),p(2,:),p(3,:))
franka.plot(q_des','floorlevel',0,'trail','-b','linkcolor',light_grey,'jointcolor',black)


%% clotoide

punto1zy = hgmat2pos(pos1); punto1zy = flip(punto1zy(2:3));

% points_clot = [	punto1zy(1), 0; ...
% 				punto1zy(1), punto1zy(2)+0.05; ...
% 				punto1zy(1)-0.05, punto1zy(2)+0.05; ...
% 				punto1zy(1)-0.05, punto1zy(2) ];
% points_clot = [	1, 1; ...
% 				1, 5; ...
% 				5, 5; ...
% 				7, 1 ];
			
fig2 = figure(2);
clf
plot(punto1zy, 'ko')
offset = 0.5;
xlim([punto1zy(1)-offset punto1zy(1)+offset]);
ylim([punto1zy(1)-offset punto1zy(1)+offset]);
grid on
daspect([1 1 1])
points_clot = ginput;

% points_clot = [ 1 1; 1 5; 5 5; 7 1];

zy_clot = gen_clot(points_clot);

clot_sizes = size(zy_clot,1);
theta = zeros(clot_sizes,1)';
phi =  zeros(clot_sizes,1)';
psi =  zeros(clot_sizes,1)';

p = [0.2* ones(clot_sizes,1)';zy_clot(:,2)';zy_clot(:,1)'];

xi = [p(1,:);p(2,:);p(3,:); theta; phi; psi]; % twist

q_des = generate_trajectory(xi,qv1,franka);
dq_des = gradient(q_des)*1000;
ddq_des = gradient(dq_des)*1000;

figure(1) 
hold on
plot3(p(1,:),p(2,:),p(3,:))
franka.plot(q_des','floorlevel',0,'trail','-b','linkcolor',light_grey,'jointcolor',black)


%% modello dinamico
%% scelta della traiettoria, per il momento sarà u
% M = get_MassMatrix([0 0 0 0 0 0 0]);
% G = get_GravityVector([0 0 0 0 0 0 0]);