%%temp
clear; clc; close
load('healthy.mat');
trial  = healthy_task(7).subject(1).right_side_trial(1);
clear healthy_task;

t = trial.P_Forearm_R;
quat_s = quaternion(trial.P_Shoulder_R_Quat);
quat_u = quaternion(trial.P_Upperarm_R_Quat);
quat_f = quaternion(trial.P_Forearm_R_Quat);
quat_h = quaternion(trial.P_Hand_R_Quat);
for i=1:size(quat_s,1)
	quat_hand(i,1) = quat_s(i) * quat_u(i) * quat_f(i) * quat_h(i);
end

% for i=1:size(t,1)
% 	grid on
% 	axis equal
% 	xlabel('x');    ylabel('y');    zlabel('z');
% 	xlim([-1, 1]);  ylim([-1, 1]); zlim([0, 2]);
% 	plotTransforms(t(i,:), quat_hand(i,:), 'Meshfile', 'mattone.stl')
% 	drawnow()
% end
%rosso X
%verde Y
%blu Z

%% DUBBIO

% se i quaternioni vanno impilati per ottenere la generica matrice di
% trasformazione T0i, per loro, quale segmento ci fornisce 0? Dobbiamo poi
% calcolare tutte le trasformazioni da li` alla mano?



%%
posPlot = t;
quatPlot = quat_hand;

samplePeriod = 1/100;
SamplePlotFreq = 1;
Spin = 120;
SixDofAnimation(posPlot, quat2rotm(quatPlot), ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'All', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 0.1, 'ShowArrowHead', false, ...
                'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));
fprint('niente');


%%
posPlot = trial.P_Neck;
quatPlot = quaternion(trial.P_Neck_Quat);

samplePeriod = 1/100;
SamplePlotFreq = 1;
Spin = 120;
SixDofAnimation(posPlot, quat2rotm(quatPlot), ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'All', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 0.1, 'ShowArrowHead', false, ...
                'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));
fprint('niente');


