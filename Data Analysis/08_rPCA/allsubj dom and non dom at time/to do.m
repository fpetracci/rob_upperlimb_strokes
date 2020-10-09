clc;

for nsubj = [1:20, 22:24]
	clear data_tmp;
	% SKIPPED SUBJ = 21 for ngroup 1 because not enough trials
	data_tmp = rpca_subj(nsubj, ngroup);
	%big_struct(nsubj) = data_tmp;
end