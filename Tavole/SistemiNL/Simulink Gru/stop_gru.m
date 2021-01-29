% Questo script plotta alcuni plot interessanti
%% export set current figure
f_width		= 800;
f_heigth	= 800;
dim_font	= 10;

switch tipo_perc
	case 1
		traj_str = 'Point';
	case 2
		traj_str = 'circle';
	case 3
		traj_str = 'clothoid';
	case 4
		traj_str = 'line';
	case 5
		traj_str = 'sinusoid';
end


%% get signals
%%% stato
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

%%%% esterno
% pos palla
x_b			= out.pos_ball.Data(:,1);
y_b			= out.pos_ball.Data(:,2);
z_b			= out.pos_ball.Data(:,3);

% riferimenti palla
x_b_rif		= out.rif_ball.Data(:,1);
y_b_rif		= out.rif_ball.Data(:,2);
z_b_rif		= out.rif_ball.Data(:,3);

% errore palla
x_b_err		= out.err_ball.Data(:,1);
y_b_err		= out.err_ball.Data(:,2);
z_b_err		= out.err_ball.Data(:,3);

%%%% interno
% pos palla relativa
x_brel		= out.pos_ball_rel.Data(:,1);
y_brel		= out.pos_ball_rel.Data(:,2);
z_brel		= out.pos_ball_rel.Data(:,3);

% riferimenti "interno"
x_brel_rif		= out.rif_interno.Data(:,1);
y_brel_rif		= out.rif_interno.Data(:,2);
z_brel_rif		= out.rif_interno.Data(:,3);
if length(x_brel_rif) == 1
	x_brel_rif		= x_brel_rif(1)*ones(length(time),1);
	y_brel_rif		= y_brel_rif(1)*ones(length(time),1);
	z_brel_rif		= z_brel_rif(1)*ones(length(time),1);
end
% errore interno
x_brel_err		= out.err_interno.Data(:,1);
y_brel_err		= out.err_interno.Data(:,2);
z_brel_err		= out.err_interno.Data(:,3);

%% Riferimenti interni vs uscita interna
figure(2)
clf
subplot(3,1,1)
plot(time, x_brel_rif, 'c--', 'DisplayName', 'ref')
hold on
plot(time, x_brel, 'b-', 'DisplayName', 'real')
xlabel('time [s]')
ylabel('x_b^{rel} [m]')
legend
grid on
axis tight

subplot(3,1,2)
plot(time, y_brel_rif, '--',  'Color', [0.49 1 0.63], 'DisplayName', 'ref')
hold on
plot(time, y_brel, 'g-', 'DisplayName', 'real')
xlabel('time [s]')
ylabel('y_b^{rel} [m]')
legend
grid on
axis tight

subplot(3,1,3)
plot(time, z_brel_rif, 'm--', 'DisplayName', 'ref')
hold on
plot(time, z_b_iniziale-(z_brel-z_b_iniziale), 'r-', 'DisplayName', 'real')
xlabel('time [s]')
ylabel('z_b^{rel} [m]')
legend
grid on
axis tight

sgtitle('Ref vs Real internal loop')

% export
set(gcf, 'Position',  [200, 0, f_width, f_heigth])
set(findall(gcf,'type','text'),'FontSize', dim_font)           
set(gca,'FontSize', dim_font) 
exportgraphics(gcf, ['rif_interni ' traj_str '.pdf'], 'BackgroundColor','none', 'ContentType','vector')

%% Riferimenti esterni vs uscita esterni
figure(3)
clf
subplot(3,1,1)
plot(time, x_b_rif, 'c--', 'DisplayName', 'ref')
hold on
plot(time, x_b, 'b-', 'DisplayName', 'real')
xlabel('time [s]')
ylabel('x_b [m]')
legend
grid on
axis tight

subplot(3,1,2)
plot(time, y_b_rif, '--',  'Color', [0.49 1 0.63], 'DisplayName', 'ref')
hold on
plot(time, y_b, 'g-', 'DisplayName', 'real')
xlabel('time [s]')
ylabel('y_b [m]')
legend
grid on
axis tight

subplot(3,1,3)
plot(time, z_b_rif, 'm--', 'DisplayName', 'ref')
hold on
plot(time, z_b, 'r-', 'DisplayName', 'real')
xlabel('time [s]')
ylabel('z_b [m]')
legend
grid on
axis tight

sgtitle('Ref vs Real External loop')

% export
set(gcf, 'Position',  [200, 0, f_width, f_heigth])
set(findall(gcf,'type','text'),'FontSize', dim_font)           
set(gca,'FontSize', dim_font) 
exportgraphics(gcf, ['rif_esterni ' traj_str '.pdf'], 'BackgroundColor','none', 'ContentType','vector')

%% Video

fr_tot	= 250;
fr_skip = min( ceil( size(time,1)/fr_tot ) , 25);
gru_gen_movie(out, 0, 1, 1, 2, traj_str, [0 0], [45 12], fr_skip)


%% Old
% %% Plot 3D Palla e Carretto 
% figure(1)
% clf
% 
% plot3(x_b, y_b, -z_b, 'ro', 'DisplayName', 'Palla','MarkerFaceColor','r')
% hold on
% plot3(x_t, y_t, -z_t, 'bd', 'DisplayName', 'Trailer')
% % axis equal
% gap = 2;
% xlim([min([min(x_b) min(x_t)])-gap, max([max(x_b) max(x_t)])+gap]);
% ylim([min([min(y_b) min(y_t)])-gap, max([max(y_b) max(y_t)])+gap]);
% zlim([min([min(-z_b) min(-z_t)])-gap, max([max(-z_b) max(-z_t)])+gap]);
% grid on
% xlabel('X')
% ylabel('Y')
% zlabel('-Z')
% title('CLAP CLAP')
% legend
