%% intro
clear all; close all; clc;

%% rpca

% given task
ngroup = 1;

data = rpca_all_subj(ngroup);

%% Analysis

figure(1)
clf
hold on
plot(data.h.var_expl([1 ],:)','b')
plot(data.s.var_expl([1 ],:)', 'r')
plot(data.la.var_expl([1 ],:)', 'g')
grid on
axis([1, 240, 0, 100])
xlabel('Time [samples] ')
ylabel('% explained variance')