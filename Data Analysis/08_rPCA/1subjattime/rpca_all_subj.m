function output = rpca_all_subj(ngroup)
% rpca_all_subj computes rPCA for all subject and stacks them into a single
% array of structures

%% preallocating

nsubj_tot = 24;
%empty_rpca = struct('var_expl', [], 'coeff', [], 'scores', []);
empty_rpca = struct;
empty_rpca2 = struct('h', empty_rpca, 's', empty_rpca, 'la', empty_rpca);
big_struct = repmat(empty_rpca2, 1, nsubj_tot);

%% iteration
for nsubj = [1:10,12:20, 22:24]
	clear data_tmp;
	% SKIPPED SUBJ = 21 (for ngroup 1) because not enough trials 
	% (ntrial < npc)
	% SKIPPED SUBJ = 11 (for ngroup 3) because not enough trials 
	% (ntrial < npc)
	data_tmp = rpca_subj(nsubj, ngroup);
	big_struct(nsubj) = data_tmp;
end

%% output
output = big_struct;

end
