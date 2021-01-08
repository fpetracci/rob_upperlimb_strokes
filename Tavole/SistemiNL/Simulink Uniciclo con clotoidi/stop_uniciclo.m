% Questo script plotta alcuni plot interessanti

% stato
time	= out.state_ts.Time;
x_p		= out.state_ts.Data(:,1);
y_p		= out.state_ts.Data(:,2);
theta	= out.state_ts.Data(:,3);
v		= out.state_ts.Data(:,4);
% riferimento
x_rif   = out.rif.Data(:,1);
y_rif   = out.rif.Data(:,2);
% controllo u al sistema NL
v_dot	= out.contr_u.Data(:,1);
w		= out.contr_u.Data(:,2);
% errore
x_e		= out.err.Data(:,1);
y_e		= out.err.Data(:,2);
% coordinata curvilinea
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

%% controllo u linearizzante
figure(4)
clf
title('Controllo u')

subplot(1,2,1)
plot(time, v_dot, 'b')
xlabel('Tempo [s]')
ylabel('accelerazione [m/s^2]')
xlim([0  inf])
ylim([-inf inf])
title('controllo: accelerazione lineare v_{dot}')
grid on

subplot(1,2,2)
plot(time, w, 'r')
xlabel('Tempo [s]')
ylabel('velocità angolare [rad/s]')
xlim([0  inf])
ylim([-inf inf])
title('controllo: velocità angolare \omega')
grid on

%% errori di tracking
figure(5)
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
figure(6)
clf
plot(x_rif, y_rif, 'r--', 'Linewidth', 1.0, 'DisplayName', 'Riferimento' )
hold on

if tipo_perc == 3 %clotoidi
	plot(xp, yp, 'co', 'DisplayName', 'Punti Inseriti')
elseif tipo_perc == 1 %punto
	plot(x_p_finale, y_p_finale, 'co', 'DisplayName', 'Punto finale')
end

plot(x_p_iniziale, y_p_iniziale, 'b*', 'DisplayName', 'Punto Iniziale' )

plot(x_p, y_p, 'b', 'DisplayName', 'Percorso')

title('Mappa')
axis equal
gap = 5;
xlim([min(min(x_p), min(x_rif)) - gap , max(max(x_p), max(x_rif)) + gap ])
ylim([min(min(y_p), min(y_rif)) - gap , max(max(y_p), max(y_rif)) + gap ])
grid on
legend
xlabel('Asse X [m]')
ylabel('Asse Y [m]')

%% mappa animata
if 0
	figure(7)
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
end

