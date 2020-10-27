%% intro
clear all; close all; clc;


%% rpca

% given group of task
ngroup = 1;
nsubj = 2;
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
%% spider plot
if healthy_subj
	figure(6)
	clf;
	D = zeros(10, 3);
	
	%first rPC of healthy subjects
	for i=1:240
		D(:, 1) = data.h.coeff(:, 1, i);
		D(:, 2) = data.h.coeff(:, 2, i);
		D(:, 3) = data.h.coeff(:, 3, i);
		spider_plot_rPCs(D, 'hsl')
		title('Healthy sub: first rPC')
		drawnow
		
	end
		
else
	figure(6)
	clf;
	D = zeros(10, 3);
	D_b = zeros(10, 3);
	%first rPC of strokes subjects
	
	for i=1:240
		D(:, 1) = data.s.coeff(:, 1, i);
		D(:, 2) = data.s.coeff(:, 2, i);
		D(:, 3) = data.s.coeff(:, 3, i);
		
		subplot(1, 2, 1)
		spider_plot_rPCs(D, 'hsl')
		title('strokes sub: first rPC of stroke side')
		
		D_b(:, 1) = data.la.coeff(:, 1, i);
		D_b(:, 2) = data.la.coeff(:, 2, i);
		D_b(:, 3) = data.la.coeff(:, 3, i);
	
		subplot(1, 2, 2)
		spider_plot_rPCs(D_b, 'hsl')
		title('strokes sub: first rPC of less affected side')
		drawnow
	end
end

