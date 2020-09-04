function data = rpca(ntask)
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


stacked_struct = rpca_stacker_task(ntask);

%get dimensions for given task
[~, ntot, njoints] = size(stacked_struct.q_matrix_h);
%	ntot		= total number of time frames
%	njoints		= number of DOF of the robot-arm
ntrial_h	= size(stacked_struct.q_matrix_h,	1); % number of valid healthy trial
ntrial_s	= size(stacked_struct.q_matrix_s,	1); % number of valid stroke trial
ntrial_la	= size(stacked_struct.q_matrix_la,	1); % number of valid lessaffected trial


%% time iteration

%preallocation
npc = 10;

%healthy
var_expl_h	= zeros(npc, ntot);
coeff_h		= zeros(njoints,	npc, ntot);
scores_h	= zeros(ntrial_h,	npc, ntot);

%strokes
var_expl_s	= zeros(npc, ntot);
coeff_s		= zeros(njoints,	npc, ntot);
scores_s	= zeros(ntrial_s,	npc, ntot);

%less affected
var_expl_la	= zeros(npc, ntot);
coeff_la	= zeros(njoints,	npc, ntot);
scores_la	= zeros(ntrial_la,	npc, ntot);

for i = 1:ntot

	% temporary matrix given time frame
	mat_qh = reshape(	stacked_struct.q_matrix_h(:, i, :),...
						ntrial_h, njoints, 1);
	mat_qs = reshape(	stacked_struct.q_matrix_s(:, i, :),...
						ntrial_s, njoints, 1);				
	mat_qla = reshape(	stacked_struct.q_matrix_la(:, i, :),...
						ntrial_la, njoints, 1);
					
	%% PCA at specified time frame
	%healthy
	[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qh);
	
	%Oss. pca reports scores and coeff with mean = 0
	% to reconstruct with the first pc:
	% reconstruct = scorei(:,1) * coeffi(:,1)' + mean
	
	%coeffi. njoints x npc
	%	The rows of coeffi contain the coefficients for the 10 joints, and its 
	%	columns correspond to 10 principal components.
	
	%scorei. ntrial x npc
	%	The rows are for each trial, column for each pc
	
	%explainedi. npc x 1
	%	Var explained by each pc
	
	var_expl_h(:,i)	= explainedi;
	coeff_h(:,:,i)	= coeffi;
	scores_h(:,:,i)	= scorei;
	
	% stroke
	[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qs);
	var_expl_s(:,i)	= explainedi;
	coeff_s(:,:,i)	= coeffi;
	scores_s(:,:,i)	= scorei;
	
	%less affected
	[coeffi, scorei, ~, ~, explainedi, ~] = pca(mat_qla);
	var_expl_la(:,i)	= explainedi;
	coeff_la(:,:,i)		= coeffi;
	scores_la(:,:,i)	= scorei;
end


%% output
datah = struct;
datah.var_expl = var_expl_h;
datah.coeff = coeff_h;
datah.scores = scores_h;

datas = struct;
datas.var_expl = var_expl_s;
datas.coeff = coeff_s;
datas.scores = scores_s;

datala = struct;
datala.var_expl = var_expl_la;
datala.coeff = coeff_la;
datala.scores = scores_la;

% final output
data = struct;
data.h = datah;
data.s = datas;
data.la = datala;



end

