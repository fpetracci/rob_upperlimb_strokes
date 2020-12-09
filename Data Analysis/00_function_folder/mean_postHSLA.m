function [mean_post_h, mean_post_s, mean_post_la] = mean_postHSLA(ngroup, flag_mean)
%MEAN_POST computes the mean posture of rPCs between healthy, strokes and 
%less affected subjects' groups separately.
% Input:
%		ngroup		tasks' group number (1,2,3,'all')
%		flag_mean	1 for doing the mean, 0 for PCA of the means

	% if flag_mean = 0 mean posture is computed as PCA of mean postures of each
	% subject
	% if flag_mean = 1 mean posture is computed as MEAN of mean postures of each
	% subject

	if nargin < 2
		flag_mean = 0;
	end

	%% compute PCA of mean postures, used to comparison
	struct_rPCA = rpca_all_subj(ngroup);
	% creating empty matrices to fill up later
	mean_mat	= [];
	mean_mat_h	= [];
	mean_mat_s	= [];
	mean_mat_la = [];

	% fai mean prima nel tempo per singolo soggetto, poi impili in gruppi di
	% soggetti e poi fai la PCA tra i mean postures dei gruppi, svincoli dal
	% tempo
	for i = [1:10,12:20,22:24]
		if i < 6
			mean_mat_h	= cat(2 , mean_mat_h, mean(struct_rPCA(i).h.mean, 2));
		else
			mean_mat_s	= cat(2 , mean_mat_s, mean(struct_rPCA(i).s.mean, 2));
			mean_mat_la	= cat(2 , mean_mat_la, mean(struct_rPCA(i).la.mean, 2));
		end
	end


	if ~flag_mean		% PC of means
		[mean_post_h,	~, ~, ~, ~, ~] = pca(mean_mat_h');
		[mean_post_s,	~, ~, ~, ~, ~] = pca(mean_mat_s');
		[mean_post_la,	~, ~, ~, ~, ~] = pca(mean_mat_la');
		
	elseif flag_mean	% mean of means
		mean_tmp_h	= mean(mean_mat_h, 2);
		mean_tmp_s	= mean(mean_mat_s, 2);
		mean_tmp_la = mean(mean_mat_la, 2);
		mean_post_h		= [];
		mean_post_s		= [];
		mean_post_la	= [];
		for i = 1:10
			mean_post_h		= cat(2, mean_post_h,	mean_tmp_h);
			mean_post_s		= cat(2, mean_post_s,	mean_tmp_s);
			mean_post_la	= cat(2, mean_post_la,	mean_tmp_la);
		end
	end

end

