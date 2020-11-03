%% fpca calculation for all subj, one at time


%% intro
clear all; close all; clc;
tic

%% parameters
% which of joints we want to analyze
r = [4:7];

% which task groups we want to analyze
ngroup = 'all';

% other parameters
subj_num = 24;
joint_num = 10;
obs_num = 240;

%% creating the struct array
% load dummy struct;
dummy_struct1	= fpca_subj(1,ngroup);
fPCA_subj		= repmat(dummy_struct1,1, subj_num);

for nsubj = 1:subj_num
	%compute fpca for current task 
	disp(['Elaborating subj num ' num2str(nsubj)]);
	struct_fpc = fpca_subj(nsubj, ngroup);
	if nsubj <6
		fPCA_subj(nsubj).h_joint = struct_fpc.h_joint;
		fPCA_subj(nsubj).s_joint = [];
		fPCA_subj(nsubj).la_joint = [];
	else
		fPCA_subj(nsubj).h_joint = [];
		fPCA_subj(nsubj).s_joint = struct_fpc.s_joint;
		fPCA_subj(nsubj).la_joint = struct_fpc.la_joint;
	end
end
toc

%% plot each stroke subject vs healthy mean

% healthy mean calculation
for j = 1:10
	for i = 1:5
		var_h(j,:) =  mean(fPCA_subj(i).h_joint(j).var,2);
	end
end

figure(1)
clf
hold on
for i = 6:24
	for j = 1:10
		var_s(j,:) =  fPCA_subj(i).s_joint(j).var;
		var_la(j,:) =  fPCA_subj(i).la_joint(j).var;
	end
	%plot(cumsum(mean(var_la(r,:),1),2)','g','Displayname', 'less affected')
	plot(cumsum(mean(var_s(r,:),1),2)', 'r','Displayname', 'stroke')
end
grid on
plot(cumsum(mean(var_h(r,:),1),2)','b--' , 'Linewidth', 5)
%plot(cumsum(median(var_h(r,:),1),2)','b--' , 'Linewidth', 5, 'Displayname', 'healthy')
legend
hold off


%% diff la vs stroke median
figure(2)
%var_h(j,:) =  mean(fPCA_subj(i).h_joint(j).var,2);
for i = 6:24
	for j = 1:10
		var_s(j,:)	= fPCA_subj(i).s_joint(j).var';
		var_la(j,:)	= fPCA_subj(i).la_joint(j).var';
	end
	sdiffla(i-5,:) = median(cumsum(var_s(r,:),2),1) - median(cumsum(var_la(r,:),2),1);
end
plot(sdiffla')
grid on

%% plot a subject at a time
close all;
for i = 6:24
	figure(i)

		for j = 1:10
			var_s(j,:)	= fPCA_subj(i).s_joint(j).var';
			var_la(j,:)	= fPCA_subj(i).la_joint(j).var';
		end

	plot(median(cumsum(var_s(r,:),2),1), 'r', 'Displayname', 'stroke');
	title(['subject number ' num2str(i)])
	grid on
	hold on
	plot(median(cumsum(var_la(r,:),2),1), 'g', 'Displayname', 'less affected');
	plot(median(cumsum(var_s(r,:),2),1) - median(cumsum(var_la(r,:),2),1), 'Displayname', 'difference s-la')
	legend
	hold off

end

% is stroke > less affected ?
% subject 6 ye
% subject 7 more or less the same
% subject 8 , var 1 same, var 2 on la>s
% subject 9 nope
% subject 10 ye
% subject 11 ye
% subject 12 ye
% subject 13 yes after first
% subject 14 the same
% subject 15 yes but the same
% subject 16 no but the same first
% subject 17 yes after first
% subject 18 no
% subject 19 yes after first
% subject 20 no
% subject 21 no
% subject 22 no
% subject 23 only the first
% subject 24 no, but the same first




% subject 12no
% subject 13 




