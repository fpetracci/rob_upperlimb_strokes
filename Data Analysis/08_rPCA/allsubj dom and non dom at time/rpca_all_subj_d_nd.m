function data = rpca_all_subj_d_nd(ngroup)
%RPCA Summary of this function goes here

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


stacked_struct = rpca_stacker_all_subj_d_nd(ngroup);


[ntrial_h, ntot, njoints] = size(stacked_struct.q_matrix_h);
%	ntrial_h	= number of valid healthy trial
%	ntot		= total number of time frames
%	njoints		= number of DOF of the robot-arm
ntrial_a_d		= size(stacked_struct.q_matrix_a_d,		1);	% number of valid a d	trial
ntrial_a_nd		= size(stacked_struct.q_matrix_a_nd,	1); % number of valid a nd	trial
ntrial_la_d		= size(stacked_struct.q_matrix_la_d,	1); % number of valid la d 	trial
ntrial_la_nd	= size(stacked_struct.q_matrix_la_nd,	1); % number of valid la nd trial



%preallocation
npc = 10;

%healthy
var_expl_h	= zeros(npc, ntot);
coeff_h		= zeros(njoints,	npc, ntot);
scores_h	= zeros(ntrial_h,	npc, ntot);

% a_d
var_expl_a_d	= zeros(npc,		ntot);
coeff_a_d		= zeros(njoints,	npc, ntot);
scores_a_d		= zeros(ntrial_a_d,	npc, ntot);

% a_nd
var_expl_a_nd	= zeros(npc,		ntot);
coeff_a_nd		= zeros(njoints,	npc, ntot);
scores_a_nd		= zeros(ntrial_a_nd,	npc, ntot);

% la_d
var_expl_la_d	= zeros(npc,		ntot);
coeff_la_d		= zeros(njoints,	npc, ntot);
scores_la_d		= zeros(ntrial_la_d,	npc, ntot);

% la_nd
var_expl_la_nd	= zeros(npc,		ntot);
coeff_la_nd		= zeros(njoints,	npc, ntot);
scores_la_nd	= zeros(ntrial_la_nd,	npc, ntot);

%% time iteration

for i = 1:ntot
		
		% healthy subj
		mat_qh = reshape(	stacked_struct.q_matrix_h(:, i, :),...
						ntrial_h, njoints, 1);
		%%PCA at specified time frame
		[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qh);
		var_expl_h(:,i)	= explainedi;
		coeff_h(:,:,i)	= coeffi;
		scores_h(:,:,i)	= scorei;
		
		% stroke subj
		% dominant affected subject
		mat_qa_d = reshape(	stacked_struct.q_matrix_a_d(:, i, :),...
							ntrial_a_d, njoints, 1);
						
		mat_qla_d = reshape(	stacked_struct.q_matrix_la_d(:, i, :),...
							ntrial_la_d, njoints, 1);
		% non dominant affected subject				
		mat_qa_nd = reshape(	stacked_struct.q_matrix_a_nd(:, i, :),...
							ntrial_a_nd, njoints, 1);
						
		mat_qla_nd = reshape(	stacked_struct.q_matrix_la_nd(:, i, :),...
							ntrial_la_nd, njoints, 1);
						
						
		%%PCA at specified time frame
		% stroke subj
		% dominant affected subject
		[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qa_d);
		var_expl_a_d(:,i)	= explainedi;
		coeff_a_d(:,:,i)	= coeffi;
		scores_a_d(:,:,i)	= scorei;

		[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qla_d);
		var_expl_la_d(:,i)	= explainedi;
		coeff_la_d(:,:,i)	= coeffi;
		scores_la_d(:,:,i)	= scorei;
		
		% non dominant affected subject
		[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qa_nd);
		var_expl_a_nd(:,i)	= explainedi;
		coeff_a_nd(:,:,i)	= coeffi;
		scores_a_nd(:,:,i)	= scorei;

		[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qla_nd);
		var_expl_la_nd(:,i)	= explainedi;
		coeff_la_nd(:,:,i)	= coeffi;
		scores_la_nd(:,:,i)	= scorei;
end


%% output
datah = struct;
dataa_d = struct;
datala_d = struct;
dataa_nd = struct;
datala_nd = struct;

datah.var_expl = var_expl_h;
datah.coeff = coeff_h;
datah.scores = scores_h;

dataa_d.var_expl = var_expl_a_d;
dataa_d.coeff = coeff_a_d;
dataa_d.scores = scores_a_d;

datala_d.var_expl = var_expl_la_d;
datala_d.coeff = coeff_la_d;
datala_d.scores = scores_la_d;

dataa_nd.var_expl = var_expl_a_nd;
dataa_nd.coeff = coeff_a_nd;
dataa_nd.scores = scores_a_nd;

datala_nd.var_expl = var_expl_la_nd;
datala_nd.coeff = coeff_la_nd;
datala_nd.scores = scores_la_nd;

% final output
data = struct;
data.h = datah;
data.a_d = dataa_d;
data.la_d = datala_d;
data.a_nd = dataa_nd;
data.la_nd = datala_nd;


end

