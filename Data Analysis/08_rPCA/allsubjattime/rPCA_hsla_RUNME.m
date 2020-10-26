%% intro
clear all; close all; clc;

%% rpca

% given task
ngroup = 1;
%ngroup = 'all';
data = rpca_hsla(ngroup);

%% Analysis sum

%selection of pc
sel= [1 ];

figure(1)
clf
hold on
plot(sum(data.h.var_expl(sel,:),1)','b')
plot(sum(data.s.var_expl(sel,:),1)', 'r')
plot(sum(data.la.var_expl(sel,:),1)', 'g')
grid on
axis([1, 240, 0, 100])
xlabel('Time [samples] ')
ylabel('% explained variance')

%% Analysis

%selection of pc
sel= [1 2];

figure(2)
clf
hold on
plot(data.h.var_expl(sel,:)','b')
plot(data.s.var_expl(sel,:)', 'r')
plot(data.la.var_expl(sel,:)', 'g')
grid on
axis([1, 240, 0, 100])
xlabel('Time [samples] ')
ylabel('% explained variance')

%% spider plot animation
figure(3)
clf;
D = zeros(10, 3);
%first two of healthy subjects
for i=1:240
	D(:, 1) = data.h.coeff(:, 1, i);
	D(:, 2) = data.h.coeff(:, 2, i);
	D(:, 3) = data.h.coeff(:, 3, i);
	spider_plot_rPCs(D, 'hsl')
	drawnow
end