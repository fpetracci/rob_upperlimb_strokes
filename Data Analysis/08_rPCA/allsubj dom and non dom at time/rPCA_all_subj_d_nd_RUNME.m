%% intro
clear all; clc;

%% rpca

% given task
ngroup = 1;
ngroup = ['all'];

tic
data = rpca_all_subj_d_nd(ngroup);
toc

%% Analysis

% A,d = red
% LA,d = green
% A,nd = magenta
% LA,nd = cyan


%number of rows I want to sum in explained variance
nrow = 1;
sel = 1:nrow;

figure(1)
clf
hold on
plot(sum(data.h.var_expl(sel,:),1)',		'b',	'Displayname', 'Healthy')

plot(sum(data.a_d.var_expl(sel,:),1)',	'r',	'Displayname', 'A_d')
plot(sum(data.la_d.var_expl(sel,:),1)',	'g',	'Displayname', 'LA_d')

plot(sum(data.a_nd.var_expl(sel,:),1)',	'm',	'Displayname', 'A_{nd}')
plot(sum(data.la_nd.var_expl(sel,:),1)',	'c',	'Displayname', 'LA_{nd}')
grid on
axis([1, 240, 0, 100])
legend
xlabel('Time [samples] ')
ylabel('% explained variance')