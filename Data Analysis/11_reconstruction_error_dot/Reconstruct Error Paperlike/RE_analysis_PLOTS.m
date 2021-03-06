% reconstruct error plots, using 3R, 7R, 10R model, for each subject(3R, 7R, 10R)
% and among all the groups taken into account(dominant/nondominant &
% stroke/less affected)

%% each subj
close all 
for i = 1:24
	reconstruct_plot(i)
end

%% reconstruct error with std plots
% mean variance for H, LA and S

% here we want to summarize results of the entire data set into a sigle
% data information. We do that by computing mean and variance (std) of the
% reconstruction error of H, LA and S to evaluate if they correspond to our
% hypoteses. 

% We should also try doing that with subpopulation (impairment >=..., D and
% F and so on)


err = std_rec_error;

b = 1; % width of the mean +- b*sigma plot

%% Healthy
% j10
figure(50)
clf
subplot(1,3,1)
plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
grid on
a = plot(err.H.j10.mean + b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j10.mean - b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend
title('J10: mean and std of reconstruct error')
axis([1 length(err.H.j10.mean) 0 max(err.H.j10.mean+b*err.H.j10.std)])

% j7
subplot(1,3,2)
plot(err.H.j7.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
grid on
a = plot(err.H.j7.mean + b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j7.mean - b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend
title('J7: mean and std of reconstruct error')
axis([1 length(err.H.j7.mean) 0 max(err.H.j7.mean+b*err.H.j7.std)])

% j3
subplot(1,3,3)
plot(err.H.j3.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
grid on
a = plot(err.H.j3.mean + b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j3.mean - b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend
title('J3: mean and std of reconstruct error')
axis([1 length(err.H.j3.mean) 0 max(err.H.j3.mean+b*err.H.j3.std)])
% Stroke

% 

%% healhty-stroke compare

% j10
figure(51)
clf
subplot(1,3,1)
plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.S.j10.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
plot(err.S.j10.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.H.j10.mean + b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j10.mean - b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j10.s_mean + b*err.S.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j10.s_mean - b*err.S.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j10.la_mean + b*err.S.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j10.la_mean - b*err.S.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J10: mean and std of reconstruct error')
axis([1 length(err.H.j10.mean) 0 max(err.H.j10.mean+b*err.H.j10.std)])

% j7
subplot(1,3,2)
plot(err.H.j7.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.S.j7.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
plot(err.S.j7.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.H.j7.mean + b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j7.mean - b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j7.s_mean + b*err.S.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j7.s_mean - b*err.S.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j7.la_mean + b*err.S.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j7.la_mean - b*err.S.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J7: mean and std of reconstruct error')
axis([1 length(err.H.j7.mean) 0 max(err.H.j7.mean+b*err.H.j7.std)])

% j3
subplot(1,3,3)
plot(err.H.j3.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.S.j3.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
plot(err.S.j3.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.H.j3.mean + b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j3.mean - b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j3.s_mean + b*err.S.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j3.s_mean - b*err.S.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j3.la_mean + b*err.S.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j3.la_mean - b*err.S.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J3: mean and std of reconstruct error')
axis([1 length(err.H.j3.mean) 0 max(err.H.j3.mean+b*err.H.j3.std)])

%% healhty-D_stroke compare

% j10
figure(52)
clf
subplot(1,3,1)
plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.D.j10.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
plot(err.D.j10.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.H.j10.mean + b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j10.mean - b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j10.s_mean + b*err.D.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j10.s_mean - b*err.D.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j10.la_mean + b*err.D.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j10.la_mean - b*err.D.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J10_D: mean and std of reconstruct error')
axis([1 length(err.H.j10.mean) 0 max(err.H.j10.mean+b*err.H.j10.std)])

% j7
subplot(1,3,2)
plot(err.H.j7.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.D.j7.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
plot(err.D.j7.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.H.j7.mean + b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j7.mean - b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j7.s_mean + b*err.D.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j7.s_mean - b*err.D.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j7.la_mean + b*err.D.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j7.la_mean - b*err.D.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J7_D: mean and std of reconstruct error')
axis([1 length(err.H.j7.mean) 0 max(err.H.j7.mean+b*err.H.j7.std)])

% j3
subplot(1,3,3)
plot(err.H.j3.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.D.j3.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
plot(err.D.j3.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.H.j3.mean + b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j3.mean - b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j3.s_mean + b*err.D.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j3.s_mean - b*err.D.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j3.la_mean + b*err.D.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j3.la_mean - b*err.D.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J3_D: mean and std of reconstruct error')
axis([1 length(err.H.j3.mean) 0 max(err.H.j3.mean+b*err.H.j3.std)])

%% healhty-F_stroke compare

% j10
figure(53)
clf
subplot(1,3,1)
plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.F.j10.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
plot(err.F.j10.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.H.j10.mean + b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j10.mean - b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j10.s_mean + b*err.F.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j10.s_mean - b*err.F.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j10.la_mean + b*err.F.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j10.la_mean - b*err.F.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J10_F: mean and std of reconstruct error')
axis([1 length(err.H.j10.mean) 0 max(err.H.j10.mean+b*err.H.j10.std)])

% j7
subplot(1,3,2)
plot(err.H.j7.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.F.j7.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
plot(err.F.j7.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.H.j7.mean + b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j7.mean - b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j7.s_mean + b*err.F.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j7.s_mean - b*err.F.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j7.la_mean + b*err.F.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j7.la_mean - b*err.F.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J7_F: mean and std of reconstruct error')
axis([1 length(err.H.j7.mean) 0 max(err.H.j7.mean+b*err.H.j7.std)])

% j3
subplot(1,3,3)
plot(err.H.j3.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.F.j3.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
plot(err.F.j3.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.H.j3.mean + b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j3.mean - b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j3.s_mean + b*err.F.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j3.s_mean - b*err.F.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j3.la_mean + b*err.F.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j3.la_mean - b*err.F.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J3_F: mean and std of reconstruct error')
axis([1 length(err.H.j3.mean) 0 max(err.H.j3.mean+b*err.H.j3.std)])

%% Less Affected-Strokes compare
% j10
figure(54)
clf
subplot(1,3,1)

plot(err.S.j10.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
hold on
plot(err.S.j10.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.S.j10.s_mean + b*err.S.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j10.s_mean - b*err.S.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j10.la_mean + b*err.S.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j10.la_mean - b*err.S.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J10: mean and std of reconstruct error')
axis([1 length(err.S.j10.s_mean) 0 max(err.S.j10.s_mean+b*err.S.j10.s_std)])

% j7
subplot(1,3,2)

plot(err.S.j7.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
hold on
plot(err.S.j7.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.S.j7.s_mean + b*err.S.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j7.s_mean - b*err.S.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j7.la_mean + b*err.S.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j7.la_mean - b*err.S.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J7: mean and std of reconstruct error')
axis([1 length(err.S.j7.s_mean) 0 max(err.S.j7.s_mean+b*err.S.j7.s_std)])

% j3
subplot(1,3,3)

plot(err.S.j3.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
hold on
plot(err.S.j3.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.S.j3.s_mean + b*err.S.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j3.s_mean - b*err.S.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j3.la_mean + b*err.S.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j3.la_mean - b*err.S.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J3: mean and std of reconstruct error')
axis([1 length(err.S.j3.s_mean) 0 max(err.S.j3.s_mean+b*err.S.j3.s_std)])

%% Less Affected-Strokes compare D

% j10
figure(55)
clf
subplot(1,3,1)

plot(err.D.j10.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
hold on
plot(err.D.j10.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.D.j10.s_mean + b*err.D.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j10.s_mean - b*err.D.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j10.la_mean + b*err.D.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j10.la_mean - b*err.D.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J10_D: mean and std of reconstruct error')
axis([1 length(err.D.j10.s_mean) 0 max(err.D.j10.s_mean+b*err.D.j10.s_std)])

% j7
subplot(1,3,2)

plot(err.D.j7.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
hold on
plot(err.D.j7.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.D.j7.s_mean + b*err.D.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j7.s_mean - b*err.D.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j7.la_mean + b*err.D.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j7.la_mean - b*err.D.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J7_D: mean and std of reconstruct error')
axis([1 length(err.D.j7.s_mean) 0 max(err.D.j7.s_mean+b*err.D.j7.s_std)])

% j3
subplot(1,3,3)

plot(err.D.j3.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
hold on
plot(err.D.j3.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.D.j3.s_mean + b*err.D.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j3.s_mean - b*err.D.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j3.la_mean + b*err.D.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j3.la_mean - b*err.D.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J3_D: mean and std of reconstruct error')
axis([1 length(err.D.j3.s_mean) 0 max(err.D.j3.s_mean+b*err.D.j3.s_std)])

%% Less Affected-Strokes compare F
% j10
figure(56)
clf
subplot(1,3,1)

plot(err.F.j10.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
hold on
plot(err.F.j10.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.F.j10.s_mean + b*err.F.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j10.s_mean - b*err.F.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j10.la_mean + b*err.F.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j10.la_mean - b*err.F.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J10_F: mean and std of reconstruct error')
axis([1 length(err.F.j10.s_mean) 0 max(err.F.j10.s_mean+b*err.F.j10.s_std)])

% j7
subplot(1,3,2)

plot(err.F.j7.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
hold on
plot(err.F.j7.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.F.j7.s_mean + b*err.F.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j7.s_mean - b*err.F.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j7.la_mean + b*err.F.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j7.la_mean - b*err.F.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J7_F: mean and std of reconstruct error')
axis([1 length(err.F.j7.s_mean) 0 max(err.F.j7.s_mean+b*err.F.j7.s_std)])

% j3
subplot(1,3,3)

plot(err.F.j3.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
hold on
plot(err.F.j3.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.F.j3.s_mean + b*err.F.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j3.s_mean - b*err.F.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j3.la_mean + b*err.F.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j3.la_mean - b*err.F.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J3_F: mean and std of reconstruct error')
axis([1 length(err.F.j3.s_mean) 0 max(err.F.j3.s_mean+b*err.F.j3.s_std)])

%% D-F
% j10
figure(51)
clf
subplot(1,3,1)
plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.S.j10.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Stroke')
plot(err.S.j10.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected')

a = plot(err.H.j10.mean + b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j10.mean - b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j10.s_mean + b*err.S.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j10.s_mean - b*err.S.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j10.la_mean + b*err.S.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j10.la_mean - b*err.S.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J10: mean and std of reconstruct error')
axis([1 length(err.H.j10.mean) 0 max(err.H.j10.mean+b*err.H.j10.std)])

%%------------------------------------------------------------------------

% j10
figure(60)
clf
subplot(1,2,1)
plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.D.j10.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'D Stroke')
plot(err.F.j10.s_mean, 'm', 'Linewidth', 1.2, 'Displayname', 'F Stroke')

a = plot(err.H.j10.mean + b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j10.mean - b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j10.s_mean + b*err.D.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j10.s_mean - b*err.D.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j10.s_mean + b*err.F.j10.s_std, 'm--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j10.s_mean - b*err.F.j10.s_std, 'm--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J10 D vs F: Stroke mean and std of reconstruct error')
axis([1 length(err.H.j10.mean) 0 max(err.H.j10.mean+b*err.H.j10.std)])

subplot(1,2,2)
plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.D.j10.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'D Less Affected')
plot(err.F.j10.la_mean, 'c', 'Linewidth', 1.2, 'Displayname', 'F Less Affected')

a = plot(err.H.j10.mean + b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j10.mean - b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j10.la_mean + b*err.D.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j10.la_mean - b*err.D.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j10.la_mean + b*err.F.j10.la_std, 'c--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j10.la_mean - b*err.F.j10.la_std, 'c--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('J10 D vs F: Less Affected mean and std of reconstruct error')
axis([1 length(err.H.j10.mean) 0 max(err.H.j10.mean+b*err.H.j10.std)])

% j7
figure(61)
clf
subplot(1,2,1)
plot(err.H.j7.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.D.j7.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'D Stroke')
plot(err.F.j7.s_mean, 'm', 'Linewidth', 1.2, 'Displayname', 'F Stroke')

a = plot(err.H.j7.mean + b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j7.mean - b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j7.s_mean + b*err.D.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j7.s_mean - b*err.D.j7.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j7.s_mean + b*err.F.j7.s_std, 'm--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j7.s_mean - b*err.F.j7.s_std, 'm--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('j7 D vs F: Stroke mean and std of reconstruct error')
axis([1 length(err.H.j7.mean) 0 max(err.H.j7.mean+b*err.H.j7.std)])

subplot(1,2,2)
plot(err.H.j7.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.D.j7.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'D Less Affected')
plot(err.F.j7.la_mean, 'c', 'Linewidth', 1.2, 'Displayname', 'F Less Affected')

a = plot(err.H.j7.mean + b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j7.mean - b*err.H.j7.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j7.la_mean + b*err.D.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j7.la_mean - b*err.D.j7.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j7.la_mean + b*err.F.j7.la_std, 'c--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j7.la_mean - b*err.F.j7.la_std, 'c--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('j7 D vs F: Less Affected mean and std of reconstruct error')
axis([1 length(err.H.j7.mean) 0 max(err.H.j7.mean+b*err.H.j7.std)])

% j3
figure(62)
clf
subplot(1,2,1)
plot(err.H.j3.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.D.j3.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'D Stroke')
plot(err.F.j3.s_mean, 'm', 'Linewidth', 1.2, 'Displayname', 'F Stroke')

a = plot(err.H.j3.mean + b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j3.mean - b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j3.s_mean + b*err.D.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j3.s_mean - b*err.D.j3.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j3.s_mean + b*err.F.j3.s_std, 'm--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j3.s_mean - b*err.F.j3.s_std, 'm--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('j3 D vs F: Stroke mean and std of reconstruct error')
axis([1 length(err.H.j3.mean) 0 max(err.H.j3.mean+b*err.H.j3.std)])

subplot(1,2,2)
plot(err.H.j3.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.D.j3.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'D Less Affected')
plot(err.F.j3.la_mean, 'c', 'Linewidth', 1.2, 'Displayname', 'F Less Affected')

a = plot(err.H.j3.mean + b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j3.mean - b*err.H.j3.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j3.la_mean + b*err.D.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j3.la_mean - b*err.D.j3.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j3.la_mean + b*err.F.j3.la_std, 'c--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j3.la_mean - b*err.F.j3.la_std, 'c--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend
title('j3 D vs F: Less Affected mean and std of reconstruct error')
axis([1 length(err.H.j3.mean) 0 max(err.H.j3.mean+b*err.H.j3.std)])
%% ------------------------------------------------------------------------
%% HEALTHY vs strokeside D & F FIGURA EXTENDED ABSTRACT

% j10
figure(61)
clf
subplot(1,2,1)
plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.S.j10.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'Affected side')
plot(err.S.j10.la_mean, 'g', 'Linewidth', 1.2, 'Displayname', 'Less Affected side')

a = plot(err.H.j10.mean + b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j10.mean - b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j10.s_mean + b*err.S.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j10.s_mean - b*err.S.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.S.j10.la_mean + b*err.S.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j10.la_mean - b*err.S.j10.la_std, 'g--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

xlabel('Number of fPCs used',...
      'Interpreter','Latex')
ylabel('Reconstruction Error [deg/s]',...
      'Interpreter','Latex')
legend
%title('Mean and std of reconstruction error', 'Interpreter','Latex')
axis([0 length(err.H.j10.mean) 0 max(err.H.j10.mean+b*err.H.j10.std)])

% j10
subplot(1,2,2)
plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on
plot(err.D.j10.s_mean, 'r', 'Linewidth', 1.2, 'Displayname', 'D Affected side')
plot(err.F.j10.s_mean, 'm', 'Linewidth', 1.2, 'Displayname', 'F Affected side')

a = plot(err.H.j10.mean + b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j10.mean - b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.D.j10.s_mean + b*err.D.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j10.s_mean - b*err.D.j10.s_std, 'r--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot(err.F.j10.s_mean + b*err.F.j10.s_std, 'm--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j10.s_mean - b*err.F.j10.s_std, 'm--', 'Linewidth', 0.8);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
xlabel('Number of fPCs used',...
      'Interpreter','Latex')
ylabel('Reconstruction Error [deg/s]',...
      'Interpreter','Latex')

legend
%title('Stroke side mean and std of reconstruction error', 'Interpreter','Latex')
axis([0 length(err.H.j10.mean) 0 max(err.H.j10.mean+b*err.H.j10.std)])

%% figureshaded H S LA

b = 1;
figure(61)
clf
% plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on


% a = plot(err.H.j10.mean + b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.H.j10.mean - b*err.H.j10.std, 'b--', 'Linewidth', 0.8);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';

% a = plot(err.S.j10.s_mean + b*err.S.j10.s_std, 'r--', 'Linewidth', 0.8);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.S.j10.s_mean - b*err.S.j10.s_std, 'r--', 'Linewidth', 0.8);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% a = plot(err.S.j10.la_mean + b*err.S.j10.la_std, 'g--', 'Linewidth', 0.8);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.S.j10.la_mean - b*err.S.j10.la_std, 'g--', 'Linewidth', 0.8);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';


x2 = [1:10, fliplr(1:10)];
inBetween3 = [err.H.j10.mean + b*err.H.j10.std, fliplr(err.H.j10.mean - b*err.H.j10.std)];
a = fill(x2, inBetween3, 'b' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween1 = [err.S.j10.s_mean + b*err.S.j10.s_std, fliplr(err.S.j10.s_mean - b*err.S.j10.s_std)];
a = fill(x2, inBetween1, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween2 = [err.S.j10.la_mean + b*err.S.j10.la_std, fliplr(err.S.j10.la_mean - b*err.S.j10.la_std)];
a = fill(x2, inBetween2, 'g','EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a.FaceColor = [0, 0.3, 0.08];

hold on
plot(err.S.j10.s_mean, 'r', 'Linewidth', 1, 'Displayname', 'Affected side')
plot(err.S.j10.la_mean, 'Color', [0 220 30]/255, 'Linewidth', 1, 'Displayname', 'Less Affected side')
plot(err.H.j10.mean, 'b', 'Linewidth', 1, 'Displayname', 'Healthy')
a = plot(err.S.j10.s_mean, 'dr' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.S.j10.la_mean, 'dg' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.H.j10.mean, 'db' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

xlabel('Number of fPCs used')
ylabel('Reconstruction Error [deg/s]')

grid on
legend
title('Mean and std of RE H-S-LA')
xlim([1,10])
ylim([0,inf])
%axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12)
%% figureshaded H S LA

b = 1;
figure(62)
clf
% plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on

x2 = [1:10, fliplr(1:10)];
inBetween3 = [err.H.j7.mean + b*err.H.j7.std, fliplr(err.H.j7.mean - b*err.H.j7.std)];
a = fill(x2, inBetween3, 'b' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween1 = [err.S.j7.s_mean + b*err.S.j7.s_std, fliplr(err.S.j7.s_mean - b*err.S.j7.s_std)];
a = fill(x2, inBetween1, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween2 = [err.S.j7.la_mean + b*err.S.j7.la_std, fliplr(err.S.j7.la_mean - b*err.S.j7.la_std)];
a = fill(x2, inBetween2, 'g','EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a.FaceColor = [0, 0.3, 0.08];

hold on
plot(err.S.j7.s_mean, 'r', 'Linewidth', 1, 'Displayname', 'Affected side')
plot(err.S.j7.la_mean, 'Color', [0 220 30]/255, 'Linewidth', 1, 'Displayname', 'Less Affected side')
plot(err.H.j7.mean, 'b', 'Linewidth', 1, 'Displayname', 'Healthy')


xlabel('Number of fPCs used')
ylabel('Reconstruction Error [deg/s]')
legend
grid on
%title('Mean and std of reconstruction error', 'Interpreter','Latex')
title('Mean and std of RE ')
xlim([1,10])
ylim([0,inf])
%axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12)

%%
b = 1;
figure(63)
clf
% plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on

x2 = [1:10, fliplr(1:10)];
inBetween3 = [err.H.j3.mean + b*err.H.j3.std, fliplr(err.H.j3.mean - b*err.H.j3.std)];
a = fill(x2, inBetween3, 'b' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween1 = [err.S.j3.s_mean + b*err.S.j3.s_std, fliplr(err.S.j3.s_mean - b*err.S.j3.s_std)];
a = fill(x2, inBetween1, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween2 = [err.S.j3.la_mean + b*err.S.j3.la_std, fliplr(err.S.j3.la_mean - b*err.S.j3.la_std)];
a = fill(x2, inBetween2, 'g','EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a.FaceColor = [0, 0.3, 0.08];

hold on
plot(err.S.j3.s_mean, 'r', 'Linewidth', 1, 'Displayname', 'Affected side')
plot(err.S.j3.la_mean, 'Color', [0 220 30]/255, 'Linewidth', 1, 'Displayname', 'Less Affected side')
plot(err.H.j3.mean, 'b', 'Linewidth', 1, 'Displayname', 'Healthy')


xlabel('Number of fPCs used')
ylabel('Reconstruction Error [deg/s]')
legend
%title('Mean and std of reconstruction error', 'Interpreter','Latex')
xlim([1,10])
ylim([0,inf])
%axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12) 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIGURE CON HEALTHY
%% 10 Dominant stroke vs la mean
b = 1;
figure(64)
clf
% plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on

x2 = [1:10, fliplr(1:10)];
% inBetween3 = [err.H.j10.mean + b*err.H.j10.std, fliplr(err.H.j10.mean - b*err.H.j10.std)];
% a = fill(x2, inBetween3, 'b' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween1 = [err.D.j10.s_mean + b*err.D.j10.s_std, fliplr(err.D.j10.s_mean - b*err.D.j10.s_std)];
a = fill(x2, inBetween1, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween2 = [err.D.j10.la_mean + b*err.D.j10.la_std, fliplr(err.D.j10.la_mean - b*err.D.j10.la_std)];
a = fill(x2, inBetween2, 'g','EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a.FaceColor = [0, 0.3, 0.08];

hold on
plot(err.D.j10.s_mean, 'r', 'Linewidth', 1, 'Displayname', 'Affected side')
plot(err.D.j10.la_mean, 'Color', [0 220 30]/255, 'Linewidth', 1, 'Displayname', 'Less Affected side')
% plot(err.H.j10.mean, 'b', 'Linewidth', 1, 'Displayname', 'Healthy')
%asterisks
a = plot(err.D.j10.s_mean, 'dr' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j10.la_mean, 'dg' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.H.j10.mean, 'db' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
xlabel('Number of fPCs used')
ylabel('Reconstruction Error [deg/s]')
legend
title('Mean and std RE Dominant 10R')
grid on
xlim([1,10])
ylim([0,inf])
%axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12)
%% 7 Dominant stroke vs la mean 
b = 1;
figure(65)
clf
% plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on

x2 = [1:10, fliplr(1:10)];
% inBetween3 = [err.H.j7.mean + b*err.H.j7.std, fliplr(err.H.j7.mean - b*err.H.j7.std)];
% a = fill(x2, inBetween3, 'b' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween1 = [err.D.j7.s_mean + b*err.D.j7.s_std, fliplr(err.D.j7.s_mean - b*err.D.j7.s_std)];
a = fill(x2, inBetween1, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween2 = [err.D.j7.la_mean + b*err.D.j7.la_std, fliplr(err.D.j7.la_mean - b*err.D.j7.la_std)];
a = fill(x2, inBetween2, 'g','EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a.FaceColor = [0, 0.3, 0.08];

hold on
plot(err.D.j7.s_mean, 'r', 'Linewidth', 1, 'Displayname', 'Affected side')
plot(err.D.j7.la_mean, 'Color', [0 220 30]/255, 'Linewidth', 1, 'Displayname', 'Less Affected side')
% plot(err.H.j7.mean, 'b', 'Linewidth', 1, 'Displayname', 'Healthy')
a = plot(err.D.j7.s_mean, 'dr' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j7.la_mean, 'dg' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.H.j7.mean, 'db' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';

xlim([1,10])
ylim([0,inf])
grid on
xlabel('Number of fPCs used')
ylabel('Reconstruction Error [deg/s]')
legend
title('Mean and std RE Dominant last 7R')
%axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12)
%% 3 Dominant stroke vs la mean 

b = 1;
figure(66)
clf
% plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on

x2 = [1:10, fliplr(1:10)];
% inBetween3 = [err.H.j3.mean + b*err.H.j3.std, fliplr(err.H.j3.mean - b*err.H.j3.std)];
% a = fill(x2, inBetween3, 'b' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween1 = [err.D.j3.s_mean + b*err.D.j3.s_std, fliplr(err.D.j3.s_mean - b*err.D.j3.s_std)];
a = fill(x2, inBetween1, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween2 = [err.D.j3.la_mean + b*err.D.j3.la_std, fliplr(err.D.j3.la_mean - b*err.D.j3.la_std)];
a = fill(x2, inBetween2, 'g','EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a.FaceColor = [0, 0.3, 0.08];

hold on
plot(err.D.j3.s_mean, 'r', 'Linewidth', 1, 'Displayname', 'Affected side')
plot(err.D.j3.la_mean, 'Color', [0 220 30]/255, 'Linewidth', 1, 'Displayname', 'Less Affected side')
% plot(err.H.j3.mean, 'b', 'Linewidth', 1, 'Displayname', 'Healthy')
a = plot(err.D.j3.s_mean, 'dr' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.D.j3.la_mean, 'dg' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.H.j3.mean, 'db' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';

xlabel('Number of fPCs used')
ylabel('Reconstruction Error [deg/s]')
legend
title('Mean and std RE Dominant first 3R')
xlim([1,10])
ylim([0,inf])
grid on
%axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12)
%% 10 Non-Dominant stroke vs la mean
b = 1;
figure(67)
clf
% plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on

x2 = [1:10, fliplr(1:10)];
% inBetween3 = [err.H.j10.mean + b*err.H.j10.std, fliplr(err.H.j10.mean - b*err.H.j10.std)];
% a = fill(x2, inBetween3, 'b' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween1 = [err.F.j10.s_mean + b*err.F.j10.s_std, fliplr(err.F.j10.s_mean - b*err.F.j10.s_std)];
a = fill(x2, inBetween1, 'm' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween2 = [err.F.j10.la_mean + b*err.F.j10.la_std, fliplr(err.F.j10.la_mean - b*err.F.j10.la_std)];
a = fill(x2, inBetween2, 'c','EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a.FaceColor = [0, 0.3, 0.08];

hold on
plot(err.F.j10.s_mean, 'm', 'Linewidth', 1, 'Displayname', 'Affected side')
plot(err.F.j10.la_mean, 'c', 'Linewidth', 1, 'Displayname', 'Less Affected side')
% plot(err.H.j10.mean, 'b', 'Linewidth', 1, 'Displayname', 'Healthy')
a = plot(err.F.j10.s_mean, 'dm' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j10.la_mean, 'dc' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.H.j10.mean, 'db' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
xlabel('Number of fPCs used')
ylabel('Reconstruction Error [deg/s]')
legend
title('Mean and std RE Non-Dominant 10R')
xlim([1,10])
ylim([0,inf])
grid on
%axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12)
%% 7 Non-Dominant stroke vs la mean 
b = 1;
figure(68)
clf
% plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on

x2 = [1:10, fliplr(1:10)];
% inBetween3 = [err.H.j7.mean + b*err.H.j7.std, fliplr(err.H.j7.mean - b*err.H.j7.std)];
% a = fill(x2, inBetween3, 'b' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween1 = [err.F.j7.s_mean + b*err.F.j7.s_std, fliplr(err.F.j7.s_mean - b*err.F.j7.s_std)];
a = fill(x2, inBetween1, 'm' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween2 = [err.F.j7.la_mean + b*err.F.j7.la_std, fliplr(err.F.j7.la_mean - b*err.F.j7.la_std)];
a = fill(x2, inBetween2, 'c','EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a.FaceColor = [0, 0.3, 0.08];

hold on
plot(err.F.j7.s_mean, 'm', 'Linewidth', 1, 'Displayname', 'Affected side')
plot(err.F.j7.la_mean, 'c', 'Linewidth', 1, 'Displayname', 'Less Affected side')
% plot(err.H.j7.mean, 'b', 'Linewidth', 1, 'Displayname', 'Healthy')
a = plot(err.F.j7.s_mean, 'dr' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j7.la_mean, 'dg' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.H.j7.mean, 'db' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';

xlabel('Number of fPCs used')
ylabel('Reconstruction Error [deg/s]')
legend
title('Mean and std RE Non-Dominant last 7R')
%axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
xlim([1,10])
ylim([0,inf])
grid on
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12)
%% 3 Non-Dominant stroke vs la mean 

b = 1;
figure(69)
clf
% plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
hold on

x2 = [1:10, fliplr(1:10)];
inBetween3 = [err.H.j3.mean + b*err.H.j3.std, fliplr(err.H.j3.mean - b*err.H.j3.std)];
% a = fill(x2, inBetween3, 'b' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween1 = [err.F.j3.s_mean + b*err.F.j3.s_std, fliplr(err.F.j3.s_mean - b*err.F.j3.s_std)];
a = fill(x2, inBetween1, 'm' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

inBetween2 = [err.F.j3.la_mean + b*err.F.j3.la_std, fliplr(err.F.j3.la_mean - b*err.F.j3.la_std)];
a = fill(x2, inBetween2, 'c','EdgeAlpha', 0, 'FaceAlpha', 0.1);
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a.FaceColor = [0, 0.3, 0.08];

hold on
plot(err.F.j3.s_mean, 'm', 'Linewidth', 1, 'Displayname', 'Affected side')
plot(err.F.j3.la_mean, 'c', 'Linewidth', 1, 'Displayname', 'Less Affected side')
% plot(err.H.j3.mean, 'b', 'Linewidth', 1, 'Displayname', 'Healthy')
a = plot(err.F.j3.s_mean, 'dr' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot(err.F.j3.la_mean, 'dg' );
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.H.j3.mean, 'db' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';


xlabel('Number of fPCs used')
ylabel('Reconstruction Error [deg/s]')
legend
title('Mean and std RE Non-Dominant first 3R')
xlim([1,10])
ylim([0,inf])
grid on
%axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FIGURE WITHOUT HEALTHY
% %% 10 Dominant stroke vs la mean
% b = 1;
% figure(64)
% clf
% % plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
% hold on
% 
% x2 = [1:10, fliplr(1:10)];
% 
% inBetween1 = [err.D.j10.s_mean + b*err.D.j10.s_std, fliplr(err.D.j10.s_mean - b*err.D.j10.s_std)];
% a = fill(x2, inBetween1, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% inBetween2 = [err.D.j10.la_mean + b*err.D.j10.la_std, fliplr(err.D.j10.la_mean - b*err.D.j10.la_std)];
% a = fill(x2, inBetween2, 'g','EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a.FaceColor = [0, 0.3, 0.08];
% 
% hold on
% plot(err.D.j10.s_mean, 'r', 'Linewidth', 1, 'Displayname', 'Affected side')
% plot(err.D.j10.la_mean, 'Color', [0 220 30]/255, 'Linewidth', 1, 'Displayname', 'Less Affected side')
% %asterisks
% a = plot(err.D.j10.s_mean, 'dr' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.D.j10.la_mean, 'dg' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% xlabel('Number of fPCs used')
% ylabel('Reconstruction Error [deg/s]')
% legend
% title('Mean and std RE Dominant 10R')
% %axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
% set(gca,'FontSize',12)
% set(findall(gcf,'type','text'),'FontSize',12)
% %% 7 Dominant stroke vs la mean 
% b = 1;
% figure(65)
% clf
% % plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
% hold on
% 
% x2 = [1:10, fliplr(1:10)];
% 
% inBetween1 = [err.D.j7.s_mean + b*err.D.j7.s_std, fliplr(err.D.j7.s_mean - b*err.D.j7.s_std)];
% a = fill(x2, inBetween1, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% inBetween2 = [err.D.j7.la_mean + b*err.D.j7.la_std, fliplr(err.D.j7.la_mean - b*err.D.j7.la_std)];
% a = fill(x2, inBetween2, 'g','EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a.FaceColor = [0, 0.3, 0.08];
% 
% hold on
% plot(err.D.j7.s_mean, 'r', 'Linewidth', 1, 'Displayname', 'Affected side')
% plot(err.D.j7.la_mean, 'Color', [0 220 30]/255, 'Linewidth', 1, 'Displayname', 'Less Affected side')
% a = plot(err.D.j7.s_mean, 'dr' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.D.j7.la_mean, 'dg' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% xlabel('Number of fPCs used')
% ylabel('Reconstruction Error [deg/s]')
% legend
% title('Mean and std RE Dominant last 7R')
% %axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
% set(gca,'FontSize',12)
% set(findall(gcf,'type','text'),'FontSize',12)
% %% 3 Dominant stroke vs la mean 
% 
% b = 1;
% figure(66)
% clf
% % plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
% hold on
% 
% x2 = [1:10, fliplr(1:10)];
% 
% inBetween1 = [err.D.j3.s_mean + b*err.D.j3.s_std, fliplr(err.D.j3.s_mean - b*err.D.j3.s_std)];
% a = fill(x2, inBetween1, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% inBetween2 = [err.D.j3.la_mean + b*err.D.j3.la_std, fliplr(err.D.j3.la_mean - b*err.D.j3.la_std)];
% a = fill(x2, inBetween2, 'g','EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a.FaceColor = [0, 0.3, 0.08];
% 
% hold on
% plot(err.D.j3.s_mean, 'r', 'Linewidth', 1, 'Displayname', 'Affected side')
% plot(err.D.j3.la_mean, 'Color', [0 220 30]/255, 'Linewidth', 1, 'Displayname', 'Less Affected side')
% a = plot(err.D.j3.s_mean, 'dr' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.D.j3.la_mean, 'dg' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% xlabel('Number of fPCs used')
% ylabel('Reconstruction Error [deg/s]')
% legend
% title('Mean and std RE Dominant first 3R')
% %axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
% set(gca,'FontSize',12)
% set(findall(gcf,'type','text'),'FontSize',12)
% %% 10 Non-Dominant stroke vs la mean
% b = 1;
% figure(67)
% clf
% % plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
% hold on
% 
% x2 = [1:10, fliplr(1:10)];
% 
% inBetween1 = [err.F.j10.s_mean + b*err.F.j10.s_std, fliplr(err.F.j10.s_mean - b*err.F.j10.s_std)];
% a = fill(x2, inBetween1, 'm' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% inBetween2 = [err.F.j10.la_mean + b*err.F.j10.la_std, fliplr(err.F.j10.la_mean - b*err.F.j10.la_std)];
% a = fill(x2, inBetween2, 'c','EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a.FaceColor = [0, 0.3, 0.08];
% 
% hold on
% plot(err.F.j10.s_mean, 'm', 'Linewidth', 1, 'Displayname', 'Affected side')
% plot(err.F.j10.la_mean, 'c', 'Linewidth', 1, 'Displayname', 'Less Affected side')
% a = plot(err.F.j10.s_mean, 'dm' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.F.j10.la_mean, 'dc' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% xlabel('Number of fPCs used')
% ylabel('Reconstruction Error [deg/s]')
% legend
% title('Mean and std RE Non-Dominant 10R')
% %axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
% set(gca,'FontSize',12)
% set(findall(gcf,'type','text'),'FontSize',12)
% %% 7 Non-Dominant stroke vs la mean 
% b = 1;
% figure(68)
% clf
% % plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
% hold on
% 
% x2 = [1:10, fliplr(1:10)];
% inBetween1 = [err.F.j7.s_mean + b*err.F.j7.s_std, fliplr(err.F.j7.s_mean - b*err.F.j7.s_std)];
% a = fill(x2, inBetween1, 'm' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% inBetween2 = [err.F.j7.la_mean + b*err.F.j7.la_std, fliplr(err.F.j7.la_mean - b*err.F.j7.la_std)];
% a = fill(x2, inBetween2, 'c','EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a.FaceColor = [0, 0.3, 0.08];
% 
% hold on
% plot(err.F.j7.s_mean, 'm', 'Linewidth', 1, 'Displayname', 'Affected side')
% plot(err.F.j7.la_mean, 'c', 'Linewidth', 1, 'Displayname', 'Less Affected side')
% a = plot(err.F.j7.s_mean, 'dr' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.F.j7.la_mean, 'dg' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% xlabel('Number of fPCs used')
% ylabel('Reconstruction Error [deg/s]')
% legend
% title('Mean and std RE Non-Dominant last 7R')
% %axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
% set(gca,'FontSize',12)
% set(findall(gcf,'type','text'),'FontSize',12)
% %% 3 Non-Dominant stroke vs la mean 
% 
% b = 1;
% figure(69)
% clf
% % plot(err.H.j10.mean, 'b', 'Linewidth', 1.2, 'Displayname', 'Healthy')
% hold on
% 
% x2 = [1:10, fliplr(1:10)];
% 
% inBetween1 = [err.F.j3.s_mean + b*err.F.j3.s_std, fliplr(err.F.j3.s_mean - b*err.F.j3.s_std)];
% a = fill(x2, inBetween1, 'm' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% inBetween2 = [err.F.j3.la_mean + b*err.F.j3.la_std, fliplr(err.F.j3.la_mean - b*err.F.j3.la_std)];
% a = fill(x2, inBetween2, 'c','EdgeAlpha', 0, 'FaceAlpha', 0.1);
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a.FaceColor = [0, 0.3, 0.08];
% 
% hold on
% plot(err.F.j3.s_mean, 'm', 'Linewidth', 1, 'Displayname', 'Affected side')
% plot(err.F.j3.la_mean, 'c', 'Linewidth', 1, 'Displayname', 'Less Affected side')
% a = plot(err.F.j3.s_mean, 'dr' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% a = plot(err.F.j3.la_mean, 'dg' );
% a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% 
% xlabel('Number of fPCs used')
% ylabel('Reconstruction Error [deg/s]')
% legend
% title('Mean and std RE Non-Dominant first 3R')
% %axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
% set(gca,'FontSize',12)
% set(findall(gcf,'type','text'),'FontSize',12)
%%
	%f.WindowState = 'maximize';
	%% with healty
	set(gca,'FontSize',13)
	set(findall(gcf,'type','text'),'FontSize',13)
	set(gcf, 'Position',  [200, 0, 650, 650])
	grid on
	f = gcf;
%	exportgraphics(f,['subj18_RE.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
%	exportgraphics(f,['subj24_RE.pdf'],'BackgroundColor','none', 'ContentType','vector') 
 	exportgraphics(f,['shadow_HSLA_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
% 	exportgraphics(f,['shadow_D_10_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
% 	exportgraphics(f,['shadow_D_7_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
% 	exportgraphics(f,['shadow_D_3_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
% 	exportgraphics(f,['shadow_ND_10_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
% 	exportgraphics(f,['shadow_ND_7_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i)
% 	exportgraphics(f,['shadow_ND_3_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
%% without healty
% 	set(gca,'FontSize',13)
% 	set(findall(gcf,'type','text'),'FontSize',13)
% 	set(gcf, 'Position',  [200, 0, 650, 650])
% 	grid on
% 	f = gcf;
	%f.WindowState = 'maximize';
%	exportgraphics(f,['shadow_SLA_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
%	exportgraphics(f,['shadow_D_10_NOH_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
% 	exportgraphics(f,['shadow_D_7_NOH_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
% 	exportgraphics(f,['shadow_D_3_NOH_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
% 	exportgraphics(f,['shadow_ND_10_NOH_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 
% 	exportgraphics(f,['shadow_ND_7_NOH_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i)
%	exportgraphics(f,['shadow_ND_3_NOH_dot.pdf'], 'ContentType','vector','BackgroundColor','none') %num2str(i) 