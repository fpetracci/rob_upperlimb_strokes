%% intro
clear all; close all; clc;


%% rpca

% given group of task
ngroup = 1;
data_all = rpca_all_subj(ngroup);

% flag for avoid plotting results.
%			1 for have the plots
%			0 for skipping the plots
plot_mode = 0;


%% plots
if plot_mode
%%subject info

%{
	subj_Ad			=	[7  8  9  11 14 15 19 20 22 23 24];
	subj_Ad_FMMA	=	[55 55 38 47 43 37 61 42 60 46 21];
	subj_And		=	[6  10 12 13 16 17 18 21];
	subj_And_FMMA	=	[54 41 40 49 53 59 37 48];
%}

%subj_Ad: -1 for healthy, 1 for Ad, 0 for And
% Ad = affected on dominant side
% And = affected on non-dominant side
subj_Ad = [	-1	-1	-1	-1	-1 ...% healthy
			0	1	1	1	0	1	0	0	1	1	0	0	0	1	1	NaN	1	1	1];
		%	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24
subj_FMMA =[	-1	-1	-1	-1	-1 ...% healthy
				54	55	55	38	41	47	40	49	43	37	53	59	37	61	42	48	60	46	21];
		%		6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24

		
		
%%figure iteration
for nsubj = [1:20, 22:24]
	% SKIPPED SUBJ = 21 (for ngroup 1) because not enough trials 
	% (ntrial < npc)
	clear data;
	data = data_all(nsubj);
	
	if nsubj <= 5
		figure(nsubj)
		hold on
		plot(data.h.var_expl','b')
		%plot(data.s.var_expl', 'r')
		%plot(data.la.var_expl', 'g')
		grid on
		axis([1, 240, 0, 100])
		xlabel('Time [samples] ')
		ylabel('% explained variance')
		title(['Healthy subject number ' num2str(nsubj)])
	else
		figure(nsubj)
		hold on
		%plot(data.h.var_expl','b')
		plot(data.s.var_expl', 'r')
		plot(data.la.var_expl', 'g')
		grid on
		axis([1, 240, 0, 100])
		xlabel('Time [samples] ')
		ylabel('% explained variance')
		
		if subj_Ad(nsubj)
			title_str = ['Aff Dominant subject, num: ' num2str(nsubj) ' FMMA: ' num2str(subj_FMMA(nsubj))];
		else
			title_str = ['Aff non Dominant subject, num: ' num2str(nsubj) ' FMMA: ' num2str(subj_FMMA(nsubj))];
		end
		title(title_str)
		
		%legend(['Affected side' 'Less Affected side'])
	end
	
end
% FPCA valeva:
% A,d:		var alta, RE basso
% A,nd: 	var bassa, RE alto
% 
% LA,d: 	
% LA,nd:


% RPCA cosa notiamo?
% varianza nei soggeti stroke e` piu` bassa per le prime componenti
% principali (distribuita piu` uniforme) e indica che ci sono degli
% accoppiamenti non voluti in piu`. Ci aspettiamo che la var sia piu` bassa
% per i dom rispetto non dom ( DOM < NON DOM ) e quindi che ci siano piu`
% accoppiamenti patologici ( per ricordare: flessione gomito diventa flex
% gomito + flex polso )

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
end