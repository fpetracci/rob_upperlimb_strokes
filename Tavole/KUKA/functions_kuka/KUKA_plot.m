%% export set current figure
f_width		= 650;
f_heigth	= 650;
dim_font	= 13;
tail_cut	= 0;
% set(gcf, 'Position',  [200, 0, f_width, f_heigth])
% set(findall(gcf,'type','text'),'FontSize', dim_font)           
% set(gca,'FontSize', dim_font) 
% exportgraphics(gcf, [''], 'BackgroundColor','none', 'ContentType','vector')

switch traj_choice
	case 1
		traj_str = 'circum';
	case 2
		traj_str = 'helix';
	case 3
		traj_str = 'exciting_traj';
end

%% Angles
figure(2)
clf;
for j=1:num_of_joints
    subplot(3,2,j);
    plot(t(1:length(t)-tail_cut),results.q(j, 1:length(t)-tail_cut)*180/pi, 'DisplayName', results.name)
    hold on
    plot(t(1:length(t)-tail_cut), q_des(j, 1:length(t)-tail_cut)*180/pi, 'DisplayName', 'Desired angle')
	if isfield(results,'model_wr')
		plot(t(1:length(t)-tail_cut),results.model_wr.q(j, 1:length(t)-tail_cut)*180/pi, 'DisplayName', results.model_wr.name)
	end
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
for j=1:num_of_joints
    subplot(3,2,j);
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

%% Controller adattivi PI
if controller == 2 || controller == 4
	
	% mass
	figure(4)
	clf
	for j=1:num_of_joints
		subplot(3,2,j);
		plot(t(1:length(t)-tail_cut),results.piArray((j-1)*10 + 1, 1 : (end - tail_cut)), 'DisplayName', results.name)
		hold on
		plot(t(1:length(t)-tail_cut),ones(size(t, 2)-tail_cut, 1) * KUKA.links(j).m, 'DisplayName', 'Real Mass')
		grid on
		% xlim([0 t(end)])
		xlabel('Time [s]')
		% ylim([0, Inf])
		ylabel('Mass [kg]')
		axis tight
		legend('Location', 'best')
		title(['Link: ', num2str(j)])
	end
	sgtitle(['Mass Estimation: ', results.name])
	
	set(gcf, 'Position',  [200, 0, f_width, f_heigth])
	set(findall(gcf,'type','text'),'FontSize', dim_font)           
	set(gca,'FontSize', dim_font) 
	exportgraphics(gcf, ['Mass_esti ' results.name ' ' traj_str '.pdf'], 'BackgroundColor','none', 'ContentType','vector')

	
	% inertia
	figure(5)
	clf
	for j=1:num_of_joints
		for ii = 1:3
			i_subplot = (j-1)*3 + (ii);
			subplot(5,3,i_subplot);
			switch ii
				case 1
					ine_pos = 5;
					title_str = 'I_{x,x}';
				case 2
					ine_pos = 8;
					title_str = 'I_{y,y}';
				case 3
					ine_pos = 10;
					title_str = 'I_{z,z}';
			end
			plot(t(1:length(t) - tail_cut),results.piArray((j-1)*10 + ine_pos, (1 : end - tail_cut)), 'DisplayName', results.name)
			hold on
			plot(t(1:length(t) - tail_cut),ones(size(t, 2)-tail_cut, 1) * KUKA.links(j).I(ii,ii), 'DisplayName', 'Real Inertia')
			grid on
			xlim([0 t(end)])
			xlabel('Time [s]')
			ylim([0, Inf])
			ylabel('Inertia [kg m^2]')
			legend('Location', 'best')
			legend('Location', 'best')
			title(['Link: ', num2str(j) title_str])
		end
	end
	sgtitle(['Inertia Estimation' results.name])
	
	set(gcf, 'Position',  [200, 0, f_width, f_heigth])
	set(findall(gcf,'type','text'),'FontSize', dim_font)           
	set(gca,'FontSize', dim_font) 
	exportgraphics(gcf, ['Iner_esti ' results.name ' ' traj_str '.pdf'], 'BackgroundColor','none', 'ContentType','vector')

	
end

%% Video

fr_skip = ceil(length(results.q)/250);
q_plot = results.q(:,1:fr_skip:(length(results.q) - tail_cut));

robot_gen_movie(KUKA, q_plot, 1, 1, 0, [results.name traj_str], [0,0], [-45, 12])

% controller adattivi plotto anche il wrong
if isfield(results,'model_wr')
	q_plot_wr = results.model_wr.q(:,1:fr_skip:length(results.model_wr.q));
	robot_gen_movie(KUKA, q_plot_wr, 1, 1, 0, [results.name ' wrong ' traj_str], [0,0], [-45, 12])
end

