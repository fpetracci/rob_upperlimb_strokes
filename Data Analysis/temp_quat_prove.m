%%temp
clear; clc; close
load('healthy.mat');
trial  = healthy_task(7).subject(1).right_side_trial(1);
clear healthy_task;

t = trial.Forearm_R.Pos;
quat_s = quaternion(trial.Shoulder_R.Quat);
quat_u = quaternion(trial.Upperarm_R.Quat);
quat_f = quaternion(trial.Forearm_R.Quat);
quat_h = quaternion(trial.Hand_R.Quat);
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
posPlot = trial.Hand_L.Pos;
quatPlot = quaternion(trial.Hand_L.Quat);

samplePeriod = 1/100;
SamplePlotFreq = 1;
Spin = 120;
rotPlot = zeros(3, 3, size(posPlot,1));
for i= 1:size(posPlot,1)
	rotPlot(:,:,i) = roty(-pi/2)*rotx(-pi/2)*quat2rotm(quatPlot(i));
end


SixDofAnimation(posPlot, rotPlot, ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'All', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 0.1, 'ShowArrowHead', false, ...
                'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));
fprintf('fine! \n');


