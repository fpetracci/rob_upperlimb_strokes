%% simple plots
% inverse kinematic- first position in the task
figure(1)
title('inverse kinematic position at t = 1')
arm.plot(q0_ikunc)

% animation of Kalman results (q) about the entire movement

% zeroes joint angles configuration
figure(1)
arm.plot(zeros(1,arm.n))

% number of Kalman iterations for every time step
figure(2)
plot(k_iter, '*')
title('k iterations')

% results in rad (q) of Kalman iterations for every time step
figure(3)
title('q results rad')
plot(q_rad')

% results in grad (q) of Kalman iterations for every time step
figure(3)
title('q results grad')
plot(q_grad')

figure(1)
arm.plot(q_rad')

%% Synchronized plot arm with 

figure(1)
	subplot(1,2,1)
	title('q results animation')
	subplot(1,2,2)
	title('q results grad')
	
	
for i=1:floor(t_tot/3)
	% plot of robotic arm with PC.plot
	subplot(1,2,1)
	arm.plot(q(:,1,i*3)','floorlevel', 0)%mmmmmm?????
	% plot of joint angle
	subplot(1,2,2)
	plot_angle(q_grad,i*3)% if u want rad instead of grad use q_rad
	xlim([0 size(q_grad,2)])
	hold on

end
%% q animation of Kalman evolution inside the specified time step

figure(1)
t_fixed = 175;
q_tfixed = zeros(arm.n, k_iter(t_fixed));
for k_plot = 1:k_iter(t_fixed)
	q_tfixed(:,k_plot) = xCorrected(:,1,t_fixed,k_plot);
end
arm.plot(q_tfixed');
title('q iterations given t - animation')
%% error plot of Kalman evolution inside the specified time step

figure(5)
t_fixed = 80;
e_tfixed = zeros(size(yMeas,1), k_iter(t_fixed));
for k_plot = 1:k_iter(t_fixed)
	e_tfixed(:,k_plot) = e(:,1,t_fixed,k_plot);
end

grid on
plot(e_tfixed')
title('e iterations given t')

% LEGEND TO DO
% yMeas = [	eul_L5_meas;		...
% 			pos_shoulder_meas;	...
% 			eul_shoulder_meas;	...
% 			pos_elbow_meas;		...
% 			eul_elbow_meas;		...
% 			pos_wrist_meas;		...
% 			eul_wrist_meas];
%legend('x elbow','y elbow','z elbow',...
%		'x wrist','y wrist', 'z wrist',...
%		'phi','theta','psi')
%% q animation of Kalman evolution for each time step and every k iteration

figure(1)

t_tot = size(xCorrected,3);
t_start = 165; %aggiustare quando si trasforma in funzione
t_stop = t_tot;

if t_stop > t_tot
	t_stop = t_tot;
end 

fprintf('Animation started! \n');
for tt = t_start:1:t_stop
	t_fixed = tt;
	fprintf('time step is %3.0f \n', tt);
	
	q_tfixed = zeros(arm.n, k_iter(t_fixed));
	for k_plot = 1:k_iter(t_fixed)
		q_tfixed(:,k_plot) = xCorrected(:,1,t_fixed,k_plot);
	end
	arm.plot(q_tfixed');
	title('q iterations given t - animation')

end
fprintf('Animation stopped. \n');
%% check range eul angles
figure(6)
%eul_prova = eul_L5_meas;
%eul_prova = eul_shoulder_meas;
%eul_prova = eul_elbow_meas;
eul_prova = eul_wrist_meas;

prova = reshape(eul_prova, size(eul_prova,1), size(eul_prova,3) );
plot(prova')
title( 'check angles')
%% errors!

for i = 1:t_tot
	yMeas_virt(:,i) = fkine_kalman(q_rad(:,i),arm);
end

%posizione polso misurata
pos_wrist_test = reshape(pos_wrist_meas, size(pos_wrist_meas,1), size(pos_wrist_meas,3), size(pos_wrist_meas,2));
%posizione polso ricostruita
pos_wrist_reconst = yMeas_virt(16:18,:);

%errore posizione polso
err_polso = pos_wrist_reconst - pos_wrist_test(:,1:t_tot);

%
figure(9)
plot(err_polso');

figure(10)
plot(pos_wrist_test'); hold on
plot(pos_wrist_reconst')
hold off

%plot(euler(:,:)')
%title('stimation angle and position')
