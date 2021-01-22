% Angles
figure(2)
clf;
for j=1:num_of_joints
    subplot(3,2,j);
    plot(t(1:length(t)),results.q(j, 1:length(t))*180/pi, 'DisplayName', results.name)
    hold on
    plot(t,q_des(j, 1:length(t))*180/pi, 'DisplayName', 'Desired angle')
	if isfield(results,'model_wr')
		plot(t(1:length(t)),results.model_wr.q(j, 1:length(t))*180/pi, 'DisplayName', results.model_wr.name)
	end
    grid on
	axis tight
	xlabel('Time [s]')
	ylabel('Angle [deg]')
	legend('Location', 'best')
	title(['Joint: ', num2str(j)])
end
sgtitle(results.name)

% Tau
figure(3)
clf;
for j=1:num_of_joints
    subplot(3,2,j);
    plot(t(1:length(t)),results.tau(j, 1:length(t))*180/pi, 'DisplayName', results.name)
    hold on
	grid on
	axis tight
	xlabel('Time [s]')
	ylabel('Torque [Nm]')
	legend('Location', 'best')
	title(['Joint: ', num2str(j)])
end
sgtitle(['\tau for ' results.name])

% Controller adattivi PI
if controller == 2 || controller == 4
	
	% mass
	figure(4)
	clf
	for j=1:num_of_joints
		subplot(3,2,j);
		plot(t(1:length(t)),results.piArray((j-1)*10 + 1, :), 'DisplayName', results.name)
		hold on
		plot(t(1:length(t)),ones(size(t)) * KUKA.links(j).m, 'DisplayName', 'Real Mass')
		grid on
		xlim([0 t(end)])
		xlabel('Time [s]')
		ylim([0, Inf])
		ylabel('Mass [kg]')
		legend('Location', 'best')
		legend('Location', 'best')
		title(['Link: ', num2str(j)])
	end
	sgtitle(['Mass Estimation: ', num2str(j)])
	
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
			plot(t(1:length(t)),results.piArray((j-1)*10 + ine_pos, :), 'DisplayName', results.name)
			hold on
			plot(t(1:length(t)),ones(size(t)) * KUKA.links(j).I(ii,ii), 'DisplayName', 'Real Inertia')
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
	sgtitle('Inertia Estimation')
	
end


%% Video