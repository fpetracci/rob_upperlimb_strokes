%% export set current figure
f_width		= 800;
f_heigth	= 800;
dim_font	= 10;

tail_cut = 0;

switch traj_choice
	case 1
		traj_str = 'Point';
	case 2
		traj_str = 'circle';
	case 3
		traj_str = 'clothoid';
end

%% Angles
figure(2)
clf;
for j=1:size(franka.links,2)
    subplot(4,2,j);
    plot(t(1:length(t)-tail_cut),results.q(j, 1:length(t)-tail_cut)*180/pi, 'DisplayName', results.name)
    hold on
    plot(t(1:length(t)-tail_cut), q_des(j, 1:length(t)-tail_cut)*180/pi, 'DisplayName', 'Desired angle')
    grid on
	axis tight
	xlabel('Time [s]')
	ylabel('Angle [deg]')
	legend('Location', 'best')
	title(['Joint: ', num2str(j)])
end
sgtitle(results.name)

set(gcf, 'Position',  [200, 0, f_width, f_heigth])
set(findall(gcf,'type','text'),'FontSize', dim_font)           
set(gca,'FontSize', dim_font) 
exportgraphics(gcf, ['Angles ' results.name ' ' traj_str '.pdf'], 'BackgroundColor','none', 'ContentType','vector')

%% Tau
figure(3)
clf;
for j=1:size(franka.links,2)
    subplot(4,2,j);
    plot(t(1:length(t)-tail_cut),results.tau(j, 1:length(t)-tail_cut)*180/pi, 'DisplayName', results.name)
    hold on
	grid on
	axis tight
	xlabel('Time [s]')
	ylabel('Torque [Nm]')
	legend('Location', 'best')
	title(['Joint: ', num2str(j)])
end
sgtitle(['\tau for ' results.name])

set(gcf, 'Position',  [200, 0, f_width, f_heigth])
set(findall(gcf,'type','text'),'FontSize', dim_font)           
set(gca,'FontSize', dim_font) 
exportgraphics(gcf, ['Tau ' results.name ' ' traj_str '.pdf'], 'BackgroundColor','none', 'ContentType','vector')

%% Video

fr_skip = ceil(length(results.q)/250);
q_plot = results.q(:,1:fr_skip:(length(results.q) - tail_cut));

robot_gen_movie(franka, q_plot, 1, 1, 2, [results.name traj_str], [0,0], [45, 12], 2)

