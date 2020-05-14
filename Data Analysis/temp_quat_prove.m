%%temp
clear; clc; close
% load('healthy.mat');
% trial  = healthy_task(7).subject(1).right_side_trial(1);
% clear healthy_task;

trial = struct_dataload('H01_T07_L1'); % barbatrucco finché non abbiamo la struttura per bene... PEPOO LAVORA

% 
% t = trial.Forearm_L.Pos;
% %quat_s = quaternion(trial.Shoulder_L.Quat);
% quat_u = quaternion(trial.Upperarm_L.Quat);
% quat_f = quaternion(trial.Forearm_L.Quat);
% quat_h = quaternion(trial.Hand_L.Quat);
% 
% 
% Rs210_l = rotx(-pi/2);
% Rs28_l = rotz(pi)*rotx(pi);

% % for i=1:size(quat_s,1)
% % 	quat_hand(i,1) = quat_s(i) * quat_u(i) * quat_f(i) * quat_h(i);
% % end

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



%% HAND
clear t rotPlot
t = trial.Hand_L.Pos;
quat_h = quaternion(trial.Hand_L.Quat);
Rs210_l = rotx(-pi/2);

for i = 1:size(quat_h,1)
	rotPlot(:,:,i) = quat2rotm(quat_h(i))*Rs210_l;
end

posPlot = t;

samplePeriod = 1/100;
SamplePlotFreq = 1;
Spin = 120;



SixDofAnimation(posPlot, rotPlot, ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'All', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 0.1, 'ShowArrowHead', false, ...
                'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));

fprintf('bravi clap clap');


%% HHHElbow
clear rotPlot t
t = trial.Forearm_L.Pos;
quat_f = quaternion(trial.Forearm_L.Quat);
Rs28_l = rotz(pi)*rotx(pi);

posPlot = t;

for i = 1:size(quat_f,1)
	rotPlot(:,:,i) = quat2rotm(quat_f(i))*Rs28_l;
end

samplePeriod = 1/100;
SamplePlotFreq = 1;
Spin = 120;

SixDofAnimation(posPlot, rotPlot, ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'All', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 0.1, 'ShowArrowHead', false, ...
                'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));

fprintf('bravi clap clap \n');


%% L5
clear rotPlot t
t = trial.L5.Pos;
quat_l5 = quaternion(trial.L5.Quat);
Rs23_l = roty(pi/2)*rotz(pi-par.theta_shoulder.left);

posPlot = t;

for i = 1:size(quat_l5,1)
	rotPlot(:,:,i) = quat2rotm(quat_l5(i))*Rs23_l;
end

samplePeriod = 1/100;
SamplePlotFreq = 1;
Spin = 120;

SixDofAnimation(posPlot, rotPlot, ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'All', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 0.1, 'ShowArrowHead', false, ...
                'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));

fprintf('bravi clap clap');

%%
% %% ROBA
% posPlot = trial.Hand_L.Pos;
% quatPlot = quaternion(trial.Hand_L.Quat);
% 
% samplePeriod = 1/100;
% SamplePlotFreq = 1;
% Spin = 120;
% rotPlot = zeros(3, 3, size(posPlot,1));
% for i= 1:size(posPlot,1)
% 	rotPlot(:,:,i) = roty(-pi/2)*rotx(-pi/2)*quat2rotm(quatPlot(i));
% end
% 
% 
% SixDofAnimation(posPlot, rotPlot, ...
%                 'SamplePlotFreq', SamplePlotFreq, 'Trail', 'All', ...
%                 'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
%                 'AxisLength', 0.1, 'ShowArrowHead', false, ...
%                 'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, ...
%                 'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));
% fprintf('fine! \n');
% 

