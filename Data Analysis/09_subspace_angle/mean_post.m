function [mean_posture] = mean_post(ngroup, flag_mean)
%MEAN_POST Summary of this function goes here
%   Detailed explanation goes here
%% Load
struct_rPCA = rpca_all_subj(ngroup);

% if flag_mean = 0 mean posture is computed as PCA of mean postures of each
% subject
% if flag_mean = 1 mean posture is computed as MEAN of mean postures of each
% subject

if nargin < 2
	flag_mean = 0;
end

%% compute PCA of mean postures, used to comparison

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

% qua fai tutti i soggetti insieme per avere un'unica PCA di riferimento
% finale
mean_mat = [mean_mat_h, mean_mat_s, mean_mat_la];

if ~flag_mean		% PC of means
	[mean_posture,	~, ~, ~, ~, ~] = pca(mean_mat');
elseif flag_mean	% mean of means
	mean_tmp = mean(mean_mat, 2);
	mean_posture = [];
	for i = 1:10
		mean_posture = cat(2, mean_posture, mean_tmp);
	end
end	
end

