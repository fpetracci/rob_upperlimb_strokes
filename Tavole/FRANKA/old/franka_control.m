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
t_end	= 10;	% [s]
delta_t = 0.001;% [s]
timeSpan= t_end - t_in;

% vettore tempo
%t = t_in:delta_t:t_fin;

njoints = size(franka.links, 2);
n_steps = timeSpan/delta_t;
n_steps_appr = n_steps/100;

% posizioni iniziali
pos1 = franka.fkine(qv1);

% parametri curve
r = 0.1; % raggio del cerchio
%% parto dalla posizione iniziale pos0, raggiungo pos1 

% Per prima cosa vi è la necessità di passare da una configurazione
% iniziale ad una finale, path planning point to point. Per il momento
% lascio jtraj, ma non vi è alcuna menzione del jacobiano. Per questo credo
% sia meglio utilizzare ctraj, in modo da ottenere una traiettoria in cui
% la velocità ha andamento trapezoidale e subito dopo inversione cinematica 
% per ottenere gli angoli di giunto. Si veda libro siciliano pag 168

% [q,qd,qdd] = jtraj(qv, qv1, n_steps);
% 
% % tc = ctraj(pos0, pos1, n);
% 
% franka.plot(q)
% 
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
% q_des = generate_trajectory(xi,qv1,franka, delta_t);
% dq_des = gradient(q_des)*1000;
% ddq_des = gradient(dq_des)*1000;
% figure(1) 
% hold on
% plot3(p(1,:),p(2,:),p(3,:))
% franka.plot(q_des','floorlevel',0,'trail','-b','linkcolor',light_grey,'jointcolor',black)
%% a seguito del raggiungimento punto pos1 eseguo una spirale figa di raggio r
t = t_in:delta_t:t_end;
center = pos1(1:3,4) - [0;0;r];% partendo dal punto pos1 calcolo il cerchio nel pianonel piano XZ
p = zeros(3,size(t,2));
for i=1:size(t,2)
	p(:,i) = center + rotx(t(i)/t(end)*2*pi)*[0;0;r] +[2*r;r;0]*t(i)/t(end)  ;
end

theta = zeros(size(p(1,:)));
phi =  zeros(size(p(1,:)));
psi =  zeros(size(p(1,:)));
xi = [p(1,:);p(2,:);p(3,:); theta; phi; psi]; % pose ee nel tempo
%q_des = generate_trajectory(xi,qv1,franka, delta_t);
[q_des, dq_des, ddq_des] = ikine_franka(xi,qv1,franka, delta_t);
% dq_des = gradient(q_des)*1000;
% ddq_des = gradient(dq_des)*1000;

figure(1) 
hold on
plot3(p(1,:),p(2,:),p(3,:), ':c')
franka.plot(q_des')
%% traiettoria fpc
% if exist('trajectory.mat') ~= 2 % vede se è presente il file mat nel current folder 
% 	[arm_right, traj_real, traj_fpc_1] = gen_path(1);
% 	[~, ~, traj_fpc_2] = gen_path(2);
% 	[~, ~, traj_fpc_3] = gen_path(3);
% 	[~, ~, traj_fpc_4] = gen_path(4);
% else
% 	load trajectory.mat
% end
% trasl = ones(3, 1, length(traj_real));
% traj_real(1:3,4,:) = traj_real(1:3,4,:) + [0.25; 0.2; -0.3].*trasl;% traslazione della traiettoria 
% traj_real = traj_real(:,:,60:220); % selezione dei punti di interesse al movimento
% pos_EE = hgmat2pos(traj_real); %estrapolazione posizione EE dalla matrice di rotoTrasl traj_real
% eul_EE = hgmat2eul(traj_real); %estrapolazione angoli eulero EE dalla matrice di rotoTrasl traj_real,Da rivedere
% pos_res_EE = resample(pos_EE',1000,length(pos_EE));
% pos_res_EE = pos_res_EE(30:900,:);
% % plot(pos_res_EE)
% % hold on
% % plot(pos_EE')
% % eul_res_EE
% %prova
% theta = zeros(1,size(pos_res_EE,1));
% phi =  zeros(1,size(pos_res_EE,1));
% psi = zeros(1,size(pos_res_EE,1));
% %prova2
% %  theta = eul_EE(3,:);
% %  phi = eul_EE(2,:);
% %  psi = eul_EE(1,:);
% p = [pos_EE(1,:);pos_EE(2,:);pos_EE(3,:)]; %a che serve?
% xi_EE =[pos_res_EE';theta;phi;psi];
% 
% traj_init = traj_real(:,:,1);
% % traj_init(1:3,1:3) = rotx(pi)*roty(pi/2);
% qv1 = franka.ikunc(traj_init);
% 
% franka.plot(qv)
% [q_des, dq_des, ddq_des] = ikine_franka(xi_EE, qv1, franka,delta_t);
% plot3(pos_EE(1,:),pos_EE(2,:),pos_EE(3,:), '-k')
% hold on
% franka.plot(q_des')
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
dx = 0.3;
zy_clot = gen_clot(points_clot);
clot_sizes = size(zy_clot,1);

x_clot = 0.3 * ones(1, clot_sizes);
for i = 2:clot_sizes
	x_clot(i) = x_clot(i-1) + dx/(clot_sizes-1);
end

p_clot = [x_clot;zy_clot(:,2)';zy_clot(:,1)'];

posclot_ini = [pos1(1:3,1:3) , p_clot(:,1); [0 0 0 1] ];
T_appr = ctraj(pos1, posclot_ini, n_steps_appr);	% matrix hom approach al punto 
											% iniziale clotoide
p_appr = hgmat2pos(T_appr);
eul_appr = hgmat2eul(T_appr);
p = [p_appr, p_clot];

% generating xi
theta	= zeros(size(p(1,:)));
phi		= zeros(size(p(1,:)));
psi		= zeros(size(p(1,:)));

xi		= [p(1,:);p(2,:);p(3,:); theta; phi; psi];
t_end = size(xi,2)*delta_t;
t = (t_in+delta_t):delta_t:t_end;

[q_des, dq_des, ddq_des] = ikine_franka(xi, qv1, franka, delta_t);
% figure
fig1 = figure(1);
clf
plot3(p(1,:),p(2,:),p(3,:), ':c')
hold on
axis equal
franka.plot(q_des', 'trail', ':b')

% ho ottenuto la traiettoria desiderata da far seguire al Franka, ora devo
% controllarlo in modo tale che la segua davvero
%% modello dinamico
%% Trajectory tracking: Backstepping control
% 
% % Good Circumference parameters
% % Kp = 1* diag([1 1 1 1 3 1 1]);
% Kp = 1* diag([1 1 1 1 1 1 1]);
% % Good Helix parameters
% % Kp = diag([1 1 1 1 3 1 1]);
% 
% results_backstepping = qv1;
% index = 1;
% q = qv1';
% dq = [0 0 0 0 0 0 0]';
% ddq = [0 0 0 0 0 0 0]';
% 
% for i=1:size(q_des,2)
% 	% prima fase: controllo velocità ai giunti dqr
%    % Error and derivate of the error   
%     err = q_des(:,i) - q;
%     derr = dq_des(:,i) - dq;
%     
%     dqr = dq_des(:,i)' + err*(Kp);
%     ddqr = ddq_des(:,i)' + derr*(Kp);
%     s = derr + err*(Kp');
%      
%     %Get dynamic matrices
%     F = get_FrictionTorque(dq);
%     G = get_GravityVector(q);
%     C = get_CoriolisMatrix(q,dq);
%     M = get_MassMatrix(q);
% 
% 
%     % Backstepping Controller
%     tau = (M*(ddqr') + C*(dqr') ...
%         + G + Kp*(s') + err')';      
%     
%     % Robot joint accelerations
%     ddq_old = ddq;
%     ddq = (pinv(M)*(tau - (C*(dq'))'- G')')';
%         
%     % Tustin integration
%     dq_old = dq;
%     dq = dq + (ddq_old + ddq) * delta_t / 2;
%     q = q + (dq + dq_old) * delta_t /2;
%     
%     % Store result for the final plot
%     results_backstepping(index,  :) = q;
%     index = index + 1;
% 
% end
%% again
%Kp = 1* diag([1 1 1 1 1 1 1 ]);
Mat = 1;
% Good Helix parameters
 Kp = diag([1 1 1 1 3 1 1]);

results_backstepping = qv1';
index = 1;
q = qv1';
dq = [0 0 0 0 0 0 0]';
ddq = [0 0 0 0 0 0 0]';

for i=1:size(q_des,2)
	% prima fase: controllo velocità ai giunti dqr
	% Error and derivate of the error 
   
   q_ref = q;
   dq_ref = dq;
   ddq_ref = ddq;
   
   err = q_des(:,i) - q_ref;
   derr = dq_des(:,i) - dq_ref;
    
   dq_ref = dq_des(:,i) + Mat*err;
   ddq_ref = ddq_des(:,i) + Mat*derr;
   % s = dq_ref - dq;
    s = derr + Mat*err;
	
    %Get dynamic matrices
    F = get_FrictionTorque(dq);
    G = get_GravityVector(q);
    C = get_CoriolisMatrix(q,dq);
    M = get_MassMatrix(q);


    % Backstepping Controller
    tau = M*(ddq_ref) + C*(dq_ref) ...
        + G + Kp*(s) + err;      
    
    % Robot joint accelerations
    ddq_old = ddq;
    ddq = pinv(M)*(tau - (C*(dq))- G);
        
    % Tustin integration
    dq_old = dq;
    dq = dq + (ddq_old + ddq) * delta_t / 2;
    q = q + (dq + dq_old) * delta_t /2;
    
    % Store result for the final plot
    results_backstepping(:, index) = q;
    index = index + 1;
end
%%
fig1 = figure(1);
clf
plot3(p(1,:),p(2,:),p(3,:), ':c')
hold on
axis equal
franka.plot(results_backstepping', 'trail', '--r');

figure(2)
clf
franka.plot(results_backstepping(:,3)', 'trail', '--r');

fig3 = figure(3);
subplot(1,2,1)
plot(q_des');
title('desired joint angles');
subplot(1,2,2)
plot(results_backstepping');
title('bs joint angles');


%% Plot computed torque results for backstepping control
figure(3)
clf

for j=1:njoints
    subplot(4,2,j);
	grid on
    plot(results_backstepping(j,:))
    hold on
    plot (q_des(j,:))
	axis tight
%     hold on
%     plot(t,results_computed_torque(:,j))
    
    legend ('Backstepping Results','Desired angle')
end

figure(4)
clf
for j=1:njoints
    subplot(4,2,j);
    plot(t,(q_des(j,:)-results_backstepping(j,:))*180/pi, 'DisplayName', [num2str(j) '-th joint angle error'])
	grid on
	xlim([0, t(end)])
	xlabel('time[s]')
	ylabel('angle error[deg]')
	title([num2str(j) '-th joint angle error'])
end

