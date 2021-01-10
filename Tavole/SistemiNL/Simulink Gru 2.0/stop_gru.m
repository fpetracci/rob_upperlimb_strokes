% Questo script plotta alcuni plot interessanti

%% get signals
% stato
time		= out.state_ts.Time;
x_t			= out.state_ts.Data(:,1);
x_t_dot		= out.state_ts.Data(:,2);
y_t			= out.state_ts.Data(:,3);
y_t_dot		= out.state_ts.Data(:,4);
theta		= out.state_ts.Data(:,5);		% uscita(1)
theta_dot	= out.state_ts.Data(:,6);
phi			= out.state_ts.Data(:,7);		% uscita(2)
phi_dot		= out.state_ts.Data(:,8);
L			= out.state_ts.Data(:,9);		% uscita(3)
L_dot		= out.state_ts.Data(:,10);		
z_t			= z_t(1)*ones(length(time),1);

% pos palla
x_b			= out.pos_ball.Data(:,1);
y_b			= out.pos_ball.Data(:,2);
z_b			= out.pos_ball.Data(:,3);

% riferimenti "interno"
theta_rif   = out.rif_interno.Data(:,1);
phi_rif		= out.rif_interno.Data(:,2);
L_rif		= out.rif_interno.Data(:,3);
if length(theta_rif) == 1
	theta_rif	= theta_rif(1)*ones(length(time),1);
	phi_rif		= phi_rif(1)*ones(length(time),1);
	L_rif		= L_rif(1)*ones(length(time),1);
end

% errore "interno"
theta_err   = out.err_interno.Data(:,1);
phi_err		= out.err_interno.Data(:,2);
L_err		= out.err_interno.Data(:,3);

% riferimenti palla
x_b_rif		= out.rif_ball.Data(:,1);
y_b_rif		= out.rif_ball.Data(:,2);
z_b_rif		= out.rif_ball.Data(:,3);

% errore palla
x_b_err		= out.err_ball.Data(:,1);
y_b_err		= out.err_ball.Data(:,2);
z_b_err		= out.err_ball.Data(:,3);

%% Plot 3D Palla e Carretto 
figure(1)
clf

plot3(x_b, y_b, -z_b, 'ro', 'DisplayName', 'Palla','MarkerFaceColor','r')
hold on
plot3(x_t, y_t, -z_t, 'bd', 'DisplayName', 'Carretto')
% axis equal
gap = 2;
xlim([min([min(x_b) min(x_t)])-gap, max([max(x_b) max(x_t)])+gap]);
ylim([min([min(y_b) min(y_t)])-gap, max([max(y_b) max(y_t)])+gap]);
zlim([min([min(-z_b) min(-z_t)])-gap, max([max(-z_b) max(-z_t)])+gap]);
grid on
xlabel('X')
ylabel('Y')
zlabel('-Z')
title('CLAP CLAP')
legend

%% Riferimenti interni vs uscita interna
figure(2)
clf
subplot(1,3,1)
plot(time, theta_rif.*180/pi, 'c--', 'DisplayName', '\theta_{rif}')
hold on
plot(time, theta*180/pi, 'b-', 'DisplayName', '\theta')
xlabel('time [s]')
ylabel('\theta [deg]')
title('\theta vs rif')
legend
grid on
axis tight

subplot(1,3,2)
plot(time, phi_rif*180/pi, '--',  'Color', [0.49 1 0.63], 'DisplayName', '\phi_{rif}')
hold on
plot(time, phi*180/pi, 'g-', 'DisplayName', '\phi')
xlabel('time [s]')
ylabel('\phi [deg]')
title('\phi vs rif')
legend
grid on
axis tight

subplot(1,3,3)
plot(time, L_rif, 'm--', 'DisplayName', 'L_{rif}')
hold on
plot(time, L, 'r-', 'DisplayName', 'L')
xlabel('time [s]')
ylabel('L [m]')
title('L vs rif')
legend
grid on
axis tight
