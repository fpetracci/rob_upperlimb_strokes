% Questo script plotta alcuni plot interessanti

time	= out.state_ts.Time;
x_p		= out.state_ts.Data(:,1);
y_p		= out.state_ts.Data(:,2);
theta	= out.state_ts.Data(:,3);
v		= out.state_ts.Data(:,4);
x_rif   = out.rif.Data(:,1);
y_rif   = out.rif.Data(:,2);
x_e		= out.err.Data(:,1);
y_e		= out.err.Data(:,2);
s		= out.curv_coord.Data(:,1);
ds		= out.curv_coord.Data(:,2);
dds		= out.curv_coord.Data(:,3);

%% Uscite
figure(1)
clf
plot(time, x_p, 'r', 'DisplayName', 'x_p')
hold on
plot(time, y_p, 'b', 'DisplayName', 'y_p')
plot(time, x_rif, 'm', 'DisplayName', 'x_{rif}')
plot(time, y_rif, 'c', 'DisplayName', 'y_{rif}')
title('Uscite')
axis tight
grid on
legend
xlabel('Tempo [s]')
ylabel('Uscite [m]')

%% Stato: velocità
figure(2)
clf
plot(time, v, 'b', 'DisplayName', 'velocità')
hold on
plot(time, ds, 'r', 'DisplayName', 'vel lungo la traiettoria')
title('Velocità')
xlim([0  inf])
ylim([0 inf])

grid on
legend
xlabel('Tempo [s]')
ylabel('velocità [m/s]')

%% Stato: Theta
figure(3)
clf
plot(time, theta*180/pi, 'r', 'DisplayName', '\theta')
title('\theta')
axis tight
grid on
legend
xlabel('Tempo [s]')
ylabel('\theta [grad]')

%% errore di inseguimento

figure(4)
clf
plot(time, x_e, 'r', 'DisplayName', 'error_x')
hold on
plot(time, y_e, 'b', 'DisplayName', 'error_y')
title('Errore di tracking')
axis tight
grid on
legend
xlabel('Tempo [s]')
ylabel('Errore [m]')

%% Mappa
figure(5)
clf
plot(x_rif, y_rif, 'r--', 'Linewidth', 1.0, 'DisplayName', 'Riferimento' )
hold on
plot(x_p_iniziale, y_p_iniziale, 'b*', 'DisplayName', 'Punto Iniziale' )
plot(x_p, y_p, 'b', 'DisplayName', 'Percorso')
title('Mappa')
axis equal
% xlim([-30 30])
% ylim([-30 30])
axis tight
grid on
legend
xlabel('Asse X [m]')
ylabel('Asse Y [m]')

%% mappa2
figure(6)
clf

for i=1:10:length(time)
	if i~=1
		delete(freccia);
		delete(p1);
	else
		plot(x_p_iniziale, y_p_iniziale, 'b*', 'DisplayName', 'Punto Iniziale' )
	end
	hold on
	d = abs(v(i));
	x_v = d*cos(theta(i));
	y_v = d*sin(theta(i));
	freccia=quiver(x_p(i), y_p(i), x_v, y_v, 'r');
	p1 = plot(x_p(1:i), y_p(1:i), 'b', 'DisplayName', 'Percorso');
	xlim([min(x_p)-max(v) max(x_p)+max(v)])
	ylim([min(y_p)-max(v) max(y_p)+max(v)])
	grid on
	title(['Animazione, tempo ' num2str(time(i)) ' di ' num2str(time(end))])
	legend
	xlabel('Asse X [m]')
	ylabel('Asse Y [m]')
	
	drawnow
end

