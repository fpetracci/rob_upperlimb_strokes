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

%% errore di inseguimento

figure(2)
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
figure(3)
clf
plot(x_rif, y_rif, 'r--', 'Linewidth', 1.0, 'DisplayName', 'Riferimento' )
hold on
plot(x_p_iniziale, y_p_iniziale, 'b*', 'DisplayName', 'Punto Iniziale' )
plot(x_p, y_p, 'b', 'DisplayName', 'Percorso')
title('Mappa')
axis equal
xlim([-30 30])
ylim([-30 30])
grid on
legend
xlabel('Asse X [m]')
ylabel('Asse Y [m]')

%% mappa2
