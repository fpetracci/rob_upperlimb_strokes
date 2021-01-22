% Angles
figure(2)
clf;
for j=1:num_of_joints
    subplot(3,2,j);
    plot(t(1:length(t)),results.q(j, 1:length(t))*180/pi, 'DisplayName', results.name)
    hold on
    plot(t,q_des(j, 1:length(t))*180/pi, 'DisplayName', 'Desired angle')
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


%% OLD
% switch controller
% 	case 1
% 		% ct
% 		
% 	case 2
% 		% ct_ad
% 		
% 	case 3
% 		% bs
% 		
% 	case 4	
% 		% bs_ad
% 		
% end

%% OLD OLD OLDPlot backstepping results for trajectory tracking
%save('backstepping_adaptive','results_backstepping1','results_backstepping2','q_des')
%load('backstepping_adaptive.mat')

% figure(2)
% clf;
% for j=1:num_of_joints
%     subplot(3,2,j);
%     plot(t(1:length(t)),results_q(j, 1:length(t))*180/pi, 'DisplayName', 'Adaptive BackStepping')
%     hold on
%     plot(t,q_des(j, 1:length(t))*180/pi, 'DisplayName', 'Desired angle')
%     grid on
% 	axis tight
% 	xlabel('Time [s]')
% 	ylabel('Angle [deg]')
% 	legend('Location', 'best')
% 	title(['Joint: ', num2str(j)])
% end
% sgtitle('Adaptive BackStepping')
