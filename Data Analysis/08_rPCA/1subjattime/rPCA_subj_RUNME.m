%% intro
clear all; close all; clc;


%% rpca

% given group of task
ngroup = 1;
nsubj = 7;
data = rpca_subj(nsubj, ngroup);

%% flags for healthy or stroke subj

if nsubj <= 5
	healthy_subj = 1;
else
	healthy_subj = 0;
end

%% Analysis

figure(1)
hold on

if healthy_subj
	plot(data.h.var_expl','b')
else
	plot(data.s.var_expl', 'r')
	plot(data.la.var_expl', 'g')
end

grid on
axis([1, 240, 0, 100])
xlabel('Time [samples] ')
ylabel('% explained variance')

%{
	%% reconstruct 
	[recon_qh, recon_qs, recon_qla] = rpca_recon(ntask);

	ntc = 5;			% Number of Trial Chosen)
	npc_used = 2;%10 + 1;	% number of npc used in the reconstruction
	ntot = 240;			% number of total time frames
	njoints = 10;		% number of joints

	struct_old = rpca_stacker_task(ntask);

	real_trial = reshape(struct_old.q_matrix_la(ntc,:,:), ntot, njoints, 1);

	chosen = reshape(recon_qla(ntc,:,:,npc_used), ntot, njoints, 1);

	%plot
	figure(2)
	clf
	plot(chosen)
	hold on
	plot(real_trial, 'k')
	grid on
	xlabel('Time [samples] ')
	ylabel('Angle joint [deg]')

%}
