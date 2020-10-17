% Script description

%% functions defined
% function [coeff_rPCs, var_rPCs, scoresMm_rPCs, dom] = rPC_t_subj(t, data_all, nsubj, sel_rPC)

%% intro
clear all; clc;

ngroup = 2;		
%		- ngroup: number between 1, 2 and 3. it selects which group of task
%		we want to analyze. (1 = int, 2 = tr, 3 = tm, 'all' = all tasks)
% load data
data_rPCA_all = rpca_all_subj(ngroup);

%% selected subject e rPCs
nsubj = 13;		% selected subject
rPCs_num = 3;
%% extrapulate angles

rPCsangles_h = [];
rPCsangles_s = [];
rPCsangles_la = [];

for sel_rPC = 1 : rPCs_num
	[angles, dom] = rPC2angle(data_rPCA_all, nsubj, sel_rPC);
	if dom == -1
		rPCsangles_h	= cat(1, rPCsangles_h, angles);
	else
		rPCsangles_s	= cat(1, rPCsangles_s, angles(1,:));
		rPCsangles_la	= cat(1, rPCsangles_la, angles(2,:));
	end
end
%% plot
if dom == -1
	figure(1)
	clf
	plot(rPCsangles_h')
	grid on
	title(['Subspace angle of subj ' num2str(nsubj) ' for rPC ' num2str(sel_rPC)])
	legend('h\_rPC1', 'h\_rPC2', 'h\_rPC3')
	xlim([1 size(rPCsangles_h,2)])
	ylim([0 93])
else
	figure(1)
	clf
	plot(rPCsangles_s')
	grid on	
	if dom
		title(['Subspace angle of A_d subj ' num2str(nsubj) ' for rPC ' num2str(sel_rPC)])
		legend('A_d\_rPC1', 'A_d\_rPC2', 'A_d\_rPC3')
	else
		title(['Subspace angle of A_{nd} subj ' num2str(nsubj) ' for rPC ' num2str(sel_rPC)])
		legend('A_{nd}\_rPC1', 'A_{nd}\_rPC2', 'A_{nd}\_rPC3')
	end
	xlim([1 size(rPCsangles_s,2)])
	ylim([0 93])
	
	figure(2)
	clf
	plot(rPCsangles_la')
	grid on	
	if dom
		title(['Subspace angle of LA_d subj ' num2str(nsubj) ' for rPC ' num2str(sel_rPC)])
		legend('LA_d\_rPC1', 'LA_d\_rPC2', 'LA_d\_rPC3')
	else
		title(['Subspace angle of LA_{nd} subj ' num2str(nsubj) ' for rPC ' num2str(sel_rPC)])
		legend('LA_{nd}\_rPC1', 'LA_{nd}\_rPC2', 'LA_{nd}\_rPC3')
	end
	xlim([1 size(rPCsangles_la,2)])
	ylim([0 93])
end