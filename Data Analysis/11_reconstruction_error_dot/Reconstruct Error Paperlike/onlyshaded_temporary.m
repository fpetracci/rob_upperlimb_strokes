close all

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
title('Mean and std of RE H-S-LA, 10R model')
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
title('Mean and std of RE H-S-LA, 7R model')
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
title('Mean and std of RE H-S-LA, 3R model')
xlim([1,10])
ylim([0,inf])
%axis([0 length(err.S.j10.s_mean) 0 max(err.S.j10.la_mean+b*err.S.j10.la_std)])
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12) 

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

legend
xlabel('Number of fPCs used')
ylabel('Reconstruction Error [deg/s]')
title('Mean and std RE Dominant first 3R')
grid on
grid on
set(gca,'FontSize',12)
set(findall(gcf,'type','text'),'FontSize',12)
xlim([1,10])
ylim([0,inf])

