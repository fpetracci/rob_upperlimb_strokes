function data = rpca_subj(nsubj, ngroup)
%RPCA_subj computes the rPCA of a given subject and a given group of tasks

%% Intro and stacking
% brief description of PCA
% Xi (nobs x ndof) one for each time sample i
% [coeff,score,latent,tsquared,explained,mu] = pca(___)
%	coeff		= svd values
%	score		= scores (eigenvector for reconstruction)
%	latent		= explained variances
%	tsquared	= Hotelling's T-squared statistic for each observation in X
%	explained	= the percentage of the total variance explained by each principal component 
%	mu			= estimated mean of each variable in X 
%
% we will use:
%	[coeffi, scorei, ~, ~, explainedi, ~] = pca(Xi)


stacked_struct = rpca_stacker_subj(nsubj, ngroup);

if nsubj <= 5
	% healthy subject
	[ntrial_h, ntot, njoints] = size(stacked_struct.q_matrix_h);
	%	ntrial_h	= number of valid healthy trial
	%	ntot		= total number of time frames
	%	njoints		= number of DOF of the robot-arm
	
	%preallocation
	npc = 10;

	%healthy
	var_expl_h	= zeros(npc,		ntot);
	coeff_h		= zeros(njoints,	npc, ntot);
	scores_h	= zeros(ntrial_h,	npc, ntot);
	mean_h		= zeros(njoints,	ntot);
	
else
	% stroke subject
	[~, ntot, njoints] = size(stacked_struct.q_matrix_s);
	ntrial_s	= size(stacked_struct.q_matrix_s,	1); % number of valid stroke trial
	ntrial_la	= size(stacked_struct.q_matrix_la,	1); % number of valid lessaffected trial
	
	%preallocation
	npc = 10;

	%strokes
	var_expl_s	= zeros(npc,		ntot);
	coeff_s		= zeros(njoints,	npc, ntot);
	scores_s	= zeros(ntrial_s,	npc, ntot);
	mean_s		= zeros(njoints,	ntot);
	
	%less affected
	var_expl_la	= zeros(npc,		ntot);
	coeff_la	= zeros(njoints,	npc, ntot);
	scores_la	= zeros(ntrial_la,	npc, ntot);
	mean_la		= zeros(njoints,	ntot);
	
end
	
%% time iteration

for i = 1:ntot
	
	if nsubj <= 5
		% healthy
		
		% temporary matrix given time frame
		mat_qh = reshape(	stacked_struct.q_matrix_h(:, i, :),...
						ntrial_h, njoints, 1);
		%%PCA at specified time frame
		%healthy
		[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qh);
		var_expl_h(:,i)	= explainedi;
		coeff_h(:,:,i)	= coeffi;
		scores_h(:,:,i)	= scorei;
		mean_h(:,i) = mean(mat_qh, 1)';
	else
		% stroke
		
		% temporary matrix given time frame
		mat_qs = reshape(	stacked_struct.q_matrix_s(:, i, :),...
							ntrial_s, njoints, 1);				
		mat_qla = reshape(	stacked_struct.q_matrix_la(:, i, :),...
							ntrial_la, njoints, 1);
		%%PCA at specified time frame
		% stroke
		[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qs);
		var_expl_s(:,i)	= explainedi;
		coeff_s(:,:,i)	= coeffi;
		scores_s(:,:,i)	= scorei;
		mean_s(:,i)		= mean(mat_qs, 1)';

		%less affected
		[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qla);
		var_expl_la(:,i)	= explainedi;
		coeff_la(:,:,i)		= coeffi;
		scores_la(:,:,i)	= scorei;
		mean_la(:,i)		= mean(mat_qla, 1)';
	end
end


%% output
datah = struct;
datas = struct;
datala = struct;

if nsubj <= 5
	datah.var_expl	= var_expl_h;
	datah.coeff		= coeff_h;
	datah.scores	= scores_h;
	datah.mean		= mean_h;

else
	datas.var_expl	= var_expl_s;
	datas.coeff		= coeff_s;
	datas.scores	= scores_s;
	datas.mean		= mean_s;

	datala.var_expl	= var_expl_la;
	datala.coeff	= coeff_la;
	datala.scores	= scores_la;
	datala.mean		= mean_la;
end

% final output
data = struct;
data.h = datah;
data.s = datas;
data.la = datala;



end

